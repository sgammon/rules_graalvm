"Rule implementation for `native_image_layer`."

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
    "//internal/native_image:common.bzl",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
)
load(
    "//internal/native_image:layer_builder.bzl",
    _assemble_layer_build_options = "assemble_layer_build_options",
    _collect_parent_layer_infos = "collect_parent_layer_infos",
    _merge_propagated_args = "merge_propagated_args",
)
load(
    "//internal/native_image:settings.bzl",
    "NativeImageLayerInfo",
)
load(
    "//internal/native_image:toolchain.bzl",
    _resolve_cc_toolchain = "resolve_cc_toolchain",
)

# When True, parent-layer list-attrs (initialize_at_*, native_features, extra_args) are
# propagated additively into this layer's build. Classpath propagation and `--layer-use` are
# independent and always on — SVM's compat check requires them.
_LAYER_AUTO_PROPAGATE = True

# Platform-specific shared-library filename extension that native-image emits alongside the
# `.nil` when building a layer. On Linux it's `.so`, macOS `.dylib`, Windows `.dll`.
_SHARED_LIB_EXT_LINUX = ".so"
_SHARED_LIB_EXT_MACOS = ".dylib"
_SHARED_LIB_EXT_WINDOWS = ".dll"

def _graal_layer_implementation(ctx):
    graal_attr = ctx.executable.native_image_tool

    # Collect parent layers (0 or 1 today, per macro validation).
    parent_infos = _collect_parent_layer_infos(ctx)
    propagated = _merge_propagated_args(parent_infos, _LAYER_AUTO_PROPAGATE)

    # Classpath: parent's jars first (if any), then this rule's deps. `depset` dedupes so a jar
    # shared between parent and child appears once, and its topological ordering places parent
    # entries ahead of child entries — matching what SVM's layered-image compat check expects.
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

    # Resolve GraalVM toolchain.
    gvm_toolchain = ctx.toolchains[_GVM_TOOLCHAIN_TYPE].graalvm
    graal = graal_attr or gvm_toolchain.native_image_bin.files_to_run
    transitive_inputs.append(gvm_toolchain.gvm_files[DefaultInfo].files)

    if not graal:
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    # Platform detection (same as native_image).
    is_linux = ctx.target_platform_has_constraint(
        ctx.attr._linux_constraint[platform_common.ConstraintValueInfo],
    )
    is_macos = ctx.target_platform_has_constraint(
        ctx.attr._macos_constraint[platform_common.ConstraintValueInfo],
    )
    is_windows = ctx.target_platform_has_constraint(
        ctx.attr._windows_constraint[platform_common.ConstraintValueInfo],
    )

    native_toolchain = _resolve_cc_toolchain(
        ctx,
        transitive_inputs,
        is_windows = is_windows,
    )

    # `.nil` is a single-file archive in GraalVM 25+ (empirically: `-H:LayerCreate=<name>.nil`
    # produces an archive file, and native-image refuses if the path already exists as a dir).
    # Declared as a regular file; if future NI versions expand this to a directory/report bundle,
    # switch to `declare_directory` here.
    layer_tree = ctx.actions.declare_file(ctx.attr.name + ".nil")

    # The layer build also emits a platform-native shared library next to the `.nil`. Consumers
    # need this at *runtime* (the application binary is NEEDED-linked against it), so we declare
    # it as a tracked output and expose it on the provider.
    if is_macos:
        shared_lib_ext = _SHARED_LIB_EXT_MACOS
    elif is_windows:
        shared_lib_ext = _SHARED_LIB_EXT_WINDOWS
    else:
        shared_lib_ext = _SHARED_LIB_EXT_LINUX
    layer_shared_lib = ctx.actions.declare_file(ctx.attr.name + shared_lib_ext)

    path_list_separator = ";" if is_windows else ":"

    args = ctx.actions.args().use_param_file("@%s", use_always = False)

    _assemble_layer_build_options(
        ctx,
        args,
        layer_tree,
        classpath_depset,
        direct_inputs,
        native_toolchain.c_compiler_path,
        path_list_separator,
        gvm_toolchain,
        parent_infos,
        transitive_inputs,
        propagated,
    )

    # Stage `cc_deps_dynamic` shared libs adjacent to the layer's own `.so` so the layer's link
    # succeeds and the layer's RPATH can resolve them at runtime. The originals also flow into
    # `transitive_shared_libs` (below) so the final consumer's `runtime_libs/` directory ends up
    # containing every transitively required `.so` in a single co-located place — that means
    # the consumer binary's RPATH ($ORIGIN/<consumer-name>.runtime_libs) covers both the layer
    # `.so` and its dynamic deps without any further wiring. (Background: DT_RUNPATH does not
    # propagate transitively to dependent shared libs; co-locating everything at the consumer's
    # rpath dir is the simplest correct setup that avoids relying on system search paths.)
    runtime_libs_dir = ctx.attr.name + ".runtime_libs"
    cc_dyn_staged = _configure_cc_deps_dynamic(
        ctx,
        args,
        direct_inputs,
        runtime_libs_dir,
    )

    # If we staged any dynamic libs, the layer's `.so` itself needs an RPATH so it can locate
    # them at load time. We embed *two* search entries:
    #
    #   1. `$ORIGIN/<layer>.runtime_libs` — works when the layer's `.so` is loaded from its own
    #      Bazel output dir (standalone testing, `bazel run` of the layer alone).
    #   2. `$ORIGIN` — works when the layer's `.so` is loaded from a consuming binary's
    #      `runtime_libs/` flat directory, where it ends up co-located with its dynamic deps.
    #
    # Background: DT_RUNPATH is *not* transitively honoured by `ld.so` — the consumer binary's
    # RPATH does not help resolve a NEEDED entry of one of its loaded libraries. Each library
    # has to advertise its own search path. Since we co-locate everything in the consumer's
    # `runtime_libs/`, `$ORIGIN` covers that case and `$ORIGIN/<layer>.runtime_libs` covers the
    # standalone case. Skip on Windows (DLL search uses the executable directory by default).
    if cc_dyn_staged:
        rpath_args = []
        if is_macos:
            rpath_args.append("-H:NativeLinkerOption=-Wl,-rpath,@loader_path/%s" % runtime_libs_dir)
            rpath_args.append("-H:NativeLinkerOption=-Wl,-rpath,@loader_path")
        elif not is_windows:
            rpath_args.append("-H:NativeLinkerOption=-Wl,-rpath,$ORIGIN/%s:$ORIGIN" % runtime_libs_dir)
        if rpath_args:
            _experimental_args(args, rpath_args, gvm_toolchain = gvm_toolchain)

    if ctx.files.data:
        direct_inputs.extend(ctx.files.data)

    env = native_toolchain.env
    if is_linux:
        env["LC_CTYPE"] = "C.UTF-8"

    inputs = depset(direct_inputs, transitive = transitive_inputs)

    run_params = {
        "outputs": [layer_tree, layer_shared_lib],
        "executable": graal,
        "inputs": inputs,
        "mnemonic": "NativeImageLayer",
        "env": env,
        "execution_requirements": {k: "" for k in native_toolchain.execution_requirements},
        "progress_message": "Native Image Layer %{label}",
        "toolchain": Label(_GVM_TOOLCHAIN_TYPE),
    }

    graal_actions = _wrap_actions_for_graal(ctx.actions)
    if is_macos:
        xcode_args = ctx.actions.args()
        xcode_args.add(apple_support.path_placeholders.xcode(), format = "-EDEVELOPER_DIR=%s")
        xcode_args.add(apple_support.path_placeholders.sdkroot(), format = "-ESDKROOT=%s")
        xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig]
        run_params["env"]["MACOSX_DEPLOYMENT_TARGET"] = str(
            xcode_config.minimum_os_for_platform_type(apple_common.platform_type.macos),
        )
        apple_support.run(
            actions = graal_actions,
            apple_fragment = ctx.fragments.apple,
            xcode_config = xcode_config,
            xcode_path_resolve_level = apple_support.xcode_path_resolve_level.args,
            arguments = [args, xcode_args],
            **run_params
        )
    else:
        graal_actions.run(
            arguments = [args],
            **run_params
        )

    # Build this layer's provider. `propagated_args` here bakes in THIS rule's own list-attr
    # values on top of what parents already propagated, so downstream consumers see a single
    # merged view instead of having to walk the chain.
    # Use topological order so iteration produces ancestors before descendants — i.e.
    # "oldest-first" for `-H:LayerUse` emission. Default order is post-order in practice but
    # not contractually guaranteed across Bazel versions, so callers iterating with `to_list()`
    # would otherwise be relying on undocumented behavior.
    transitive_layer_files = depset(
        direct = [layer_tree],
        transitive = [p.transitive_layer_files for p in parent_infos],
        order = "topological",
    )

    # Propagate cc_deps_dynamic shared libs through `transitive_shared_libs` so the final
    # consumer's `runtime_libs/` directory contains them — the consumer's RPATH then covers
    # all transitively required dynamic libs in a single location. We propagate the staged
    # symlinks (stable basename, e.g. unversioned `libfoo.so`) rather than the canonical
    # source artifact so consumers see the same SONAME-resolvable filename ld picked at link
    # time.
    transitive_shared_libs = depset(
        direct = [layer_shared_lib] + cc_dyn_staged,
        transitive = [p.transitive_shared_libs for p in parent_infos],
    )

    merged_propagated = struct(
        initialize_at_build_time = list(propagated.initialize_at_build_time) + list(ctx.attr.initialize_at_build_time),
        initialize_at_run_time = list(propagated.initialize_at_run_time) + list(ctx.attr.initialize_at_run_time),
        native_features = list(propagated.native_features) + list(ctx.attr.native_features),
        extra_args = list(propagated.extra_args) + list(ctx.attr.extra_args),
    )

    default_files = [layer_tree, layer_shared_lib] + cc_dyn_staged
    return [
        DefaultInfo(
            files = depset(default_files),
            runfiles = ctx.runfiles(files = default_files),
        ),
        NativeImageLayerInfo(
            layer_file = layer_tree,
            shared_lib = layer_shared_lib,
            classpath_depset = classpath_depset,
            propagated_args = merged_propagated,
            transitive_layer_files = transitive_layer_files,
            transitive_shared_libs = transitive_shared_libs,
        ),
    ]

# Exports.
graal_layer_implementation = _graal_layer_implementation
LAYER_AUTO_PROPAGATE = _LAYER_AUTO_PROPAGATE
