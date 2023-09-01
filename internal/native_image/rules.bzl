"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@build_bazel_apple_support//lib:apple_support.bzl",
    "apple_support",
)
load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "@bazel_skylib//lib:paths.bzl",
    "paths",
)
load(
    "@bazel_tools//tools/cpp:toolchain_utils.bzl",
    "find_cpp_toolchain",
)
load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    "CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME",
    "CPP_LINK_EXECUTABLE_ACTION_NAME",
    "CPP_LINK_STATIC_LIBRARY_ACTION_NAME",
    "C_COMPILE_ACTION_NAME",
)
load(
    "//internal/native_image:common.bzl",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _RULES_REPO = "RULES_REPO",
    _prepare_native_image_rule_context = "prepare_native_image_rule_context",
)

def _graal_binary_implementation(ctx):
    graal_attr = ctx.attr.native_image_tool
    extra_tool_deps = []
    gvm_toolchain = None
    classpath_depset = depset(transitive = [
        dep[JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
    ])

    graal = None
    direct_inputs = []
    transitive_inputs = [classpath_depset]

    # resolve via toolchains
    info = ctx.toolchains[_GVM_TOOLCHAIN_TYPE].graalvm

    # but fall back to explicitly-provided tool, which should override, with the
    # remainder of the resolved toolchain present
    resolved_graal = graal_attr or info.native_image_bin
    gvm_toolchain = info
    extra_tool_deps.append(info.gvm_files)

    graal_inputs, _ = ctx.resolve_tools(tools = [
        resolved_graal,
    ] + extra_tool_deps)

    graal = graal_inputs.to_list()[0]

    # add toolchain files to transitive inputs
    transitive_inputs.append(gvm_toolchain.gvm_files[DefaultInfo].files)

    # if we're using an explicit tool, add it to the direct inputs
    if graal:
        direct_inputs.append(graal)
    else:
        # still failed to resolve: cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    # begin resolving native toolchains
    cc_toolchain = find_cpp_toolchain(ctx)
    transitive_inputs.append(cc_toolchain.all_files)

    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    c_compiler_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = C_COMPILE_ACTION_NAME,
    )
    ld_executable_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_EXECUTABLE_ACTION_NAME,
    )
    ld_static_lib_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_STATIC_LIBRARY_ACTION_NAME,
    )
    ld_dynamic_lib_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
    )
    compile_variables = cc_common.create_compile_variables(
        cc_toolchain = cc_toolchain,
        feature_configuration = feature_configuration,
    )
    compile_env = cc_common.get_environment_variables(
        feature_configuration = feature_configuration,
        action_name = C_COMPILE_ACTION_NAME,
        variables = compile_variables,
    )
    compile_requirements = cc_common.get_execution_requirements(
        feature_configuration = feature_configuration,
        action_name = C_COMPILE_ACTION_NAME,
    )
    link_variables = cc_common.create_link_variables(
        cc_toolchain = cc_toolchain,
        feature_configuration = feature_configuration,
    )

    # We assume that all link actions use the same environment and execution requirements.
    link_env = cc_common.get_environment_variables(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_EXECUTABLE_ACTION_NAME,
        variables = link_variables,
    )
    link_requirements = cc_common.get_execution_requirements(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_EXECUTABLE_ACTION_NAME,
    )

    env = dicts.add(compile_env, link_env)
    execution_requirements = compile_requirements + link_requirements

    path_set = {}
    tool_paths = [c_compiler_path, ld_executable_path, ld_static_lib_path, ld_dynamic_lib_path]
    for tool_path in tool_paths:
        tool_dir, _, _ = tool_path.rpartition("/")
        path_set[tool_dir] = None

    paths = sorted(path_set.keys())
    if ctx.configuration.host_path_separator == ":":
        # HACK: ":" is a proxy for a UNIX-like host.
        # The tools returned above may be bash scripts that reference commands
        # in directories we might not otherwise include. For example,
        # on macOS, wrapped_ar calls dirname.
        if "/bin" not in path_set:
            paths.append("/bin")
            if "/usr/bin" not in path_set:
                paths.append("/usr/bin")

    # seal paths with hack above
    env["PATH"] = ctx.configuration.host_path_separator.join(paths)
    args = ctx.actions.args()
    binary = _prepare_native_image_rule_context(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        gvm_toolchain,
    )

    inputs = depset(direct_inputs, transitive = transitive_inputs)

    run_params = {
        "outputs": [binary],
        "executable": graal,
        "inputs": inputs,
        "mnemonic": "NativeImage",
        "env": env,
        "execution_requirements": {k: "" for k in execution_requirements},
        "progress_message": "Compiling native image %{label}",
        "toolchain": Label(_GVM_TOOLCHAIN_TYPE),
    }

    graal_actions = _wrap_actions_for_graal(ctx.actions)
    if ctx.target_platform_has_constraint(ctx.attr._macos_constraint[platform_common.ConstraintValueInfo]):
        xcode_args = ctx.actions.args()

        # Bazel passes DEVELOPER_DIR and SDKROOT to every locally executed action that sets the
        # environment variables passed by apple_support.run. However, Graal sanitizes the
        # environment and removes these variables if set directly. We need to convert them into
        # -E options and rely on apple_support's argument replacement to pass them through to the
        # compiler invoked by Graal.
        # https://github.com/oracle/graal/blob/77a7f6a691024d22367ae33be4da0c15ceb6a246/substratevm/src/com.oracle.svm.driver/src/com/oracle/svm/driver/NativeImage.java#L1801-L1808
        xcode_args.add(apple_support.path_placeholders.xcode(), format = "-EDEVELOPER_DIR=%s")
        xcode_args.add(apple_support.path_placeholders.sdkroot(), format = "-ESDKROOT=%s")
        apple_support.run(
            actions = graal_actions,
            apple_fragment = ctx.fragments.apple,
            xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig],
            xcode_path_resolve_level = apple_support.xcode_path_resolve_level.args,
            arguments = [args, xcode_args],
            **run_params
        )

    # on windows, inject the `LIB` and `INCLUDE` values, etc, which are used by the `native-image` tool
    # to resolve msvc dependencies.
    elif ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        # activate default shell environment on windows
        run_params["use_default_shell_env"] = True

        # run windows actions.
        graal_actions.run(
            arguments = [args],
            **run_params
        )

    else:
        # run our proxied env shim on all other platforms.
        graal_actions.run(
            arguments = [args],
            **run_params
        )

    return [DefaultInfo(
        executable = binary,
        files = depset([binary]),
        runfiles = ctx.runfiles(
            collect_data = True,
            collect_default = True,
            files = [],
        ),
    )]

