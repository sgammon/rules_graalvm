"Rules for building native binaries using the GraalVM `native-image` tool."

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

_RULES_REPO = "@rules_graalvm"
_DEFAULT_GVM_REPO = "@graalvm"
_GVM_TOOLCHAIN_TYPE = "%s//graalvm/toolchain" % _RULES_REPO
_BAZEL_CPP_TOOLCHAIN_TYPE = "@bazel_tools//tools/cpp:toolchain_type"
_BAZEL_CURRENT_CPP_TOOLCHAIN = "@bazel_tools//tools/cpp:current_cc_toolchain"
_WINDOWS_CONSTRAINT = "@platforms//os:windows"

_PASSTHRU_ENV_VARS = [
    "INCLUDE",
    "LIB",
    "MSVC",
    "VSINSTALLDIR",
    "SDKROOT",
    "DEVELOPER_DIR",
    "BAZEL_USE_CPP_ONLY_TOOLCHAIN",
    "BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN",
]

_NATIVE_IMAGE_ATTRS = {
    "deps": attr.label_list(
        providers = [[JavaInfo]],
        mandatory = True,
    ),
    "main_class": attr.string(
        mandatory = False,
    ),
    "binary_type": attr.string(
        mandatory = False,
        default = "executable",
    ),
    "include_resources": attr.string(
        mandatory = False,
    ),
    "reflection_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "jni_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "initialize_at_build_time": attr.string_list(
        mandatory = False,
    ),
    "initialize_at_run_time": attr.string_list(
        mandatory = False,
    ),
    "native_features": attr.string_list(
        mandatory = False,
    ),
    "data": attr.label_list(
        allow_files = True,
    ),
    "extra_args": attr.string_list(
        mandatory = False,
    ),
    "check_toolchains": attr.bool(
        default = True,
    ),
    "c_compiler_option": attr.string_list(
        mandatory = False,
    ),
    "enable_default_shell_env": attr.bool(
        default = False,
    ),
    "pass_compiler_path": attr.bool(
        default = True,
    ),
    "default_executable_name": attr.string(
        mandatory = True,
    ),
    "_cc_toolchain": attr.label(
        default = Label(_BAZEL_CURRENT_CPP_TOOLCHAIN),
    ),
    "_windows_constraint": attr.label(
        default = Label(_WINDOWS_CONSTRAINT),
    ),
}

