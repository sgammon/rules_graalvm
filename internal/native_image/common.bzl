"Defines common properties shared by modern and legacy Native Image rules."

load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")
load(
    "//internal/native_image:builder.bzl",
    _assemble_native_build_options = "assemble_native_build_options",
)
load(
    "//internal/native_image:settings.bzl",
    "NativeImageLayerInfo",
)

_RULES_REPO = "@rules_graalvm"
_DEFAULT_GVM_REPO = "@graalvm"
_GVM_TOOLCHAIN_TYPE = "%s//graalvm/toolchain" % _RULES_REPO
_BAZEL_CPP_TOOLCHAIN_TYPE = "@bazel_tools//tools/cpp:toolchain_type"
_BAZEL_CURRENT_CPP_TOOLCHAIN = "@bazel_tools//tools/cpp:current_cc_toolchain"
_LINUX_CONSTRAINT = "@platforms//os:linux"
_MACOS_CONSTRAINT = "@platforms//os:macos"
_WINDOWS_CONSTRAINT = "@platforms//os:windows"

# buildifier: disable=name-conventions
_NativeImageOptimization = struct(
    DEFAULT = "",
    FASTBUILD = "b",
    OPTIMIZED_LEVEL_1 = "1",
    OPTIMIZED_LEVEL_2 = "2",
)

_DEBUG_CONDITION = select({
    "@rules_graalvm//internal/conditions/compiler:debug": True,
    "//conditions:default": False,
})

_COVERAGE_CONDITION = select({
    "@rules_graalvm//internal/conditions/tools:coverage": True,
    "//conditions:default": False,
})

_OPTIMIZATION_MODE_CONDITION = select({
    "@rules_graalvm//internal/conditions/compiler:fastbuild": _NativeImageOptimization.FASTBUILD,  # becomes `-Ob`
    "@rules_graalvm//internal/conditions/compiler:optimized": _NativeImageOptimization.OPTIMIZED_LEVEL_2,  # becomes `-O2`
    "//conditions:default": _NativeImageOptimization.DEFAULT,  # becomes `-O2` via GraalVM defaults
})