def _wrap_actions_for_graal(actions):
    """Wraps the given ctx.actions struct so that env variables are correctly passed to Graal."""
    patched_actions = {k: getattr(actions, k) for k in dir(actions)}
    def _run_target(**kwargs):
        _wrapped_run_for_graal(actions, **kwargs)
    patched_actions["run"] = _run_target
    return struct(**patched_actions)

def _env_arg_map_each(key_value):
    return "-E{}={}".format(key_value[0], key_value[1])

def _wrapped_run_for_graal(_original_actions, arguments = [], env = {}, **kwargs):
    env_args = _original_actions.args()
    env_args.add_all(env.items(), map_each = _env_arg_map_each)
    return _original_actions.run(
        arguments = arguments + [env_args],
        # We keep the original variables as Bazel has special handling for adding additional
        # variables (such as DEVELOPER_DIR) based on existing ones when it executes the action
        # locally.
        env = env,
        **kwargs
    )

# Exports.
RULES_REPO = _RULES_REPO
DEFAULT_GVM_REPO = _DEFAULT_GVM_REPO
BAZEL_CURRENT_CPP_TOOLCHAIN = _BAZEL_CURRENT_CPP_TOOLCHAIN
BAZEL_CPP_TOOLCHAIN_TYPE = _BAZEL_CPP_TOOLCHAIN_TYPE
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
graal_binary_implementation = _graal_binary_implementation
