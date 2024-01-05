"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@build_bazel_apple_support//lib:apple_support.bzl",
    "apple_support",
)
load(
    "@bazel_tools//tools/cpp:toolchain_utils.bzl",
    "find_cpp_toolchain",
)
load(
    "//internal/native_image:common.bzl",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _DEBUG_CONDITION = "DEBUG_CONDITION",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _OPTIMIZATION_MODE_CONDITION = "OPTIMIZATION_MODE_CONDITION",
    _RULES_REPO = "RULES_REPO",
    _prepare_native_image_rule_context = "prepare_native_image_rule_context",
)
load(
    "//internal/native_image:toolchain.bzl",
    _resolve_cc_toolchain = "resolve_cc_toolchain",
)

_BIN_POSTFIX_DYLIB = ".dylib"
_BIN_POSTFIX_EXE = ".exe"
_BIN_POSTFIX_DLL = ".dll"
_BIN_POSTFIX_SO = ".so"

def _build_action_message(ctx):
    _mode_label = {
        "b": "fastbuild",
        "s": "size",
        "1": "opt",
        "2": "opt",
        "default": ctx.attr.debug and "debug" or "default",
    }
    return (_mode_label[ctx.attr.optimization_mode or "default"])

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
    extra_tool_deps.append(info.includes)

    graal_inputs, _ = ctx.resolve_tools(tools = [
        resolved_graal,
    ] + extra_tool_deps)

    graal = graal_inputs.to_list()[0]

    # add toolchain files to transitive inputs
    transitive_inputs.append(gvm_toolchain.gvm_files[DefaultInfo].files)
    transitive_inputs.append(gvm_toolchain.includes[DefaultInfo].files)
    graalvm_home = graal.dirname

    # if we're using an explicit tool, add it to the direct inputs
    if graal:
        direct_inputs.append(graal)
    else:
        # still failed to resolve: cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    is_macos = ctx.target_platform_has_constraint(
        ctx.attr._macos_constraint[platform_common.ConstraintValueInfo]
    )
    is_windows = ctx.target_platform_has_constraint(
        ctx.attr._windows_constraint[platform_common.ConstraintValueInfo],
    )

    # resolve the native toolchain
    native_toolchain = _resolve_cc_toolchain(
        ctx,
        transitive_inputs,
        is_windows = is_windows,
        graalvm_home = graalvm_home,
    )

    # shared libraries on macos are produced with an extension of `dylib`.
    bin_postfix = None
    if is_macos and ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_DYLIB
    elif is_windows and not ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_EXE
    elif is_windows:
        bin_postfix = _BIN_POSTFIX_DLL
    elif (not is_windows and not is_macos) and ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_SO

    args = ctx.actions.args().use_param_file("@%s", use_always=False)
    all_outputs = _prepare_native_image_rule_context(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        native_toolchain.c_compiler_path,
        gvm_toolchain,
        bin_postfix = bin_postfix,
    )
    binary = all_outputs[0]

    # assemble final inputs
    inputs = depset(
        direct_inputs,
        transitive = transitive_inputs,
    )
    run_params = {
        "outputs": all_outputs,
        "executable": graal,
        "inputs": inputs,
        "mnemonic": "NativeImage",
        "env": native_toolchain.env,
        "execution_requirements": {k: "" for k in native_toolchain.execution_requirements},
        "progress_message": "Native Image __target__ (__mode__) %{label}"
            .replace("__mode__", _build_action_message(ctx))
            .replace("__target__", ctx.attr.shared_library and "[shared lib]" or "[executable]"),
        "toolchain": Label(_GVM_TOOLCHAIN_TYPE),
    }

    graal_actions = _wrap_actions_for_graal(ctx.actions)
    if is_macos:
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

    else:
        # run our proxied env shim on all other platforms.
        graal_actions.run(
            arguments = [args],
            **run_params
        )

    # if we are building a shared library, prepare `CcSharedLibraryInfo` for it
    cc_info = []
    runfiles = None
    if ctx.attr.shared_library:
        cc_toolchain = find_cpp_toolchain(ctx)
        feature_configuration = cc_common.configure_features(
            ctx = ctx,
            cc_toolchain = cc_toolchain,
            requested_features = ctx.features,
            unsupported_features = ctx.disabled_features,
        )
        libraries_to_link = [
            cc_common.create_library_to_link(
                actions = ctx.actions,
                feature_configuration = feature_configuration,
                cc_toolchain = cc_toolchain,
                dynamic_library = binary,
            ),
        ]
        cc_info.extend([
            OutputGroupInfo(
                main_shared_library_output = depset([binary]),
            ),
            CcSharedLibraryInfo(
                linker_input = cc_common.create_linker_input(
                    owner = ctx.label,
                    libraries = depset(libraries_to_link),
                ),
            ),
        ])

    # prepare all runfiles
    all_runfiles = ctx.runfiles(
        collect_data = True,
        collect_default = True,
        files = [],
    )
    if runfiles != None:
        all_runfiles = all_runfiles.merge(runfiles)

    return cc_info + [DefaultInfo(
        executable = binary,
        files = depset(all_outputs),
        runfiles = all_runfiles,
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
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
DEBUG_CONDITION = _DEBUG_CONDITION
OPTIMIZATION_MODE_CONDITION = _OPTIMIZATION_MODE_CONDITION
graal_binary_implementation = _graal_binary_implementation
