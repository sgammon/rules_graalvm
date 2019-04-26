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
        "main_class": attr.string(),
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

