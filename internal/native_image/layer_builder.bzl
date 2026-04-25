"Logic to assemble `native-image --layer-create` / `--layer-use` options."

load(
    "//internal:argutil.bzl",
    _experimental_args = "experimental_args",
)
load(
    "//internal/native_image:builder.bzl",
    _configure_common_build_options = "configure_common_build_options",
)
load(
    "//internal/native_image:settings.bzl",
    "NativeImageLayerInfo",
)

_VALID_DIRECTIVE_PREFIXES = ("package=", "module=", "path=")

def _has_valid_prefix(directive):
    for p in _VALID_DIRECTIVE_PREFIXES:
        if directive.startswith(p):
            return True
    return False

def _validate_directive_prefixes(directives):
    """Validate directive prefixes. Callable at macro or rule-impl time.

    Raises Starlark `fail` if any directive is malformed (bad prefix or empty value).
    """
    for d in directives:
        if not _has_valid_prefix(d):
            fail("directive '%s' must start with one of: %s" %
                 (d, ", ".join(_VALID_DIRECTIVE_PREFIXES)))
        parts = d.split("=", 1)
        if len(parts) != 2 or parts[1] == "":
            fail("directive '%s' has empty value" % d)

def _validate_path_directives(directives, classpath_files):
    """Validate `path=<value>` directives against the effective classpath.

    The NI `--layer-create=...,path=X` suboption requires X to be one of the `-cp` entries. Since
    this rule builds the classpath from `deps` + any inherited parent-layer entries, we can
    resolve `X` precisely at analysis time and fail with a clear diagnostic when the user typed a
    path that doesn't exist.
    """
    known_paths = {}
    known_shorts = {}
    for f in classpath_files:
        known_paths[f.path] = True
        known_shorts[f.short_path] = True
    for d in directives:
        if not d.startswith("path="):
            continue
        value = d[len("path="):]
        if value not in known_paths and value not in known_shorts:
            known_list = sorted(known_shorts.keys())
            fail(("layer directive 'path=%s' does not match any classpath " +
                  "entry from `deps` or inherited parent layer. Known entries:\n  %s") %
                 (value, "\n  ".join(known_list) if known_list else "(none)"))

def _collect_parent_layer_infos(ctx):
    """Return the list of `NativeImageLayerInfo` providers from `ctx.attr.layers` (0 or 1 today)."""
    if not hasattr(ctx.attr, "layers") or not ctx.attr.layers:
        return []
    return [dep[NativeImageLayerInfo] for dep in ctx.attr.layers]

def _merge_propagated_args(parent_infos, gate_enabled):
    """Merge parent layers' propagated list-attrs, parent-first. Returns a struct.

    When `gate_enabled` is False (the `_LAYER_AUTO_PROPAGATE` escape hatch), returns empty lists
    regardless of parents. Classpath propagation and `--layer-use` are unaffected; only the
    list-attr propagation is gated.
    """
    merged = {
        "initialize_at_build_time": [],
        "initialize_at_run_time": [],
        "native_features": [],
        "extra_args": [],
    }
    if not gate_enabled:
        return struct(**merged)
    for p in parent_infos:
        pa = p.propagated_args
        if pa == None:
            continue
        merged["initialize_at_build_time"] = merged["initialize_at_build_time"] + list(pa.initialize_at_build_time)
        merged["initialize_at_run_time"] = merged["initialize_at_run_time"] + list(pa.initialize_at_run_time)
        merged["native_features"] = merged["native_features"] + list(pa.native_features)
        merged["extra_args"] = merged["extra_args"] + list(pa.extra_args)
    return struct(**merged)

