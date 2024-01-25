"Logic to assemble `native-image` options."

load(
    "//internal/native_image:testing.bzl",
    _NATIVE_TEST_ENTRYPOINT = "NATIVE_TEST_ENTRYPOINT",
)

_NATIVE_IMAGE_SHARED_TMP_DIR_TPL = "native-shlib-%s"

_DEFAULT_NATIVE_IMAGE_ARGS = [
    "-H:+JNI",
    "-H:+ReportExceptionStackTraces",
]

_STRICT_NATIVE_IMAGE_ARGS = [
    "--link-at-build-time",
    "--strict-image-heap",
]

_DEBUG_NATIVE_IMAGE_ARGS = [
    "-g",
    "-H:+SourceLevelDebug",
    "-H:-DeleteLocalSymbols",
]

def _expand_var(ctx, arg, context = None, vars = None):
    return ctx.expand_make_variables(
        "native_image",
        ctx.expand_location(arg, context or ctx.attr.data),
        vars or ctx.var,
    )

def _expand_vars(ctx, args, context = None, vars = None):
    return [_expand_var(ctx, arg, context, vars or ctx.var) for arg in args]

def _arg_formatted(ctx, args, value, format = None, context = None, vars = None):
    args.add(_expand_var(ctx, value, context, vars), format = format or "%s")

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
        args.add_all(_DEBUG_NATIVE_IMAGE_ARGS)

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

def _singular_or_multi_but_not_both(args, direct_inputs, singular_label, plural_label, singular, plural, format = "%s", separator = ","):
    """Use either the singular form of a file attribute, or the multi-label form, but fail if both are provided.

    Resulting arguments are formatted (if necessary) and appended to the `direct_inputs` list and
    suite of args.

    Args:
        args: Arguments to add to.
        direct_inputs: Direct inputs list to append to for matching files.
        singular_label: Label for the singular attribute. Used in error messages.
        plural_label: Label for the plural attribute. Used in error messages.
        singular: Singular attribute value.
        plural: Plural attribute value.
        format: Format string for the attribute value.
        separator: Separator for the attribute value.
    """

    values = []
    if singular != None:
        values.append(singular)
    elif plural and len(plural) > 0:
        values.extend(plural)
    elif (plural == None or len(plural) == 0) and (singular == None):
        pass
    else:
        fail(
            "GraalVM Rules: Please provide singular or plural attributes, but not both. Got both: %s and %s." % (
            singular_label,
            plural_label
        ))

    if len(values) > 0:
        args.add_joined(
            values,
            join_with = separator,
            format_joined = format,
        )
        direct_inputs.extend(values)

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

    _singular_or_multi_but_not_both(
        args,
        direct_inputs,
        "reflection_configuration",
        "reflection_configurations",
        ctx.file.reflection_configuration,
        ctx.files.reflection_configurations,
        format = "-H:ReflectionConfigurationFiles=%s",
    )
    _singular_or_multi_but_not_both(
        args,
        direct_inputs,
        "jni_configuration",
        "jni_configurations",
        ctx.file.jni_configuration,
        ctx.files.jni_configurations,
        format = "-H:JNIConfigurationFiles=%s",
    )
    _singular_or_multi_but_not_both(
        args,
        direct_inputs,
        "resource_configuration",
        "resource_configurations",
        ctx.file.resource_configuration,
        ctx.files.resource_configurations,
        format = "-H:ResourceConfigurationFiles=%s",
    )

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

def _configure_gvm_features(args, features = []):
    """Format and add arguments for GraalVM feature classes.

    Args:
        args: Args we're adding to.
        features: Additional features to inject.
    """

    args.add_joined(
        features,
        join_with = ",",
        format_joined = "--features=%s",
    )

