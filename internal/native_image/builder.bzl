"Logic to assemble `native-image` options."

load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")
load(
    "//internal:argutil.bzl",
    _experimental_args = "experimental_args",
)

def _configure_static_zlib_compile(ctx, args, direct_inputs):
    """Configure a static image compile against hermetic/static zlib.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        direct_inputs: Inputs into the image build (mutable). """

    if cc_shim.CcInfo in ctx.attr.static_zlib and ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
        linking_context = ctx.attr.static_zlib[cc_shim.CcInfo].linking_context
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
    """Configure debug symbols for a Native Image build to match Bazel's build settings."""
    if ctx.attr.debug:
        args.add("-g")

def _configure_optimization_mode(ctx, args):
    """Configure the Native Image optimization mode to match Bazel's build setting."""
    if ctx.attr.optimization_mode:
        args.add(
            ctx.attr.optimization_mode,
            format = "-O%s",
        )

def _configure_proxy(ctx, args, direct_inputs):
    """Configure proxy settings for a Native Image build."""
    if ctx.attr.proxy_configuration != None:
        args.add(ctx.file.proxy_configuration, format = "-H:DynamicProxyConfigurationFiles=%s")
        direct_inputs.append(ctx.file.proxy_configuration)

def _configure_resources(ctx, args, direct_inputs, gvm_toolchain = None):
    """Configure resource settings for a Native Image build."""
    if ctx.attr.include_resources != None and ctx.attr.include_resources != "":
        _experimental_args(
            args,
            ["-H:IncludeResources=%s" % ctx.attr.include_resources],
            gvm_toolchain = gvm_toolchain,
        )

    if ctx.attr.resource_configuration != None:
        args.add(ctx.file.resource_configuration, format = "-H:ResourceConfigurationFiles=%s")
        direct_inputs.append(ctx.file.resource_configuration)

