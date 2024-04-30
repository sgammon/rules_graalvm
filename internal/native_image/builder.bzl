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
            ctx.attr.name + "_hermetic_libs/libz.a",
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

def _configure_debug(ctx, args):
    """Configure debug symbols for a Native Image build to match Bazel's build settings.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
    """

    if ctx.attr.debug:
        args.add("-g")

def _configure_optimization_mode(ctx, args):
    """Configure the Native Image optimization mode to match Bazel's build setting.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
    """

    if ctx.attr.optimization_mode:
        args.add(
            ctx.attr.optimization_mode,
            format = "-O%s",
        )

def _configure_proxy(ctx, args, direct_inputs):
    """Configure proxy settings for a Native Image build.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        direct_inputs: Direct Native Image build action inputs.

    """
    if ctx.attr.proxy_configuration != None:
        args.add(ctx.file.proxy_configuration, format = "-H:DynamicProxyConfigurationFiles=%s")
        direct_inputs.append(ctx.file.proxy_configuration)

def _configure_resources(ctx, args, direct_inputs):
    """Configure resource settings for a Native Image build.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        direct_inputs: Direct Native Image build action inputs.

    """
    if ctx.attr.include_resources != None:
        args.add(ctx.attr.include_resources, format = "-H:IncludeResources=%s")

    if ctx.attr.resource_configuration != None:
        args.add(ctx.file.resource_configuration, format = "-H:ResourceConfigurationFiles=%s")
        direct_inputs.append(ctx.file.resource_configuration)

def _configure_reflection(ctx, args, direct_inputs):
    """Configure reflection settings for a Native Image build.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        direct_inputs: Direct Native Image build action inputs.
    """

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

    if ctx.attr.jni_configuration != None:
        args.add(ctx.file.jni_configuration, format = "-H:JNIConfigurationFiles=%s")
        direct_inputs.append(ctx.file.jni_configuration)
        args.add("-H:+JNI")

def _configure_native_compiler(ctx, args, c_compiler_path, gvm_toolchain):
    """Configure native compiler and linker flags for a Native Image build.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        c_compiler_path: Path to the C compiler; resolved via toolchains.
        gvm_toolchain: Resolved GraalVM toolchain, or `None` if a tool target is in use via legacy rules.
    """

    # configure debug symbols
    _configure_debug(ctx, args)

    # configure the build optimization mode
    _configure_optimization_mode(ctx, args)

    if gvm_toolchain != None:
        args.add(c_compiler_path, format = "--native-compiler-path=%s")

    # add custom compiler options
    args.add_all(
        ctx.attr.c_compiler_option,
        format_each = "-H:CCompilerOption=%s",
    )

def _configure_native_test_flags(ctx, args):
    """Configure native testing flags; only applies if we are building a test-only target.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
    """

    if ctx.attr.coverage:
        args.add("--tool:coverage")

def assemble_native_build_options(
        ctx,
        args,
        binary,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain = None,
        bin_postfix = None):
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
        gvm_toolchain: Resolved GraalVM toolchain, or `None` if a tool target is in use via legacy rules.
        bin_postfix: Binary postfix expected from the output file (for example, `.exe` or `.dylib`).
    """

    # main class is required unless we are building a shared library
    if ctx.attr.shared_library:
        args.add("--shared")
    elif ctx.attr.main_class == None or ctx.attr.main_class == "":
        fail("""
            Native Image build failure: `main_class` attribute is mandatory in `native_image` or `graal_binary` targets,
            unless `shared_library=True`.
        """)

    if not ctx.attr.allow_fallback:
        args.add("--no-fallback")

    trimmed_basename = binary.basename
    if bin_postfix:
        trimmed_basename = trimmed_basename[0:-(len(bin_postfix))]

    args.add(ctx.attr.main_class, format = "-H:Class=%s")
    args.add(trimmed_basename, format = "-H:Name=%s")
    args.add(binary.dirname, format = "-H:Path=%s")
    args.add("-H:+ReportExceptionStackTraces")

    if not ctx.attr.check_toolchains:
        args.add("-H:-CheckToolchain")

    # assemble classpath
    args.add_joined(
        "-cp",
        classpath_depset,
        join_with = path_list_separator,
    )

    args.add_joined(
        ctx.attr.native_features,
        join_with = ",",
        format_joined = "-H:Features=%s",
    )

    # configure the build optimization mode
    _configure_native_compiler(ctx, args, c_compiler_path, gvm_toolchain)

    # configure reflection
    _configure_reflection(ctx, args, direct_inputs)

    # configure resources
    _configure_resources(ctx, args, direct_inputs)

    # configure proxy
    _configure_proxy(ctx, args, direct_inputs)

    # if a static build is being performed against hermetic zlib, configure it
    if ctx.attr.static_zlib != None:
        _configure_static_zlib_compile(
            ctx,
            args,
            direct_inputs,
        )

    if ctx.files.profiles:
        args.add_joined(
            ctx.files.profiles,
            join_with = ",",
            format_joined = "--pgo=%s",
        )
        direct_inputs.extend(ctx.files.profiles)

    # add test-related flags, if this is a `testonly` target
    if ctx.attr.testonly:
        _configure_native_test_flags(
            ctx,
            args,
        )

    # append extra arguments last
    for arg in ctx.attr.extra_args:
        # Expand locations of targets in 'data' and make variables provided by 'toolchains'.
        expanded_arg = ctx.expand_make_variables(
            "extra_args",
            ctx.expand_location(arg, ctx.attr.data),
            {},
        )

        # Skip over args that become empty after expansion but weren't before.
        if expanded_arg or not arg:
            args.add(expanded_arg)
