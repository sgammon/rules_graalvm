"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@build_bazel_apple_support//lib:apple_support.bzl",
    "apple_support",
)
load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")
load(
    "//internal:argutil.bzl",
    _experimental_args = "experimental_args",
)
load(
    "//internal/native_image:action_utils.bzl",
    _wrap_actions_for_graal = "wrap_actions_for_graal",
)
load(
    "//internal/native_image:builder.bzl",
    _configure_cc_deps_dynamic = "configure_cc_deps_dynamic",
)
load(
    "//internal/native_image:cc_info.bzl",
    _build_shared_library_cc_info = "build_shared_library_cc_info",
    _declare_shared_library_headers = "declare_shared_library_headers",
)
load(
    "//internal/native_image:common.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _DEBUG_CONDITION = "DEBUG_CONDITION",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _OPTIMIZATION_MODE_CONDITION = "OPTIMIZATION_MODE_CONDITION",
    _RULES_REPO = "RULES_REPO",
    _prepare_native_image_rule_context = "prepare_native_image_rule_context",
)
load(
    "//internal/native_image:layer_builder.bzl",
    _collect_parent_layer_infos = "collect_parent_layer_infos",
    _merge_propagated_args = "merge_propagated_args",
)
load(
    "//internal/native_image:toolchain.bzl",
    _resolve_cc_toolchain = "resolve_cc_toolchain",
)

_BIN_POSTFIX_DYLIB = ".dylib"
_BIN_POSTFIX_EXE = ".exe"
_BIN_POSTFIX_DLL = ".dll"
_BIN_POSTFIX_SO = ".so"

# When True, parent-layer list-attrs (initialize_at_*, native_features, extra_args) are
# propagated additively into the child image build. Classpath propagation and `-H:LayerUse` are
# independent and always on — SVM's compatibility check requires them.
_LAYER_AUTO_PROPAGATE = True

def _build_action_message(ctx):
    _mode_label = {
        "b": "fastbuild",
        "s": "size",
        "1": "opt",
        "2": "opt",
        "default": ctx.attr.debug and "debug" or "default",
    }
    return (_mode_label[ctx.attr.optimization_mode or "default"])

