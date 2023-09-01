"Logic to assemble `native-image` options."


def assemble_native_build_options(
    ctx,
    args,
    binary,
    classpath_depset,
    direct_inputs,
    c_compiler_path,
    path_list_separator,
    gvm_toolchain = None):
    """Assemble the effective arguments to `native-image`."""

    args.add("--no-fallback")

    # assemble classpath
    args.add_joined("-cp", classpath_depset, join_with = path_list_separator)

    if gvm_toolchain != None:
        args.add(c_compiler_path, format = "--native-compiler-path=%s")

    args.add(ctx.attr.main_class, format = "-H:Class=%s")
    args.add(binary.basename.replace(".exe", ""), format = "-H:Name=%s")
    args.add(binary.dirname, format = "-H:Path=%s")
    args.add("-H:+ReportExceptionStackTraces")

    if not ctx.attr.check_toolchains:
        args.add("-H:-CheckToolchain")

    for arg in ctx.attr.extra_args:
        args.add(arg)

    args.add_all(
        ctx.attr.c_compiler_option,
        format_each = "-H:CCompilerOption=%s",
    )

    args.add_joined(
        ctx.attr.native_features,
        join_with = ",",
        format_joined = "-H:Features=%s",
    )

    args.add_joined(
        ctx.attr.initialize_at_build_time,
        join_with = ",",
        format_joined = "--initialize-at-build-time=%s",
    )
    args.add_joined(
        ctx.attr.initialize_at_run_time,
        join_with = ",",
        format_joined = "--initialize-at-run-time=%s",
    )

    if ctx.attr.reflection_configuration != None:
        args.add(ctx.file.reflection_configuration, format = "-H:ReflectionConfigurationFiles=%s")
        direct_inputs.append(ctx.file.reflection_configuration)

    if ctx.attr.include_resources != None:
        args.add(ctx.attr.include_resources, format = "-H:IncludeResources=%s")

    if ctx.attr.jni_configuration != None:
        args.add(ctx.file.jni_configuration, format = "-H:JNIConfigurationFiles=%s")
        direct_inputs.append(ctx.file.jni_configuration)
        args.add("-H:+JNI")
