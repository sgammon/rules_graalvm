"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "//internal/native_image:rules.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _DEBUG = "DEBUG_CONDITION",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _OPTIMIZATION_MODE = "OPTIMIZATION_MODE_CONDITION",
    _graal_binary_implementation = "graal_binary_implementation",
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

_EXEUCTABLE_NAME_CONDITION = select({
    "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
    "//conditions:default": "%target%-bin",
})

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_ATTRS, **{
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
    executable = True,
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

# Exports.
def native_image(
        name,
        deps,
        main_class = None,
        executable_name = _EXEUCTABLE_NAME_CONDITION,
        include_resources = None,
        reflection_configuration = None,
        jni_configuration = None,
        initialize_at_build_time = [],
        initialize_at_run_time = [],
        native_features = [],
        debug = _DEBUG,
        optimization_mode = _OPTIMIZATION_MODE,
        shared_library = None,
        static_zlib = None,
        c_compiler_option = [],
        native_linker_option = [],
        cc_deps = [],
        cc_deps_dynamic = [],
        extra_headers = [],
        data = [],
        extra_args = [],
        allow_fallback = False,
        check_toolchains = _DEFAULT_CHECK_TOOLCHAINS_CONDITION,
        native_image_tool = None,  # uses toolchains by default
        native_image_settings = [_DEFAULT_NATIVE_IMAGE_SETTINGS],
        resource_configuration = None,
        proxy_configuration = None,
        profiles = [],
        layers = [],
        emit_intermediate_dir = False,
        emit_obfuscation_mapping = False,
        **kwargs):
    """Generates and compiles a GraalVM native image from a Java library target.

    Args:
        name: Name of the target; required.
        deps: Dependency `java_library` targets to assemble the classpath from. Mandatory.
        main_class: Entrypoint main class to build from; mandatory unless building a shared library.
        executable_name: Set the name of the output binary; defaults to `%target%-bin`, or `%target%-bin.exe` on Windows.
            The special string `%target%`, if present, is replaced with `name`.
        include_resources: Glob to pass to `IncludeResources`. No default; optional.
        reflection_configuration: Reflection configuration file. No default; optional.
        jni_configuration: JNI configuration file. No default; optional.
        initialize_at_build_time: Classes or patterns to pass to `--initialize-at-build-time`. No default; optional.
        initialize_at_run_time: Classes or patterns to pass to `--initialize-at-run-time`. No default; optional.
        native_features: GraalVM `Feature` classes to include and apply. No default; optional.
        debug: Whether to include debug symbols; by default, this flag's state is managed by Bazel. Passing
            `--compilation_mode=dbg` is sufficient to flip this to `True`, or it can be overridden via this parameter.
        optimization_mode: Behaves the same as `debug`; normally, this flag's state is managed by Bazel. Passing
            `--compilation_mode=fastbuild|opt|dbg` is sufficient to set this flag, or it can be overridden via this
            parameter.
        shared_library: Build a shared library binary instead of an executable.
        static_zlib: A cc_library or cc_import target that provides zlib as a static library.
            On Linux, this is used when Graal statically links zlib into the binary, e.g. with
            `-H:+StaticExecutableWithDynamicLibC`.
        c_compiler_option: Extra C compiler options to pass through `native-image`. No default; optional.
        native_linker_option: Extra linker options forwarded as `-H:NativeLinkerOption=<value>`. Each entry produces one flag; use for `-Wl,...` directives or explicit `-l<name>`. No default; optional.
        cc_deps: `cc_library` / `cc_import` targets whose static archives should be linked into the produced image. The rule extracts each archive (preferring PIC), stages it as an action input, and emits a matching `-H:NativeLinkerOption=<archive>` flag. Use this to satisfy `@CFunction` / JNI references defined in companion Rust / C / C++ libraries. No default; optional.
        cc_deps_dynamic: `cc_library` / `cc_import` targets whose dynamic libraries (`.so` / `.dylib` / `.dll`) should be linked into the produced binary at native-image link time and resolved at runtime. Each dep's dynamic library is staged adjacent to the binary under `<target>.runtime_libs/`, and on Linux/macOS an RPATH (`$ORIGIN` / `@loader_path`) is embedded so the loader finds it without environment setup. Use this for dynamic-image variants where the consumer expects a runtime-loaded shared library, not a statically linked archive. No default; optional.
        extra_headers: Additional header filenames Native Image is expected to emit alongside
            the shared library. Only valid when `shared_library = True`. Each entry is a basename
            and is declared as an output of the native-image action; the rule surfaces it via
            `CcInfo.compilation_context.headers`. No default; optional.
        data: Data files to make available during the compilation. No default; optional.
        extra_args: Extra `native-image` args to pass. Last wins. No default; optional.
        allow_fallback: Whether to allow fall-back to a partial native image; defaults to `False`.
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        native_image_tool: Specific `native-image` executable target to use.
        native_image_settings: Suite(s) of Native Image build settings to use.
        profiles: Profiles to use for profile-guided optimization (PGO) and obtained from a native image compiled with `--pgo-instrument`.
        resource_configuration: Resource configuration file. No default; optional.
        proxy_configuration: Proxy configuration file. No default; optional.
        layers: Parent GraalVM Native Image layer(s) to consume via `--layer-use`. Today accepts at most 1 entry. Entries must be `native_image_layer` targets.
        emit_intermediate_dir: If True, preserve native-image's intermediate build directory as a TreeArtifact output (exposed via `OutputGroupInfo(intermediate_dir=...)`) and pass `-H:TempDirectory=<path>` to direct native-image to use it. Enables downstream rules (e.g., staticlib repackers) to consume the intermediate `<image>.o` file.
        emit_obfuscation_mapping: If True, declare `<image-name>.obfuscation-mapping.json` (the obfuscation symbol map native-image writes next to the binary when `-H:AdvancedObfuscation=export-mapping` is set) as an output, exposed via `OutputGroupInfo(obfuscation_mapping=...)`. Not added to `DefaultInfo.files` (the map can be tens of MiB). Opt-in: the caller must also pass `-H:AdvancedObfuscation=export-mapping` in `extra_args` in tandem, or the declared output is never written and the build fails.
        **kwargs: Extra keyword arguments are passed to the underlying `native_image` rule.
    """

    _validate_layers(layers, name)

    if extra_headers and not shared_library:
        fail(
            ("`extra_headers` is only valid when `shared_library = True` " +
             "(target '%s' has shared_library=%s and extra_headers=%s). " +
             "Set `shared_library = True` or remove `extra_headers`.") % (
                name,
                shared_library,
                extra_headers,
            ),
        )

    _native_image(
        name = name,
        deps = deps,
        main_class = main_class,
        include_resources = include_resources,
        reflection_configuration = reflection_configuration,
        jni_configuration = jni_configuration,
        initialize_at_build_time = initialize_at_build_time,
        initialize_at_run_time = initialize_at_run_time,
        native_features = native_features,
        debug = debug,
        optimization_mode = optimization_mode,
        shared_library = shared_library,
        data = data,
        extra_args = extra_args,
        check_toolchains = check_toolchains,
        static_zlib = static_zlib,
        c_compiler_option = c_compiler_option,
        native_linker_option = native_linker_option,
        cc_deps = cc_deps,
        cc_deps_dynamic = cc_deps_dynamic,
        extra_headers = extra_headers,
        allow_fallback = allow_fallback,
        executable_name = executable_name,
        native_image_tool = native_image_tool,
        native_image_settings = native_image_settings,
        profiles = profiles,
        resource_configuration = resource_configuration,
        proxy_configuration = proxy_configuration,
        layers = layers,
        emit_intermediate_dir = emit_intermediate_dir,
        emit_obfuscation_mapping = emit_obfuscation_mapping,
        **kwargs
    )