def _configure_reflection(ctx, args, direct_inputs, propagated = None):
    """Configure reflection and class-init settings for a Native Image build.

    Propagated parent-layer values (if any) are prepended to this rule's values so SVM sees a
    consistent, additive set of `--initialize-at-*` flags.
    """
    init_build = (
        (list(propagated.initialize_at_build_time) if propagated else []) +
        list(ctx.attr.initialize_at_build_time)
    )
    init_run = (
        (list(propagated.initialize_at_run_time) if propagated else []) +
        list(ctx.attr.initialize_at_run_time)
    )
    args.add_joined(
        init_build,
        join_with = ",",
        format_joined = "--initialize-at-build-time=%s",
    )
    args.add_joined(
        init_run,
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

    if ctx.attr.serialization_configuration != None:
        args.add(ctx.file.serialization_configuration, format = "-H:SerializationConfigurationFiles=%s")
        direct_inputs.append(ctx.file.serialization_configuration)

def _configure_native_compiler(ctx, args, c_compiler_path, gvm_toolchain):
    """Configure native compiler and linker flags for a Native Image build."""

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

    # add explicit linker options (string-form, e.g. `-Wl,...` directives or `-l<name>`)
    if hasattr(ctx.attr, "native_linker_option"):
        args.add_all(
            ctx.attr.native_linker_option,
            format_each = "-H:NativeLinkerOption=%s",
        )

def _configure_cc_deps(ctx, args, direct_inputs):
    """Stage `cc_deps` static archives as inputs and emit linker flags for each.

    Bazel-side paths for action inputs are execroot-relative (`bazel-out/...`). Native-image
    spawns its C toolchain (ld / gcc) with a CWD that differs from the Bazel execroot — its
    own temporary build directory — so a raw execroot-relative path handed to ld does not
    resolve. This mirrors the behavior seen in `static_zlib` handling.

    To work around that, we:
      1. Symlink each static archive into a per-target subdir (`<target>_cc_deps/`) so the
         layer / native_image target owns the staged files and has no path collision when it
         lives in the same Bazel package as the cc_library producing the archive.
      2. Emit one `-H:CLibraryPath=<subdir>` — native-image resolves this to an absolute path
         before forwarding to the C toolchain as `-L<abs-path>`, so ld sees a valid search
         directory regardless of where it happens to chdir.
      3. Emit `-H:NativeLinkerOption=-l:<filename>` for each archive, which tells GNU ld to
         link that exact file from the search path (bypasses ld's default `lib<name>.{so,a}`
         resolution order).
    """
    if not hasattr(ctx.attr, "cc_deps") or not ctx.attr.cc_deps:
        return

    archives = []
    for dep in ctx.attr.cc_deps:
        linking_context = dep[cc_shim.CcInfo].linking_context
        if linking_context == None:
            continue
        linker_inputs = linking_context.linker_inputs.to_list()
        for linker_input in linker_inputs:
            libraries = linker_input.libraries
            if type(libraries) == type(depset([])):
                libraries = libraries.to_list()
            for library in libraries:
                archive = library.pic_static_library or library.static_library
                if archive == None:
                    # Pre-built dynamic-only entries (a cc_import without a static member)
                    # are skipped — they would need separate wiring via `native_linker_option`
                    # with `-L` / `-l` flags plus runfiles setup for the `.so`.
                    continue
                archives.append(archive)

    if not archives:
        return

    staged_dir_name = ctx.attr.name + "_cc_deps"
    search_dir = None
    for archive in archives:
        staged = ctx.actions.declare_file("%s/%s" % (staged_dir_name, archive.basename))
        ctx.actions.symlink(output = staged, target_file = archive)
        direct_inputs.append(staged)

        # Deduplicate basenames at the search-path level: if two archives have the same
        # filename (e.g. two `libfoo.a` from different cc_library targets), the second
        # `declare_file` call would collide. `declare_file` already fails loudly in that
        # case, so we don't need to guard here — but it is worth calling out.
        if search_dir == None:
            search_dir = staged.dirname

        # Note: emit one -l:<filename> per archive. Using `-l:foo.a` rather than `-lfoo`
        # forces ld to pick this exact file, not lib<name>.so if both happen to be on the
        # search path. All archives share the same search_dir (staged subdir), so a single
        # -H:CLibraryPath entry below covers them.
        args.add(archive.basename, format = "-H:NativeLinkerOption=-l:%s")

    if search_dir != None:
        args.add(search_dir, format = "-H:CLibraryPath=%s")

def _libname_from_dynamic(filename):
    """Strip the `lib` prefix and the platform-specific shared-library suffix from `filename`.

    Bazel's `library.dynamic_library` / `resolved_symlink_dynamic_library` exposes the basename
    in the canonical `lib<name>.{so,dylib}` form (or `<name>.dll` on Windows). We feed
    `<name>` to ld via `-l<name>` so it performs normal SONAME resolution against the staged
    search directory. This intentionally differs from `cc_deps` (static), which uses the
    `-l:<filename>` form to force exact-file linkage.
    """

    # Linux versioned `.so.N.M` is unusual for `cc_library` outputs and would need a more
    # involved strip; we emit the basename as-is in that case so the failure surfaces at
    # link time rather than silently producing a wrong `-l` flag.
    base = filename
    suffixes = (".so", ".dylib", ".dll")
    for suffix in suffixes:
        if base.endswith(suffix):
            base = base[:-len(suffix)]
            break
    if base.startswith("lib"):
        base = base[len("lib"):]
    return base

def _configure_cc_deps_dynamic(ctx, args, direct_inputs, runtime_libs_dir):
    """Stage `cc_deps_dynamic` shared libraries adjacent to the produced binary.

    For each dep, walk `linking_context.linker_inputs.libraries`, select a dynamic library
    (`library.dynamic_library`, falling back to `library.resolved_symlink_dynamic_library` —
    `rules_cc` surfaces the unversioned `.so` name there when the canonical artifact is the
    versioned variant), and symlink it into a per-target `<runtime_libs_dir>/` subdirectory.

    Emits one `-H:CLibraryPath=<staged-dir>` (native-image resolves to an absolute path before
    forwarding to ld, mirroring the `cc_deps` trick — ld's CWD differs from the Bazel execroot
    when native-image spawns it). Per-library: `-H:NativeLinkerOption=-L<staged-dir>` plus
    `-H:NativeLinkerOption=-l<libname>` (NOT the `-l:filename` form — dynamic linkage allows ld
    to find the SONAME, so we let it do its normal `lib<name>.{so,dylib}` resolution).

    Returns:
        A list of declared `File`s representing the staged dynamic libraries. Callers should
        merge these into the rule's `DefaultInfo.files` and `ctx.runfiles(files=...)` so
        `bazel build` materializes them and `bazel run` resolves them at runtime via the
        embedded `RPATH` (set up separately by the consuming rule).
    """
    if not hasattr(ctx.attr, "cc_deps_dynamic") or not ctx.attr.cc_deps_dynamic:
        return []

    dynamic_libs = []
    for dep in ctx.attr.cc_deps_dynamic:
        linking_context = dep[cc_shim.CcInfo].linking_context
        if linking_context == None:
            continue
        linker_inputs = linking_context.linker_inputs.to_list()
        for linker_input in linker_inputs:
            libraries = linker_input.libraries
            if type(libraries) == type(depset([])):
                libraries = libraries.to_list()
            for library in libraries:
                # Prefer the canonical dynamic_library; fall back to the resolved symlink (which
                # rules_cc populates with the unversioned `.so` form when the canonical entry is
                # versioned, e.g. `libfoo.so.1.2`).
                dyn = library.dynamic_library
                resolved = getattr(library, "resolved_symlink_dynamic_library", None)
                if resolved != None:
                    dyn = resolved
                if dyn == None:
                    # Static-only entry — caller probably wanted `cc_deps` instead. Skip rather
                    # than fail; the link will fail later if a needed symbol is missing.
                    continue
                dynamic_libs.append(dyn)

    if not dynamic_libs:
        return []

    # Dedupe by basename — two deps surfacing the same `.so` (e.g. one declared directly, one
    # transitively) would otherwise collide on `declare_file`. First-wins.
    seen_basenames = {}
    staged_libs = []
    search_dir = None
    for dyn in dynamic_libs:
        if dyn.basename in seen_basenames:
            continue
        seen_basenames[dyn.basename] = True
        staged = ctx.actions.declare_file("%s/%s" % (runtime_libs_dir, dyn.basename))
        ctx.actions.symlink(output = staged, target_file = dyn)
        direct_inputs.append(staged)
        staged_libs.append(staged)
        if search_dir == None:
            search_dir = staged.dirname

        libname = _libname_from_dynamic(dyn.basename)
        args.add(libname, format = "-H:NativeLinkerOption=-l%s")

    if search_dir != None:
        args.add(search_dir, format = "-H:CLibraryPath=%s")
        args.add(search_dir, format = "-H:NativeLinkerOption=-L%s")

    return staged_libs

def _configure_native_test_flags(ctx, args):
    """Configure native testing flags; only applies if we are building a test-only target."""
    if ctx.attr.coverage:
        args.add("--tool:coverage")

def _configure_output_mode(ctx, args, binary, bin_postfix, gvm_toolchain = None):
    """Emit the executable / shared-lib output flags.

    Called only for `native_image`, never for `native_image_layer` (layers have no main class,
    no --shared, and write to a TreeArtifact via --layer-create instead of -H:Path).
    """

    if ctx.attr.shared_library:
        args.add("--shared")
    elif ctx.attr.main_class == None or ctx.attr.main_class == "":
        fail("""
            Native Image build failure: `main_class` attribute is mandatory in `native_image` or `graal_binary` targets,
            unless `shared_library=True`.
        """)

    trimmed_basename = binary.basename
    if bin_postfix:
        trimmed_basename = trimmed_basename[0:-(len(bin_postfix))]

    _experimental_args(args, [
        "-H:Class=%s" % ctx.attr.main_class,
        "-H:Name=%s" % trimmed_basename,
        "-H:Path=%s" % binary.dirname,
    ], gvm_toolchain = gvm_toolchain)
    if ctx.files.profiles:
        args.add_joined(
            ctx.files.profiles,
            join_with = ",",
            format_joined = "--pgo=%s",
        )

def _configure_common_build_options(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain,
        propagated = None):
    """Emit all non-output-mode args — shared between `native_image` and `native_image_layer`.

    Args:
        ctx: Rule context.
        args: Args builder.
        classpath_depset: Effective classpath (already includes any parent-layer jars).
        direct_inputs: Direct inputs (mutable).
        c_compiler_path: Resolved C compiler path.
        path_list_separator: Platform path separator for -cp.
        gvm_toolchain: Resolved GraalVM toolchain, or None for legacy rules.
        propagated: Optional struct(initialize_at_build_time, initialize_at_run_time,
            native_features, extra_args) of values inherited from parent layers and prepended to
            this rule's values.
    """

    args.add("-H:+ReportExceptionStackTraces")

    if not ctx.attr.check_toolchains:
        _experimental_args(args, ["-H:-CheckToolchain"], gvm_toolchain = gvm_toolchain)

    # assemble classpath
    args.add_joined(
        "-cp",
        classpath_depset,
        join_with = path_list_separator,
    )

    # merged features (parent-propagated first, this rule's appended)
    features_list = (
        (list(propagated.native_features) if propagated else []) +
        list(ctx.attr.native_features)
    )
    args.add_joined(
        features_list,
        join_with = ",",
        format_joined = "-H:Features=%s",
    )

    _configure_native_compiler(ctx, args, c_compiler_path, gvm_toolchain)
    _configure_reflection(ctx, args, direct_inputs, propagated = propagated)
    _configure_resources(ctx, args, direct_inputs, gvm_toolchain = gvm_toolchain)
    _configure_proxy(ctx, args, direct_inputs)

    if ctx.attr.static_zlib != None:
        _configure_static_zlib_compile(ctx, args, direct_inputs)

    _configure_cc_deps(ctx, args, direct_inputs)

    # `profiles` only exists on the executable (`native_image`) rule — guarded for layer rule.
    if hasattr(ctx.files, "profiles") and ctx.files.profiles:
        direct_inputs.extend(ctx.files.profiles)

    if ctx.attr.testonly:
        _configure_native_test_flags(ctx, args)

    # extra_args: propagated parent values first, then this rule's (last-wins semantics preserved).
    if propagated and propagated.extra_args:
        for arg in propagated.extra_args:
            expanded_arg = ctx.expand_make_variables(
                "extra_args",
                ctx.expand_location(arg, ctx.attr.data),
                {},
            )
            if expanded_arg or not arg:
                args.add(expanded_arg)

    for arg in ctx.attr.extra_args:
        expanded_arg = ctx.expand_make_variables(
            "extra_args",
            ctx.expand_location(arg, ctx.attr.data),
            {},
        )
        if expanded_arg or not arg:
            args.add(expanded_arg)

def assemble_native_build_options(
        ctx,
        args,
        binary,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain = None,
        bin_postfix = None,
        propagated = None):
    """Assemble the effective arguments to `native-image` for an executable/shared-lib build.

    Args:
        ctx: Context of the Native Image rule implementation.
        args: Args builder for the Native Image build.
        binary: Target output binary which will be built with Native Image.
        classpath_depset: Classpath dependency set (may already include parent-layer entries).
        direct_inputs: Direct inputs into the native image build (mutable).
        c_compiler_path: Path to the C compiler; resolved via toolchains.
        path_list_separator: Platform-specific path separator.
        gvm_toolchain: Resolved GraalVM toolchain, or `None` if a tool target is in use via legacy rules.
        bin_postfix: Binary postfix expected from the output file (for example, `.exe` or `.dylib`).
        propagated: Optional struct of values propagated from parent layers, prepended additively.
    """
    _configure_output_mode(ctx, args, binary, bin_postfix, gvm_toolchain = gvm_toolchain)
    _configure_common_build_options(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain,
        propagated = propagated,
    )

# Exports.
configure_common_build_options = _configure_common_build_options
configure_output_mode = _configure_output_mode
configure_cc_deps_dynamic = _configure_cc_deps_dynamic
