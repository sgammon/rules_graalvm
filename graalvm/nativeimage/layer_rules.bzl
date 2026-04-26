"Public rule for building GraalVM Native Image layers (.nil)."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "//internal/native_image:common.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _DEBUG = "DEBUG_CONDITION",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_LAYER_ATTRS = "NATIVE_IMAGE_LAYER_ATTRS",
    _OPTIMIZATION_MODE = "OPTIMIZATION_MODE_CONDITION",
)
load(
    "//internal/native_image:layer_builder.bzl",
    _validate_directive_prefixes = "validate_directive_prefixes",
)
load(
    "//internal/native_image:layer_rules.bzl",
    _graal_layer_implementation = "graal_layer_implementation",
)
load(
    "//internal/native_image:settings.bzl",
    "NativeImageInfo",
)

_DEFAULT_NATIVE_IMAGE_SETTINGS = Label("@rules_graalvm//internal/native_image:defaults")

_DEFAULT_CHECK_TOOLCHAINS_CONDITION = select({
    "@bazel_tools//src/conditions:windows": True,
    "//conditions:default": False,
})

_native_image_layer = rule(
    implementation = _graal_layer_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_LAYER_ATTRS, **{
        "native_image_tool": attr.label(
            cfg = "exec",
            allow_files = True,
            executable = True,
            mandatory = False,
        ),
        "native_image_settings": attr.label_list(
            providers = [[NativeImageInfo]],
            mandatory = False,
            default = [_DEFAULT_NATIVE_IMAGE_SETTINGS],
        ),
    }),
    fragments = [
        "apple",
        "cpp",
        "java",
        "platform",
        "xcode",
    ],
    toolchains = [
        _BAZEL_CPP_TOOLCHAIN_TYPE,
        _GVM_TOOLCHAIN_TYPE,
    ],
)

def _validate_layers(layers, target_name):
    if len(layers) > 1:
        fail(
            "`layers` accepts at most 1 parent layer today; got %d on '%s': %s" % (
                len(layers),
                target_name,
                layers,
            ),
        )

def native_image_layer(
        name,
        deps,
        layers = [],
        directives = [],
        include_resources = None,
        reflection_configuration = None,
        jni_configuration = None,
        initialize_at_build_time = [],
        initialize_at_run_time = [],
        native_features = [],
        debug = _DEBUG,
        optimization_mode = _OPTIMIZATION_MODE,
        static_zlib = None,
        c_compiler_option = [],
        native_linker_option = [],
        cc_deps = [],
        cc_deps_dynamic = [],
        data = [],
        extra_args = [],
        allow_fallback = False,
        check_toolchains = _DEFAULT_CHECK_TOOLCHAINS_CONDITION,
        native_image_tool = None,
        native_image_settings = [_DEFAULT_NATIVE_IMAGE_SETTINGS],
        resource_configuration = None,
        proxy_configuration = None,
        **kwargs):
    """Builds a GraalVM Native Image layer (`.nil`) for composition with `native_image`.

    A layer is a pre-compiled, shareable unit of native code + image-heap metadata that
    downstream `native_image` (application) and `native_image_layer` (intermediate / mid) targets
    can consume via their `layers` attribute. This enables splitting large applications across
    reusable layers so shared code is built once and reused.

    Args:
        name: Target name; the layer is emitted as a single-file archive at `<name>.nil`.
        deps: `java_library` targets whose classpath content is eligible for inclusion in the
            layer. Matches the semantics of `native_image.deps`.
        layers: Parent layer(s) to extend via `--layer-use`. Today accepts at most 1 entry.
        directives: Content filters appended to `--layer-create=<path>,...`. Each entry must
            start with `package=`, `module=`, or `path=`. `path=` values are validated at
            analysis time against the effective classpath. `module=` and `package=` values are
            passed through verbatim — native-image will reject invalid ones.
        include_resources: Glob passed to `-H:IncludeResources`. Optional.
        reflection_configuration: Reflection configuration file. Optional.
        jni_configuration: JNI configuration file. Optional.
        initialize_at_build_time: Classes / patterns for `--initialize-at-build-time`. Merged
            with parent-propagated values when consuming a layer.
        initialize_at_run_time: Classes / patterns for `--initialize-at-run-time`. Merged same
            way.
        native_features: `Feature` classes to include via `-H:Features`. Merged same way.
        debug: Whether to include debug symbols; normally managed by Bazel's `--compilation_mode`.
        optimization_mode: Matches Bazel's build setting; normally managed by
            `--compilation_mode`.
        static_zlib: `cc_library` / `cc_import` target providing a static zlib (Linux only).
        c_compiler_option: Extra C compiler options.
        native_linker_option: Extra linker options forwarded as `-H:NativeLinkerOption=<value>`. Each entry produces one flag.
        cc_deps: `cc_library` / `cc_import` targets whose static archives should be linked into the layer. Use this to satisfy `@CFunction` / JNI references defined in companion Rust / C / C++ libraries — typical case: `rust_static_library` outputs whose Rust functions back the layer's Java-side `@CFunction` declarations.
        cc_deps_dynamic: `cc_library` / `cc_import` targets whose dynamic libraries should be linked at the layer's link time and resolved at runtime. Staged into `<name>.runtime_libs/` adjacent to the layer's `.so`, with RPATH embedded on Linux/macOS so the layer loads them without environment setup. Also propagated through `transitive_shared_libs` so the final consumer's `runtime_libs/` directory is a single co-located drop containing every transitively required `.so`. Use this for dynamic-image layer variants where the produced layer dynamically loads its companion libraries instead of statically linking them.
        data: Data files available during compilation.
        extra_args: Extra `native-image` arguments, appended last. Parent-propagated extra_args
            are prepended; this rule's values come after for last-wins semantics.
        allow_fallback: Whether to allow fallback to a partial image. Defaults to False.
        check_toolchains: Perform toolchain checks in native-image; True on Windows by default.
        native_image_tool: Specific `native-image` executable target.
        native_image_settings: Suite(s) of Native Image build settings.
        resource_configuration: Resource configuration file. Optional.
        proxy_configuration: Proxy configuration file. Optional.
        **kwargs: Forwarded to the underlying rule.

    Attributes NOT available on `native_image_layer` (by design — layers are not executables):
        `main_class`, `shared_library`, `executable_name`, `profiles`.
    """
    _validate_layers(layers, name)
    _validate_directive_prefixes(directives)

    _native_image_layer(
        name = name,
        deps = deps,
        layers = layers,
        directives = directives,
        include_resources = include_resources,
        reflection_configuration = reflection_configuration,
        jni_configuration = jni_configuration,
        initialize_at_build_time = initialize_at_build_time,
        initialize_at_run_time = initialize_at_run_time,
        native_features = native_features,
        debug = debug,
        optimization_mode = optimization_mode,
        data = data,
        extra_args = extra_args,
        check_toolchains = check_toolchains,
        static_zlib = static_zlib,
        c_compiler_option = c_compiler_option,
        native_linker_option = native_linker_option,
        cc_deps = cc_deps,
        cc_deps_dynamic = cc_deps_dynamic,
        allow_fallback = allow_fallback,
        native_image_tool = native_image_tool,
        native_image_settings = native_image_settings,
        resource_configuration = resource_configuration,
        proxy_configuration = proxy_configuration,
        **kwargs
    )