_NATIVE_IMAGE_ATTRS = {
    "deps": attr.label_list(
        providers = [[cc_shim.JavaInfo]],
        mandatory = True,
    ),
    "main_class": attr.string(
        mandatory = False,
    ),
    "shared_library": attr.bool(
        mandatory = False,
        default = False,
    ),
    "allow_fallback": attr.bool(
        mandatory = False,
        default = False,
    ),
    "include_resources": attr.string(
        mandatory = False,
    ),
    "reflection_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "jni_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "serialization_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "debug": attr.bool(
        mandatory = False,
        default = False,
    ),
    "optimization_mode": attr.string(
        mandatory = False,
        values = [
            _NativeImageOptimization.DEFAULT,
            _NativeImageOptimization.FASTBUILD,
            _NativeImageOptimization.OPTIMIZED_LEVEL_1,
            _NativeImageOptimization.OPTIMIZED_LEVEL_2,
        ],
    ),
    "coverage": attr.bool(
        mandatory = False,
        default = False,
    ),
    "initialize_at_build_time": attr.string_list(
        mandatory = False,
    ),
    "initialize_at_run_time": attr.string_list(
        mandatory = False,
    ),
    "native_features": attr.string_list(
        mandatory = False,
    ),
    "static_zlib": attr.label(
        providers = [[cc_shim.CcInfo]],
    ),
    "data": attr.label_list(
        allow_files = True,
    ),
    "configuration_file_directories": attr.label_list(
        doc = "Declared Native Image configuration-directory targets. Each target must resolve " +
              "to one non-empty, execution-root-relative directory (either a directory " +
              "TreeArtifact or files sharing one parent). Every resolved file is a direct " +
              "Native Image action input, and the rule emits one deterministic " +
              "`-H:ConfigurationFileDirectories=` path list. Use this for GraalVM's " +
              "directory-format reachability metadata; do not encode label paths in " +
              "`extra_args`.",
        allow_files = True,
        mandatory = False,
        default = [],
    ),
    "extra_args": attr.string_list(
        mandatory = False,
    ),
    "check_toolchains": attr.bool(
        default = True,
    ),
    "c_compiler_option": attr.string_list(
        mandatory = False,
    ),
    "native_linker_option": attr.string_list(
        doc = "Extra linker options to forward via `-H:NativeLinkerOption=<value>`. Each list " +
              "entry produces one flag. Use this for `-Wl,...` directives or explicit `-l<name>` " +
              "entries; for static archives produced by `cc_library` targets, prefer `cc_deps` " +
              "which stages the archive as an input automatically.",
        mandatory = False,
    ),
    "cc_deps": attr.label_list(
        doc = "C/C++ static-archive deps to link into the produced binary or layer. Each entry " +
              "must provide `CcInfo`; the rule extracts the static library from each (preferring " +
              "PIC over non-PIC), stages it as a direct action input, and emits a matching " +
              "`-H:NativeLinkerOption=<archive-path>` so native-image's linker invocation pulls " +
              "it in. Use this to satisfy `@CFunction` / JNI references defined in companion " +
              "Rust / C / C++ libraries (typical `rust_static_library` outputs surface CcInfo).",
        providers = [[cc_shim.CcInfo]],
        mandatory = False,
    ),
    "cc_deps_dynamic": attr.label_list(
        doc = "C/C++ dynamic-library deps (`.so`/`.dylib`/`.dll`) to link into the produced " +
              "binary or layer at native-image link time and resolve at runtime. Each entry " +
              "must provide `CcInfo`; the rule walks each linker input, picks the dynamic " +
              "library (`library.dynamic_library`, falling back to " +
              "`library.resolved_symlink_dynamic_library` when set — that's how `rules_cc` " +
              "surfaces unversioned `.so` names), and stages it adjacent to the produced " +
              "binary under a per-target `<target>.runtime_libs/` subdirectory. Native-image " +
              "is given `-L<staged-dir>` plus `-l<libname>` so ld performs normal SONAME " +
              "resolution; on Linux/macOS an `RPATH` of `$ORIGIN`/`@loader_path` is also " +
              "emitted (Windows uses the executable directory by default, so RPATH is " +
              "skipped). Use this for dynamic-image variants where the consumer expects a " +
              "runtime-loaded shared library, not a statically linked archive.",
        providers = [[cc_shim.CcInfo]],
        mandatory = False,
    ),
    "extra_headers": attr.string_list(
        doc = "Additional header filenames Native Image is expected to emit alongside the " +
              "shared library when `shared_library = True`. Each entry is a basename (no " +
              "directory component); the rule declares it as an output of the native-image " +
              "action and surfaces it via `CcInfo.compilation_context.headers`. Use this for " +
              "configurations where Native Image emits more than the canonical " +
              "`<image>.h` / `<image>_dynamic.h` per-image headers — e.g. when custom " +
              "`@CEntryPoint`-bearing features inject their own headers. Meaningless when " +
              "`shared_library = False`; the public macro rejects that combination.",
        mandatory = False,
        default = [],
    ),
    "executable_name": attr.string(
        mandatory = True,
    ),
    "emit_intermediate_dir": attr.bool(
        doc = "If True, declare a TreeArtifact and pass `-H:TempDirectory=<path>` so the " +
              "intermediate build directory (containing `<image>.o` etc.) is preserved as a " +
              "declared output. Used by downstream rules that need to repack native-image " +
              "object files into a static library.",
        mandatory = False,
        default = False,
    ),
    "relocate_polyglot_cache": attr.bool(
        doc = "If True, point the GraalVM polyglot internal-resource cache " +
              "(`polyglot.engine.userResourceCache`) at a subdirectory of the intermediate " +
              "build directory rather than its default `$HOME/.cache/org.graalvm.polyglot`. " +
              "Requires `emit_intermediate_dir = True` (the cache is written under that " +
              "TreeArtifact); it is a silent no-op otherwise. With the optimizing Truffle " +
              "runtime active, the native-image *builder* installs the `truffleattach` " +
              "resource into this cache at build time; on remote executors (RBE) where " +
              "`$HOME` and `/tmp` are not writable, the default location fails the build with " +
              "\"resource cache folder ... is not a readable and writable directory\" " +
              "(`JDKSupport`/`InternalResourceCache`). The intermediate dir is a declared " +
              "output and is writable on every executor, so routing the cache there fixes it. " +
              "Affects the builder JVM only (`-J-D`); the image's own runtime resource cache " +
              "(resolved from the executable location) is untouched.",
        mandatory = False,
        default = False,
    ),
    "emit_language_resources": attr.bool(
        doc = "If True, declare a TreeArtifact for the `<binary_dir>/resources/` tree that " +
              "native-image emits when `-H:+CopyLanguageResources` is set. Truffle languages " +
              "(GraalPy, Ruby, ...) read filesystem-rooted paths under this tree at startup " +
              "(e.g. GraalPy needs `python/python-home/lib/graalpy<ver>/` to resolve " +
              "`--python.{CoreHome,SysPrefix,StdLibHome,CAPI}`). The tree artifact is exposed " +
              "via `DefaultInfo.files` and runfiles so downstream `bazel run` / packaging " +
              "rules can stage it next to the binary. Caller must also pass " +
              "`-H:-IncludeLanguageResources -H:+CopyLanguageResources` in `extra_args`.",
        mandatory = False,
        default = False,
    ),
    "emit_obfuscation_mapping": attr.bool(
        doc = "If True, declare `<image-name>.obfuscation-mapping.json` (the obfuscation " +
              "symbol map native-image writes next to the binary when " +
              "`-H:AdvancedObfuscation=export-mapping` is in effect) as an output of the " +
              "native-image action, exposed via `OutputGroupInfo(obfuscation_mapping=...)`. " +
              "The file is NOT added to `DefaultInfo.files` — it can be tens of MiB, so only " +
              "output-group consumers pull it; plain consumers of the binary don't drag it " +
              "along. The mapping is not produced for every image, so this is opt-in: the " +
              "caller MUST also pass `-H:AdvancedObfuscation=export-mapping` in `extra_args` in " +
              "tandem, otherwise the declared output is never written and the build fails " +
              "(declared-but-unwritten output).",
        mandatory = False,
        default = False,
    ),
    "profiles": attr.label_list(
        allow_files = True,
        mandatory = False,
    ),
    "resource_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "proxy_configuration": attr.label(
        mandatory = False,
        allow_single_file = True,
    ),
    "layers": attr.label_list(
        doc = "Parent GraalVM Native Image layer(s) to consume via `--layer-use`. Today: at most 1 entry.",
        providers = [[NativeImageLayerInfo]],
        mandatory = False,
        default = [],
    ),
    "_cc_toolchain": attr.label(
        default = Label(_BAZEL_CURRENT_CPP_TOOLCHAIN),
    ),
    "_linux_constraint": attr.label(
        default = Label(_LINUX_CONSTRAINT),
    ),
    "_macos_constraint": attr.label(
        default = Label(_MACOS_CONSTRAINT),
    ),
    "_windows_constraint": attr.label(
        default = Label(_WINDOWS_CONSTRAINT),
    ),
    "_xcode_config": attr.label(
        default = configuration_field(
            fragment = "apple",
            name = "xcode_config_label",
        ),
    ),
}