def assemble_native_build_options(
        ctx,
        args,
        binary,
        classpath_depset,
        modulepath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain = None,
        bin_postfix = None,
        injected_features = [],
        injected_args = []):
    """Assemble the effective arguments to `native-image`.

    This function is responsible for converting the current rule invocation context into a set of arguments
    which can be passed to the `native-image` builder.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        binary: Target output binary which will be built with Native Image.
        classpath_depset: Classpath dependency set.
        modulepath_depset: Modular dependency set.
        direct_inputs: Direct inputs into the native image build (mutable).
        c_compiler_path: Path to the C compiler; resolved via toolchains.
        path_list_separator: Platform-specific path separator.
        gvm_toolchain: Resolved GraalVM toolchain, or `None` if a tool target is in use via legacy rules.
        bin_postfix: Binary postfix expected from the output file (for example, `.exe` or `.dylib`).
        injected_features: Additional feature classes to add to the compile invocation.
        injected_args: Additional arguments to inject into the compile invocation.

    Returns:
        Tempdir path where the native build should occur.
    """

    # @TODO(sgammon): only append with gvm version > 23.1.x
    # "-H:+UnlockExperimentalVMOptions"

    is_test = ctx.attr._is_test

    # main class is required unless we are building a shared library
    if ctx.attr.shared_library:
        args.add("--shared")
    elif is_test:
        pass  # no main class for tests
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

    args.add(trimmed_basename, format = "-H:Name=%s")
    if not ctx.attr.shared_library:
        if ctx.attr.main_class != None and ctx.attr.main_class != "":
            if ctx.attr.main_module != None and ctx.attr.main_module != "":
                args.add(
                    "%s/%s" % (ctx.attr.main_module, ctx.attr.main_class),
                    format = "-H:Class=%s",
                )
            else:
                args.add(ctx.attr.main_class, format = "-H:Class=%s")
        elif is_test:
            # it's a test and we have no entrypoint class, so we should use the default
            # entrypoint provided by this package.
            args.add(
                _NATIVE_TEST_ENTRYPOINT,
                format = "-H:Class=%s",
            )

    # binary path supports expansion
    _arg_formatted(
        ctx,
        args,
        binary.dirname,
        format = "-H:Path=%s",
    )

    # default native image args, and strict args if directed
    args.add_all(_DEFAULT_NATIVE_IMAGE_ARGS)
    if ctx.attr.strict:
        args.add_all(_STRICT_NATIVE_IMAGE_ARGS)

    tempdir = None
    if ctx.attr.shared_library:
        # declare a temp path for graalvm to use
        tempdir = ctx.actions.declare_directory(
            _NATIVE_IMAGE_SHARED_TMP_DIR_TPL % (ctx.label.name),
            sibling = binary,
        )

        # share temp path with graalvm sandbox, as genfiles root
        args.add(
            tempdir.path,
            format = "-H:TempDirectory=%s",
        )

    if not ctx.attr.check_toolchains:
        args.add("-H:-CheckToolchain")

    # assemble classpath
    args.add_joined(
        "-cp",
        classpath_depset,
        join_with = path_list_separator,
    )

    # assemble module path
    args.add_joined(
        "--module-path",
        modulepath_depset,
        join_with = path_list_separator,
    )

    # configure the build optimization mode
    _configure_native_compiler(ctx, args, c_compiler_path, gvm_toolchain)

    # configure reflection
    _configure_reflection(ctx, args, direct_inputs)

    # configure resources
    if ctx.attr.include_resources != None:
        # resources config supports expansion
        _arg_formatted(
            ctx,
            args,
            ctx.attr.include_resources,
            format = "-H:IncludeResources=%s",
            context = ctx.attr.include_resources,
        )

    # if a static build is being performed against hermetic zlib, configure it
    if ctx.attr.static_zlib != None:
        _configure_static_zlib_compile(
            ctx,
            args,
            direct_inputs,
        )

    if ctx.files.profiles:
        # pgo profiles support expansion
        args.add_joined(
            _expand_vars(ctx, [f.path for f in ctx.files.profiles], ctx.attr.profiles),
            join_with = ",",
            format_joined = "--pgo=%s",
        )
        direct_inputs.extend(ctx.files.profiles)

    # configure feature classes
    _configure_gvm_features(args, injected_features)

    # add injected args before user args, so that `extra_args` has a chance to override these.
    args.add_all(injected_args)

    # append extra arguments last
    if len(ctx.attr.extra_args) > 0:
        # extra args support location + makefile expansion
        args.add_all(_expand_vars(ctx, ctx.attr.extra_args))

    return tempdir