def _graal_binary_implementation(ctx):
    graal_attr = ctx.attr.native_image_tool
    extra_tool_deps = []
    gvm_toolchain = None
    classpath_depset = depset(transitive = [
        dep[JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
    ])
    all_deps = depset([], transitive = [classpath_depset])

    if graal_attr == None:
        # resolve via toolchains
        info = ctx.toolchains[_GVM_TOOLCHAIN_TYPE].graalvm
        graal_attr = info.native_image_bin
        gvm_toolchain = info
        extra_tool_deps.append(info.gvm_files)

        graal_inputs, _ = ctx.resolve_tools(tools = [
            graal_attr,
        ] + extra_tool_deps)

        graal = graal_inputs.to_list()[0]
        all_deps = depset(transitive = [
            classpath_depset,
            gvm_toolchain.gvm_files.files,
        ])
    else:
        # otherwise, use the legacy code path
        graal_inputs, _, _ = ctx.resolve_command(tools = [
            graal_attr,
        ])
        graal = graal_inputs[0]

    if graal_attr == None:
        # still failed to resolve: cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    cc_toolchain = find_cpp_toolchain(ctx)
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

    env = {}
    path_set = {}
    tool_paths = [c_compiler_path, ld_executable_path, ld_static_lib_path, ld_dynamic_lib_path]
    for tool_path in tool_paths:
        tool_dir, _, _ = tool_path.rpartition("/")
        path_set[tool_dir] = None

    paths = sorted(path_set.keys())
    unix_like = True
    if ctx.configuration.host_path_separator == ":":
        # HACK: ":" is a proxy for a UNIX-like host.
        # The tools returned above may be bash scripts that reference commands
        # in directories we might not otherwise include. For example,
        # on macOS, wrapped_ar calls dirname.
        unix_like = True
        if "/bin" not in path_set:
            paths.append("/bin")
            if "/usr/bin" not in path_set:
                paths.append("/usr/bin")
    else:
        # non-unix hosts implies windows, where we should splice the full path
        unix_like = False

    # fix: make sure to include VS install dir on windows, and SDKROOT/DEVELOPER_DIR on macos, but only
    # when using the non-legacy rules, and only on Bazel greater than 5. otherwise, it appears to overwrite
    # the env injected normally by Bazel to make Xcode and VS compilation work.
    if (not ctx.attr._legacy_rule):
        for var in _PASSTHRU_ENV_VARS:
            if var == "DEVELOPER_DIR" and unix_like:
                # allow bazel to override the developer directory on mac
                env[var] = apple_common.apple_toolchain().developer_dir()
            elif var == "SDKROOT" and unix_like:
                # allow bazel to override the apple SDK root
                env[var] = apple_common.apple_toolchain().sdk_dir()
            elif var in ctx.configuration.default_shell_env:
                env[var] = ctx.configuration.default_shell_env[var]

    # seal paths with hack above
    env["PATH"] = ctx.configuration.host_path_separator.join(paths)
    out_bin_name = ctx.attr.default_executable_name.replace("%target%", ctx.attr.name)
    binary = ctx.actions.declare_file(out_bin_name)

    args = ctx.actions.args()
    args.add("--no-fallback")

    # TODO: This check really should be on the exec platform, not the target platform, but that
    # requires going through a separate rule. Since GraalVM doesn't support cross-compilation, the
    # distinction doesn't matter for now.
    if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        path_list_separator = ";"
    else:
        path_list_separator = ":"
    args.add("-cp", path_list_separator.join([f.path for f in classpath_depset.to_list()]))

    if gvm_toolchain != None and ctx.attr.pass_compiler_path:
        args.add("--native-compiler-path=%s" % c_compiler_path)

    args.add("-H:Class=%s" % ctx.attr.main_class)
    args.add("-H:Name=%s" % binary.basename.replace(".exe", ""))
    args.add("-H:Path=%s" % binary.dirname)
    args.add("-H:+ReportExceptionStackTraces")

    if not ctx.attr.check_toolchains:
        args.add("-H:-CheckToolchain")

    for arg in ctx.attr.extra_args:
        args.add(arg)

    args.add_joined(
        ctx.attr.c_compiler_option,
        join_with = " ",
        format_joined = "-H:CCompilerOption=%s",
    )
    if len(ctx.attr.native_features) > 0:
        args.add("-H:Features={entries}".format(entries = ",".join(ctx.attr.native_features)))

    if len(ctx.attr.initialize_at_build_time) > 0:
        args.add("--initialize-at-build-time={entries}".format(entries = ",".join(ctx.attr.initialize_at_build_time)))

    if len(ctx.attr.initialize_at_run_time) > 0:
        args.add("--initialize-at-run-time={entries}".format(entries = ",".join(ctx.attr.initialize_at_run_time)))

    if ctx.attr.reflection_configuration != None:
        args.add("-H:ReflectionConfigurationFiles={path}".format(path = ctx.file.reflection_configuration.path))
        all_deps = depset([ctx.file.reflection_configuration], transitive = [all_deps])

    if ctx.attr.include_resources != None:
        args.add("-H:IncludeResources={path}".format(path = ctx.attr.include_resources))

    if ctx.attr.jni_configuration != None:
        args.add("-H:JNIConfigurationFiles={path}".format(path = ctx.file.jni_configuration.path))
        all_deps = depset([ctx.file.jni_configuration], transitive = [all_deps])
        args.add("-H:+JNI")

    run_params = {
        "outputs": [binary],
        "arguments": [args],
        "executable": graal,
        "mnemonic": "NativeImage",
        "env": env,
    }

    # fix: on bazel4, the `tools` parameter is expected to be a `File or FilesToRunProvider`, whereas
    # on later versions it is expected to be a `depset`. there is also no `toolchain` parameter at all.
    if not ctx.attr._legacy_rule:
        run_params.update(**{
            "inputs": all_deps,
            "use_default_shell_env": ctx.attr.enable_default_shell_env,
            "progress_message": "Compiling native image %{label}",
            "toolchain": Label(_GVM_TOOLCHAIN_TYPE),
            "tools": [
                ctx.attr._cc_toolchain.files,
            ],
        })
    else:
        run_params["inputs"] = classpath_depset

    ctx.actions.run(
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

# Exports.
RULES_REPO = _RULES_REPO
DEFAULT_GVM_REPO = _DEFAULT_GVM_REPO
BAZEL_CURRENT_CPP_TOOLCHAIN = _BAZEL_CURRENT_CPP_TOOLCHAIN
BAZEL_CPP_TOOLCHAIN_TYPE = _BAZEL_CPP_TOOLCHAIN_TYPE
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
graal_binary_implementation = _graal_binary_implementation
