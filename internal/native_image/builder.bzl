"Logic to assemble `native-image` options."

def _configure_static_zlib_compile(ctx, args, direct_inputs):
    """Configure a static image compile against hermetic/static zlib.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        direct_inputs: Inputs into the image build (mutable). """

    if CcInfo in ctx.attr.static_zlib and ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
        linking_context = ctx.attr.static_zlib[CcInfo].linking_context
        linker_inputs = linking_context.linker_inputs.to_list()
        if len(linker_inputs) != 1:
            fail("Expected exactly one LinkerInput for static_zlib, got %s" % repr(linker_inputs))
        libraries = linker_inputs[0].libraries

        # In some versions of Bazel, libraries is a depset, in others it's a list.
        if type(libraries) == type(depset([])):
            libraries = libraries.to_list()
        if len(libraries) != 1:
            fail("Expected exactly one library for static_zlib, got %s" % repr(libraries))
        library = libraries[0]

        # Prefer PIC over non-PIC.
        static_library = library.pic_static_library
        if not static_library:
            static_library = library.static_library
        if not static_library:
            fail("Expected a static library for static_zlib, got %s" % library)

        zlib_static = ctx.actions.declare_file(
            ctx.attr.name + "_hermetic_libs/libz.a"
        )
        ctx.actions.symlink(
            output = zlib_static,
            target_file = static_library,
        )
        args.add(
            zlib_static.dirname,
            format = "-H:CLibraryPath=%s",
        )
        direct_inputs.append(zlib_static)


def assemble_native_build_options(
        ctx,
        args,
        binary,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain = None):
    """Assemble the effective arguments to `native-image`.

    This function is responsible for converting the current rule invocation context into a set of arguments
    which can be passed to the `native-image` builder.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        binary: Target output binary which will be built with Native Image.
        classpath_depset: Classpath dependency set.
        direct_inputs: Direct inputs into the native image build (mutable).
        c_compiler_path: Path to the C compiler; resolved via toolchains.
        path_list_separator: Platform-specific path separator.
        gvm_toolchain: Resolved GraalVM toolchain, or `None` if a tool target is in use via legacy rules. """

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

    # if a static build is being performed against hermetic zlib, configure it
    if ctx.attr.static_zlib != None:
        _configure_static_zlib_compile(
            ctx,
            args,
            direct_inputs,
        )