def _collect_layer_use_args(parent_infos, transitive_inputs):
    """Return the list of `-H:LayerUse=<ancestor.nil>` strings, oldest-first.

    Walks each direct parent's `transitive_layer_files` depset (already containing that
    parent plus all of its ancestors) and produces one `-H:LayerUse=<path>` arg per archive.
    Side effect: appends each parent's depset to `transitive_inputs` so the action sees them.

    The layer-related native-image options are experimental and must travel inside an
    `experimental_args()` block; this function only produces the strings.
    """
    out = []
    for parent in parent_infos:
        for ancestor in parent.transitive_layer_files.to_list():
            out.append("-H:LayerUse=%s" % ancestor.path)
        transitive_inputs.append(parent.transitive_layer_files)
    return out

def _layer_create_arg(ctx, layer_tree):
    """Return the `-H:LayerCreate=<basename.nil>[,<directive>,...]` arg string.

    Native-image requires the layer filename in this option to be a simple basename with no
    path separators — the enclosing directory comes from `-H:Path=<dir>` emitted separately.
    The option is experimental and must travel inside an `experimental_args()` block.
    """
    directives = list(ctx.attr.directives)
    if directives:
        payload = "%s,%s" % (layer_tree.basename, ",".join(directives))
    else:
        payload = layer_tree.basename
    return "-H:LayerCreate=%s" % payload

def assemble_layer_build_options(
        ctx,
        args,
        layer_tree,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain,
        parent_infos,
        transitive_inputs,
        propagated):
    """Assemble all native-image args for a `native_image_layer` build.

    Args:
        ctx: Rule context.
        args: Args builder.
        layer_tree: The declared `.nil` TreeArtifact this layer writes into.
        classpath_depset: Effective classpath (deps + inherited parent jars).
        direct_inputs: Mutable list of direct action inputs.
        c_compiler_path: Resolved C compiler path.
        path_list_separator: Platform path separator.
        gvm_toolchain: Resolved GraalVM toolchain.
        parent_infos: List of parent `NativeImageLayerInfo` (0 or 1 today).
        transitive_inputs: Mutable list of transitive input depsets.
        propagated: Struct of parent-propagated list-attrs.
    """

    # Validate `path=<X>` directives against the effective classpath, which already includes any
    # parent-inherited entries. Runs at analysis time.
    _validate_path_directives(ctx.attr.directives, classpath_depset.to_list())

    # `-H:LayerCreate` and `-H:LayerUse` are Early-Adopter / experimental in GraalVM 24+, so
    # gate them with `experimental_args()`. The helper emits the `-H:+UnlockExperimentalVMOptions`
    # open before, the gated args between, and the `-H:-UnlockExperimentalVMOptions` close after
    # — but only when the GraalVM version accepts the close form (22+). On older drivers the
    # close is skipped to avoid an unrecognized-flag failure.
    layer_args = []

    # Emit `-H:LayerUse` for ancestors first (resolved before create-time validation), then
    # `-H:LayerCreate` for this layer's own output.
    layer_args.extend(_collect_layer_use_args(parent_infos, transitive_inputs))
    layer_args.append(_layer_create_arg(ctx, layer_tree))
    _experimental_args(args, layer_args, gvm_toolchain = gvm_toolchain)

    # native-image requires an image name even for layer builds (`-o <name>` / `-H:Name=<name>`).
    # Derive it from the declared `.nil` basename, trimming the suffix so the auxiliary `.so`
    # lands next to the tree with a sensible name.
    image_name = layer_tree.basename
    if image_name.endswith(".nil"):
        image_name = image_name[:-len(".nil")]
    args.add(image_name, format = "-H:Name=%s")
    args.add(layer_tree.dirname, format = "-H:Path=%s")

    # SBOM is not supported for layers. We must explicitly pass `--enable-sbom=false` to avoid a warning.
    args.add("--enable-sbom=false")

    # Reuse the common builder for every non-output flag (classpath, reflection, resources,
    # compiler, optimization, extra_args, etc.).
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
validate_directive_prefixes = _validate_directive_prefixes
collect_parent_layer_infos = _collect_parent_layer_infos
merge_propagated_args = _merge_propagated_args
