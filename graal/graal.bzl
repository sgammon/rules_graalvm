load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    "ASSEMBLE_ACTION_NAME",
    "CPP_COMPILE_ACTION_NAME",
    "CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME",
    "CPP_LINK_EXECUTABLE_ACTION_NAME",
    "CPP_LINK_STATIC_LIBRARY_ACTION_NAME",
    "C_COMPILE_ACTION_NAME",
    "OBJCPP_COMPILE_ACTION_NAME",
    "OBJC_COMPILE_ACTION_NAME",
)

def _graal_binary_implementation(ctx):
    graal_attr = ctx.attr._graal
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
    env = {}
    env["PATH"] = ctx.configuration.host_path_separator.join(paths)

    binary = ctx.actions.declare_file("%s-bin" % ctx.attr.name)

    args = ctx.actions.args()
    args.add("--no-server")
    args.add("--no-fallback")
    args.add("-cp", ":".join([f.path for f in classpath_depset.to_list()]))
    args.add("-H:Class=%s" % ctx.attr.main_class)
    args.add("-H:Name=%s" % binary.path)
    args.add("-H:CCompilerPath=%s" % c_compiler_path)
    args.add("-H:+ReportExceptionStackTraces")
    for arg in ctx.attr.graal_extra_args:
        args.add(arg)

    args.add_joined(ctx.attr.c_compiler_option,
                    join_with = " ",
                    format_joined="-H:CCompilerOption=%s")
    if len(ctx.attr.native_image_features) > 0:
        args.add("-H:Features={entries}".format(entries=",".join(ctx.attr.native_image_features)))

    if len(ctx.attr.initialize_at_build_time) > 0:
        args.add("--initialize-at-build-time={entries}".format(entries=",".join(ctx.attr.initialize_at_build_time)))

    if ctx.attr.reflection_configuration != None:
        args.add("-H:ReflectionConfigurationFiles={path}".format(path=ctx.file.reflection_configuration.path))
        classpath_depset = depset([ctx.file.reflection_configuration], transitive=[classpath_depset])

    if ctx.attr.jni_configuration != None:
        args.add("-H:JNIConfigurationFiles={path}".format(path=ctx.file.jni_configuration.path))
        classpath_depset = depset([ctx.file.jni_configuration], transitive=[classpath_depset])
        args.add("-H:+JNI")

    ctx.actions.run(
        inputs = classpath_depset,
        outputs = [binary],
        arguments = [args],
        executable = graal,
        env = env,
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

graal_binary = rule(
    implementation = _graal_binary_implementation,
    attrs = {
        "deps": attr.label_list(providers = [[JavaInfo]]),
        "reflection_configuration": attr.label(mandatory=False, allow_single_file=True),
        "jni_configuration": attr.label(mandatory=False, allow_single_file=True),
        "main_class": attr.string(),
        "initialize_at_build_time": attr.string_list(),
        "native_image_features": attr.string_list(),
        "_graal": attr.label(
            cfg = "host",
            default = "@graal//:bin/native-image",
            allow_files = True,
            executable = True,
        ),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")
        ),
        "data": attr.label_list(allow_files = True),
	    "graal_extra_args": attr.string_list(),
        "c_compiler_option": attr.string_list()
    },
    executable = True,
    fragments = ["cpp"],
)