# Attribute set excluded from `native_image_layer` — these apply only to executable/shared-lib
# outputs, not layer archives.
_LAYER_EXCLUDED_ATTRS = [
    "main_class",
    "shared_library",
    "executable_name",
    "profiles",
    "extra_headers",
    "configuration_file_directories",
]

_NATIVE_IMAGE_LAYER_ATTRS = {
    k: v
    for k, v in _NATIVE_IMAGE_ATTRS.items()
    if k not in _LAYER_EXCLUDED_ATTRS
}

_NATIVE_IMAGE_LAYER_ATTRS["directives"] = attr.string_list(
    doc = "Content filters emitted after `--layer-create=<path>,...`. Each entry must start with `package=`, `module=`, or `path=`.",
    mandatory = False,
    default = [],
)

def _prepare_bin_name(
        name,
        bin_postfix = None):
    """Handle postfix for the output binary on various platforms."""
    if bin_postfix:
        return "%s%s" % (name, bin_postfix)
    return name

def _prepare_native_image_rule_context(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        gvm_toolchain = None,
        bin_postfix = None,
        propagated = None):
    """Prepare a `native-image` build context."""

    out_bin_name = ctx.attr.executable_name.replace("%target%", ctx.attr.name)
    binary = ctx.actions.declare_file(_prepare_bin_name(out_bin_name, bin_postfix))

    # TODO: This check really should be on the exec platform, not the target platform, but that
    # requires going through a separate rule. Since GraalVM doesn't support cross-compilation, the
    # distinction doesn't matter for now.
    if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        path_list_separator = ";"
    else:
        path_list_separator = ":"

    _assemble_native_build_options(
        ctx,
        args,
        binary,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        path_list_separator,
        gvm_toolchain,
        bin_postfix,
        propagated = propagated,
    )
    return binary

## Exports.

# buildifier: disable=name-conventions
NativeImageOptimization = _NativeImageOptimization

RULES_REPO = _RULES_REPO
DEFAULT_GVM_REPO = _DEFAULT_GVM_REPO
DEBUG_CONDITION = _DEBUG_CONDITION
COVERAGE_CONDITION = _COVERAGE_CONDITION
OPTIMIZATION_MODE_CONDITION = _OPTIMIZATION_MODE_CONDITION
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
BAZEL_CPP_TOOLCHAIN_TYPE = _BAZEL_CPP_TOOLCHAIN_TYPE
BAZEL_CURRENT_CPP_TOOLCHAIN = _BAZEL_CURRENT_CPP_TOOLCHAIN
MACOS_CONSTRAINT = _MACOS_CONSTRAINT
WINDOWS_CONSTRAINT = _WINDOWS_CONSTRAINT
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
NATIVE_IMAGE_LAYER_ATTRS = _NATIVE_IMAGE_LAYER_ATTRS
prepare_native_image_rule_context = _prepare_native_image_rule_context