def _graal_binary_implementation(ctx):
    graal_attr = ctx.executable.native_image_tool

    # Collect parent layers (0 or 1 today, per macro validation).
    parent_infos = _collect_parent_layer_infos(ctx)
    propagated = _merge_propagated_args(parent_infos, _LAYER_AUTO_PROPAGATE)

    # Classpath includes parent-layer jars first (if any) so SVM sees a superset of the parent's
    # classpath, as required by the layered-image compatibility check.
    local_cp = depset(transitive = [
        dep[cc_shim.JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
    ])
    classpath_depset = depset(transitive = [
        p.classpath_depset
        for p in parent_infos
    ] + [local_cp])

    direct_inputs = []
    transitive_inputs = [classpath_depset]

    # Parent `.nil` archives flow into the action inputs via their `transitive_layer_files`
    # depset (which includes the parent plus its own ancestors).
    for parent in parent_infos:
        transitive_inputs.append(parent.transitive_layer_files)

    # resolve via toolchains
    gvm_toolchain = ctx.toolchains[_GVM_TOOLCHAIN_TYPE].graalvm

    # if a native-image tool is explicitly provided, it should override the one
    # provided by the toolchain, but not the rest of the files it provides
    graal = graal_attr or gvm_toolchain.native_image_bin.files_to_run

    # add toolchain files to transitive inputs
    transitive_inputs.append(gvm_toolchain.gvm_files[DefaultInfo].files)

    if not graal:
        # cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    is_linux = ctx.target_platform_has_constraint(
        ctx.attr._linux_constraint[platform_common.ConstraintValueInfo],
    )
    is_macos = ctx.target_platform_has_constraint(
        ctx.attr._macos_constraint[platform_common.ConstraintValueInfo],
    )
    is_windows = ctx.target_platform_has_constraint(
        ctx.attr._windows_constraint[platform_common.ConstraintValueInfo],
    )

    # resolve the native toolchain
    native_toolchain = _resolve_cc_toolchain(
        ctx,
        transitive_inputs,
        is_windows = is_windows,
    )

    # shared libraries on macos are produced with an extension of `dylib`.
    bin_postfix = None
    if is_macos and ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_DYLIB
    elif is_windows and not ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_EXE
    elif is_windows:
        bin_postfix = _BIN_POSTFIX_DLL
    elif (not is_windows and not is_macos) and ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_SO

    args = ctx.actions.args().use_param_file("@%s", use_always = False)
    binary = _prepare_native_image_rule_context(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        native_toolchain.c_compiler_path,
        gvm_toolchain,
        bin_postfix = bin_postfix,
        propagated = propagated,
    )

    # When building a shared library, declare per-image and canonical isolate
    # headers as outputs of the native-image action so Bazel tracks them. NI
    # already emits these into `-H:Path=<binary_dir>` when `--shared` is set;
    # declaring them brings them under the action's tracked outputs.
    declared_headers = []
    if ctx.attr.shared_library:
        declared_headers = _declare_shared_library_headers(ctx, binary)

    # Optional TreeArtifact output capturing native-image's intermediate build directory so
    # downstream rules (e.g., staticlib repackers) can consume `<image>.o`.
    intermediate_dir = None
    if ctx.attr.emit_intermediate_dir:
        intermediate_dir = ctx.actions.declare_directory(ctx.attr.name + ".ni_tmp")
        _experimental_args(args, [
            "-H:TempDirectory=%s" % intermediate_dir.path,
        ], gvm_toolchain = gvm_toolchain)

    # Emit `-H:LayerUse=<ancestor.nil>` for every ancestor, oldest-first, plus the
    # per-target RUNPATH linker option — all wrapped in `experimental_args()` so the gated
    # open/close pair is version-correct (close skipped on GraalVM 21 and older).
    # Runtime linkage: the consumer binary is NEEDED-linked against each ancestor layer's shared
    # library (e.g. `libbase.so`). At runtime the dynamic linker needs to find those libraries,
    # so we:
    #   (1) embed a per-target-unique relative RUNPATH in the binary, and
    #   (2) stage a symlink of each ancestor `.so` at that relative path (below, after the
    #       native-image action is set up).
    # Symlinks are staged in a per-target subdirectory (`<target>.runtime_libs/`) rather than
    # adjacent to the binary, so that a layer and its consumer may live in the same Bazel
    # package without a declared-output collision on `libbase.so`.
    # Windows uses a different DLL search rule (executable directory is the default), so the
    # RPATH step is skipped there and only the staging step applies.
    runtime_libs_dir = ctx.attr.name + ".runtime_libs"

    # Stage `cc_deps_dynamic` shared libs into the same `<target>.runtime_libs/` directory used
    # for layer .so files — both classes of dependency share an `RPATH`. The helper declares
    # symlink actions, mutates `direct_inputs` (so the native-image action consumes them), and
    # emits `-H:CLibraryPath` + `-L`/`-l` args. Runfiles plumbing happens below alongside the
    # ancestor staging.
    cc_dyn_staged = _configure_cc_deps_dynamic(
        ctx,
        args,
        direct_inputs,
        runtime_libs_dir,
    )

    # Stage parent-layer transitive shared libs into the same `runtime_libs_dir` *before* the
    # native-image action runs, and add them to `direct_inputs`. This is required for `ld` to
    # resolve the layer's NEEDED entries at link-resolve time:
    #
    #   When `stage1_dynamic-bin` is being linked against `libbase_dyn.so` (the layer), `ld`
    #   walks the layer's NEEDED entries and tries to physically find each `.so` so it can
    #   verify the symbol references. If `libelideo11y.so` (a transitive dep of the layer)
    #   isn't on `ld`'s search path, the link aborts with "undefined reference" even though the
    #   layer itself ships with the reference correctly recorded.
    #
    # By staging into `runtime_libs_dir` and emitting `-L` for that dir below, the same files
    # serve both purposes: link-time resolution AND runtime loading via the embedded RPATH.
    seen_basenames = {staged.basename: True for staged in cc_dyn_staged}
    parent_staged_libs = []
    for parent in parent_infos:
        for ancestor_lib in parent.transitive_shared_libs.to_list():
            if ancestor_lib.basename in seen_basenames:
                continue
            seen_basenames[ancestor_lib.basename] = True
            staged = ctx.actions.declare_file("%s/%s" % (runtime_libs_dir, ancestor_lib.basename))
            ctx.actions.symlink(output = staged, target_file = ancestor_lib)
            parent_staged_libs.append(staged)
            direct_inputs.append(staged)

    # Anything in `runtime_libs_dir` (cc_deps_dynamic OR parent-propagated) needs to be on
    # `ld`'s search path. `_configure_cc_deps_dynamic` already emits `-L`/`-H:CLibraryPath` for
    # that dir when *it* stages something; if only parent-propagated libs landed there, we need
    # to emit those flags ourselves so the layer's NEEDED entries resolve at link time.
    if parent_staged_libs and not cc_dyn_staged:
        runtime_libs_dirname = parent_staged_libs[0].dirname
        args.add(runtime_libs_dirname, format = "-H:CLibraryPath=%s")
        args.add(runtime_libs_dirname, format = "-H:NativeLinkerOption=-L%s")

    # Emit RPATH whenever the binary depends on runtime-loaded shared libs — either from parent
    # layers or from user-supplied `cc_deps_dynamic`. `LayerUse` flags only fire for layers.
    needs_rpath = bool(parent_infos) or bool(cc_dyn_staged)
    if parent_infos or needs_rpath:
        layer_args = []
        for parent in parent_infos:
            for ancestor in parent.transitive_layer_files.to_list():
                layer_args.append("-H:LayerUse=%s" % ancestor.path)
        if needs_rpath:
            if is_macos:
                layer_args.append("-H:NativeLinkerOption=-Wl,-rpath,@loader_path/%s" % runtime_libs_dir)
            elif not is_windows:
                layer_args.append("-H:NativeLinkerOption=-Wl,-rpath,$ORIGIN/%s" % runtime_libs_dir)
        if layer_args:
            _experimental_args(args, layer_args, gvm_toolchain = gvm_toolchain)

    if ctx.files.data:
        direct_inputs.extend(ctx.files.data)

    env = native_toolchain.env

    # The native image will use the same native encoding (as determined by "sun.jnu.encoding")
    # as the build environment, so we need to force a UTF-8 locale. On other platforms, the
    # encoding is always UTF-8 (on macOS since JEP 400) or determined by the active code page
    # on Windows.
    # TODO: Match on the exec platform instead once Graal supports cross-compilation.
    if is_linux:
        env["LC_CTYPE"] = "C.UTF-8"

    # assemble final inputs
    inputs = depset(
        direct_inputs,
        transitive = transitive_inputs,
    )
    outputs = [binary] + declared_headers
    if intermediate_dir != None:
        outputs.append(intermediate_dir)
    run_params = {
        "outputs": outputs,
        "executable": graal,
        "inputs": inputs,
        "mnemonic": "NativeImage",
        "env": env,
        "execution_requirements": {k: "" for k in native_toolchain.execution_requirements},
        "progress_message": "Native Image __target__ (__mode__) %{label}"
            .replace("__mode__", _build_action_message(ctx))
            .replace("__target__", ctx.attr.shared_library and "[shared lib]" or "[executable]"),
        "toolchain": Label(_GVM_TOOLCHAIN_TYPE),
    }

    graal_actions = _wrap_actions_for_graal(ctx.actions)
    if is_macos:
        xcode_args = ctx.actions.args()

        # Bazel passes DEVELOPER_DIR and SDKROOT to every locally executed action that sets the
        # environment variables passed by apple_support.run. However, Graal sanitizes the
        # environment and removes these variables if set directly. We need to convert them into
        # -E options and rely on apple_support's argument replacement to pass them through to the
        # compiler invoked by Graal.
        # https://github.com/oracle/graal/blob/77a7f6a691024d22367ae33be4da0c15ceb6a246/substratevm/src/com.oracle.svm.driver/src/com/oracle/svm/driver/NativeImage.java#L1801-L1808
        xcode_args.add(apple_support.path_placeholders.xcode(), format = "-EDEVELOPER_DIR=%s")
        xcode_args.add(apple_support.path_placeholders.sdkroot(), format = "-ESDKROOT=%s")
        xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig]

        # native-image reads the MACOSX_DEPLOYMENT_TARGET env var to determine target macos version
        run_params["env"]["MACOSX_DEPLOYMENT_TARGET"] = str(xcode_config.minimum_os_for_platform_type(apple_common.platform_type.macos))
        apple_support.run(
            actions = graal_actions,
            apple_fragment = ctx.fragments.apple,
            xcode_config = xcode_config,
            xcode_path_resolve_level = apple_support.xcode_path_resolve_level.args,
            arguments = [args, xcode_args],
            **run_params
        )

    else:
        # run our proxied env shim on all other platforms.
        graal_actions.run(
            arguments = [args],
            **run_params
        )

    # All `runtime_libs_dir` symlinks (parent-propagated + cc_deps_dynamic) were declared as
    # action inputs above. Surface them in `files` and `runfiles` so `bazel build` produces
    # them on disk and `bazel run` resolves the RPATH-relative paths at startup.
    runtime_libs = parent_staged_libs + cc_dyn_staged

    cc_info_provider = None
    cc_info_staged_headers = []
    if ctx.attr.shared_library:
        cc_info_provider, cc_info_staged_headers = _build_shared_library_cc_info(
            ctx,
            binary,
            declared_headers,
        )

    default_files = [binary] + runtime_libs + cc_info_staged_headers
    if intermediate_dir != None:
        default_files.append(intermediate_dir)

    providers = [DefaultInfo(
        executable = binary,
        files = depset(default_files),
        runfiles = ctx.runfiles(
            collect_data = True,
            collect_default = True,
            files = runtime_libs,
        ),
    )]
    if intermediate_dir != None:
        providers.append(OutputGroupInfo(intermediate_dir = depset([intermediate_dir])))
    if cc_info_provider != None:
        providers.append(cc_info_provider)
    return providers

# Exports.
RULES_REPO = _RULES_REPO
DEFAULT_GVM_REPO = _DEFAULT_GVM_REPO
BAZEL_CURRENT_CPP_TOOLCHAIN = _BAZEL_CURRENT_CPP_TOOLCHAIN
BAZEL_CPP_TOOLCHAIN_TYPE = _BAZEL_CPP_TOOLCHAIN_TYPE
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
DEBUG_CONDITION = _DEBUG_CONDITION
OPTIMIZATION_MODE_CONDITION = _OPTIMIZATION_MODE_CONDITION
graal_binary_implementation = _graal_binary_implementation
LAYER_AUTO_PROPAGATE = _LAYER_AUTO_PROPAGATE
