"Rule implementation for `native_image_layer`."

load(
    "@build_bazel_apple_support//lib:apple_support.bzl",
    "apple_support",
)
load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")
load(
    "//internal/native_image:action_utils.bzl",
    _wrap_actions_for_graal = "wrap_actions_for_graal",
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

    # The `.nil` output is a TreeArtifact — native-image writes `shared-layer.{so,big,lsb,properties}`
    # (and potentially reports / diagnostics in future versions) into this directory.
    layer_tree = ctx.actions.declare_directory(ctx.attr.name + ".nil")

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

    if ctx.files.data:
        direct_inputs.extend(ctx.files.data)

    env = native_toolchain.env
    if is_linux:
        env["LC_CTYPE"] = "C.UTF-8"

    inputs = depset(direct_inputs, transitive = transitive_inputs)

    run_params = {
        "outputs": [layer_tree],
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
    transitive_layer_files = depset(
        direct = [layer_tree],
        transitive = [p.transitive_layer_files for p in parent_infos],
    )

    merged_propagated = struct(
        initialize_at_build_time = list(propagated.initialize_at_build_time) + list(ctx.attr.initialize_at_build_time),
        initialize_at_run_time = list(propagated.initialize_at_run_time) + list(ctx.attr.initialize_at_run_time),
        native_features = list(propagated.native_features) + list(ctx.attr.native_features),
        extra_args = list(propagated.extra_args) + list(ctx.attr.extra_args),
    )

    return [
        DefaultInfo(
            files = depset([layer_tree]),
            runfiles = ctx.runfiles(files = [layer_tree]),
        ),
        NativeImageLayerInfo(
            layer_file = layer_tree,
            classpath_depset = classpath_depset,
            propagated_args = merged_propagated,
            transitive_layer_files = transitive_layer_files,
        ),
    ]

# Exports.
graal_layer_implementation = _graal_layer_implementation
LAYER_AUTO_PROPAGATE = _LAYER_AUTO_PROPAGATE
