"""Helpers for surfacing CcInfo from `native_image(shared_library = True)` targets.

The shared-library code path declares every header Native Image emits — both the
canonical isolate pair (`graal_isolate.h`, `graal_isolate_dynamic.h`) and the
per-image pair (`<image>.h`, `<image>_dynamic.h`) plus any user-listed
`extra_headers` — as outputs of the existing native-image action. All declared
headers are then symlinked into a per-target include directory and surfaced via
`CcInfo.compilation_context.headers` plus `quote_includes`. The produced
`.so`/`.dylib`/`.dll` is surfaced via `CcInfo.linking_context`.

Two helpers, both called from `_graal_binary_implementation`:

  1. `declare_shared_library_headers(ctx, binary)` — declares the four canonical
     and per-image header outputs (plus extras) so the native-image action
     produces them as tracked artifacts. Returns the list of declared `File`s,
     which the caller adds to the action's `outputs`.

  2. `build_shared_library_cc_info(ctx, binary, declared_headers)` — stages the
     declared headers into `<target>_includes/` via symlink, builds a CcInfo
     with that include dir as a `quote_include` and the binary as a dynamic
     library, and returns the CcInfo plus the staged headers (so the caller can
     add them to `default_files`).

Note on dedup: when multiple `native_image(shared_library=True)` targets are
deps of one consumer, the consumer sees N copies of `graal_isolate.h` (one per
target) reachable via N `-iquote` paths. This is content-equivalent — the
canonical headers are identical for any fixed Native Image version under one
GraalVM toolchain — and the compiler picks the first match. If real
cross-version conflicts ever surface, a follow-up can introduce a hidden
anchor target; this implementation deliberately avoids the complexity until
needed.
"""

load(
    "@bazel_tools//tools/cpp:toolchain_utils.bzl",
    "find_cpp_toolchain",
)
load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")

_SHARED_LIB_SUFFIXES = (".so", ".dylib", ".dll")
_CANONICAL_ISOLATE_HEADERS = ("graal_isolate.h", "graal_isolate_dynamic.h")

def _image_basename_from_binary(binary_basename):
    """Strip the `.so`/`.dylib`/`.dll` suffix from `binary_basename`.

    Native Image emits `<image_basename>.h` and `<image_basename>_dynamic.h` next
    to the shared library, where `<image_basename>` is exactly what was passed
    via `-H:Name=<…>`. The rule passes `binary.basename` minus the platform
    suffix as the image name (see `_configure_output_mode` in builder.bzl), so
    we apply the matching transformation here. We do NOT strip the `lib`
    prefix: NI keeps it verbatim in the emitted header filenames (`libfoo.h`,
    `libfoo_dynamic.h` for a `libfoo.so` shared library on Linux).
    """
    base = binary_basename
    for suffix in _SHARED_LIB_SUFFIXES:
        if base.endswith(suffix):
            base = base[:-len(suffix)]
            break
    return base

def declare_shared_library_headers(ctx, binary):
    """Declare canonical + per-image header outputs for a `shared_library = True` build.

    Returns a list of `File` outputs:
      - `graal_isolate.h`, `graal_isolate_dynamic.h` (canonical, emitted by NI for any
        `--shared` build)
      - `<image>.h`, `<image>_dynamic.h` (per-image, derived from `binary.basename`)
      - one entry per `ctx.attr.extra_headers` filename
    Each is `declare_file()`-ed as a sibling of `binary` (i.e. inside native-image's
    `-H:Path` target dir) so the action produces them as natural co-located outputs
    without extra flags.
    """
    image_basename = _image_basename_from_binary(binary.basename)
    per_image = ["%s.h" % image_basename, "%s_dynamic.h" % image_basename]
    all_headers = list(_CANONICAL_ISOLATE_HEADERS) + per_image + list(ctx.attr.extra_headers)

    declared = []
    for header_name in all_headers:
        out = ctx.actions.declare_file(header_name, sibling = binary)
        declared.append(out)
    return declared

def build_shared_library_cc_info(ctx, binary, declared_headers):
    """Construct CcInfo for a `shared_library = True` native_image.

    Stages declared headers into a per-target `<target>_includes/` dir via symlink
    (so the include search root is clean — free of the `.so` and any other build
    artifacts). Builds a `compilation_context` (headers + quote_includes) and a
    `linking_context` (dynamic_library = binary).

    Returns: a tuple `(cc_info, staged_headers)`. The caller should add
    `staged_headers` to `default_files` so `bazel build` materializes the
    include dir.
    """
    cc_common = cc_shim.cc_common

    include_dir_name = ctx.label.name + "_includes"
    staged_headers = []
    for declared in declared_headers:
        staged = ctx.actions.declare_file("%s/%s" % (include_dir_name, declared.basename))
        ctx.actions.symlink(output = staged, target_file = declared)
        staged_headers.append(staged)

    quote_dir = staged_headers[0].dirname if staged_headers else None

    compilation_context = cc_common.create_compilation_context(
        headers = depset(staged_headers),
        quote_includes = depset([quote_dir]) if quote_dir else depset([]),
    )

    # Link context: surface the `.so` as a dynamic library so consumers' link
    # actions pick it up. We don't need a static archive (no `.a`); native-image
    # doesn't produce one in `--shared` mode.
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    library_to_link = cc_common.create_library_to_link(
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        dynamic_library = binary,
    )
    linker_input = cc_common.create_linker_input(
        owner = ctx.label,
        libraries = depset([library_to_link]),
    )
    linking_context = cc_common.create_linking_context(
        linker_inputs = depset([linker_input]),
    )

    cc_info = cc_shim.CcInfo(
        compilation_context = compilation_context,
        linking_context = linking_context,
    )
    return cc_info, staged_headers
