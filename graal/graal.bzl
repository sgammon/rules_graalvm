def _graal_binary_implementation(ctx):
    graal_attr = ctx.attr._graal
    graal_inputs, _, _ = ctx.resolve_command(tools = [graal_attr])
    graal = graal_inputs[0]

    classpath_depset = depset(transitive = [
        dep[JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
        if JavaInfo in dep
    ])

    args = ctx.actions.args()
    args.add("--no-server")
    args.add("-cp", ":".join([f.path for f in classpath_depset.to_list()]))
    args.add("-H:Class=%s" % ctx.attr.main_class)
    args.add("-H:Name=%s" % ctx.outputs.bin.path)

    if len(ctx.attr.native_image_features) > 0:
        args.add("-H:Features={entries}".format(entries=",".join(ctx.attr.native_image_features)))

    if len(ctx.attr.initialize_at_build_time) > 0:
        args.add("--initialize-at-build-time={entries}".format(entries=",".join(ctx.attr.initialize_at_build_time)))

    if ctx.attr.reflection_configuration != None:
        args.add("-H:ReflectionConfigurationFiles={path}".format(path=ctx.file.reflection_configuration.path))
        classpath_depset = depset([ctx.file.reflection_configuration], transitive=[classpath_depset])

    ctx.actions.run(
        inputs = classpath_depset,
        outputs = [ctx.outputs.bin],
        arguments = [args],
        executable = graal,
    )

    return [DefaultInfo(
        executable = ctx.outputs.bin,
        files = depset(),
        runfiles = ctx.runfiles(
            collect_data = True,
            collect_default = True,
            files = [],
        ),
    )]

graal_binary = rule(
    implementation = _graal_binary_implementation,
    attrs = {
        "deps": attr.label_list(
            allow_files = True,
        ),
        "reflection_configuration": attr.label(mandatory=False, allow_single_file=True),
        "main_class": attr.string(),
        "initialize_at_build_time": attr.string_list(),
        "native_image_features": attr.string_list(),
        "_graal": attr.label(
            cfg = "host",
            default = "@graal//:bin/native-image",
            allow_files = True,
            executable = True,
        ),
    },
    outputs = {
        "bin": "%{name}-bin",
    },
    executable = True,
)

