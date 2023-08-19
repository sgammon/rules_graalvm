"Rules for building native binaries using the GraalVM `native-image` tool."

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
_NATIVE_IMAGE_TOOLCHAIN_TYPE = "%s//graalvm/toolchain" % _RULES_REPO
_BAZEL_CPP_TOOLCHAIN_TYPE = "@bazel_tools//tools/cpp:toolchain_type"
_BAZEL_CURRENT_CPP_TOOLCHAIN = "@bazel_tools//tools/cpp:current_cc_toolchain"

def _graal_binary_implementation(ctx):
    graal_attr = ctx.attr.native_image_tool
    if graal_attr == None:
        # resolve via toolchains
        pass

    if graal_attr == None:
        # still failed to resolve: cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    graal_inputs, _, _ = ctx.resolve_command(tools = [graal_attr])
    graal = graal_inputs[0]

    classpath_depset = depset(transitive = [
        dep[JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
    ])

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

    tool_paths = [c_compiler_path, ld_executable_path, ld_static_lib_path, ld_dynamic_lib_path]
    path_set = {}
    for tool_path in tool_paths:
        tool_dir, _, _ = tool_path.rpartition("/")
        path_set[tool_dir] = None

    env = {}
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

    # fix: make sure to include VS install dir on windows
    if "VSINSTALLDIR" in ctx.configuration.default_shell_env:
        vs_install = ctx.configuration.default_shell_env["VSINSTALLDIR"]
        if vs_install != None and len(vs_install) > 0:
            env["VSINSTALLDIR"] = vs_install

    # fix: make sure to include SDKROOT on macos
    if "SDKROOT" in ctx.configuration.default_shell_env:
        sdkroot = ctx.configuration.default_shell_env["SDKROOT"]
        if sdkroot != None and len(sdkroot) > 0:
            env["SDKROOT"] = sdkroot

    # fix: make sure to include SDKROOT on macos
    if "DEVELOPER_DIR" in ctx.configuration.default_shell_env:
        devdir = ctx.configuration.default_shell_env["DEVELOPER_DIR"]
        if devdir != None and len(devdir) > 0:
            env["DEVELOPER_DIR"] = devdir

    # seal paths with hack above
    env["PATH"] = ctx.configuration.host_path_separator.join(paths)
    binary = ctx.actions.declare_file("%s-bin" % ctx.attr.name)

    args = ctx.actions.args()
    args.add("--no-fallback")
    args.add("-cp", ":".join([f.path for f in classpath_depset.to_list()]))

    # TODO only on later bazels
    # args.add("--native-compiler-path=%s" % c_compiler_path)

    args.add("-H:Class=%s" % ctx.attr.main_class)
    args.add("-H:Name=%s" % binary.basename)
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
        classpath_depset = depset([ctx.file.reflection_configuration], transitive = [classpath_depset])

    if ctx.attr.include_resources != None:
        args.add("-H:IncludeResources={path}".format(path = ctx.attr.include_resources))

    if ctx.attr.jni_configuration != None:
        args.add("-H:JNIConfigurationFiles={path}".format(path = ctx.file.jni_configuration.path))
        classpath_depset = depset([ctx.file.jni_configuration], transitive = [classpath_depset])
        args.add("-H:+JNI")

    run_params = {
        "inputs": classpath_depset,
        "outputs": [binary],
        "arguments": [args],
        "executable": graal,
        "mnemonic": "NativeImage",
        "use_default_shell_env": False,
        "env": env,
        # "toolchain": Label(_NATIVE_IMAGE_TOOLCHAIN_TYPE),
    }

    # fix: on bazel4, the `tools` parameter is expected to be a `File or FilesToRunProvider`, whereas
    # on later versions it is expected to be a `depset`.
    if not ctx.attr._legacy_rule:
        run_params["tools"] = [
            ctx.attr._cc_toolchain.files,
        ]
        run_params["progress_message"] = "Compiling native image %{label}"

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
NATIVE_IMAGE_TOOLCHAIN_TYPE = _NATIVE_IMAGE_TOOLCHAIN_TYPE
graal_binary_implementation = _graal_binary_implementation
