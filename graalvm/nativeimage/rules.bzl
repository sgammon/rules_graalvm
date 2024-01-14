"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "@bazel_tools//tools/cpp:toolchain_utils.bzl",
    "use_cpp_toolchain",
)
load(
    "//internal/native_image:rules.bzl",
    _DEBUG = "DEBUG_CONDITION",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _NATIVE_IMAGE_SHARED_LIB_ATTRS = "NATIVE_IMAGE_SHARED_LIB_ATTRS",
    _OUTPUT_GROUPS = "OUTPUT_GROUPS",
    _OPTIMIZATION_MODE = "OPTIMIZATION_MODE_CONDITION",
    _graal_binary_implementation = "graal_binary_implementation",
    _graal_shared_binary_implementation = "graal_shared_binary_implementation",
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

_SHARED_LIB_NAME_CONDITION = select({
    "//conditions:default": "%target%",
})

_modern_rule_attrs = {
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
}

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_ATTRS, **_modern_rule_attrs),
    executable = True,
    fragments = [
        "apple",
        "cpp",
        "java",
        "platform",
        "xcode",
    ],
    toolchains = use_cpp_toolchain() + [
        _GVM_TOOLCHAIN_TYPE,
    ],
)

_native_image_shared_library = rule(
    implementation = _graal_shared_binary_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_SHARED_LIB_ATTRS, **_modern_rule_attrs),
    executable = True,
    fragments = [
        "apple",
        "cpp",
        "java",
        "platform",
        "xcode",
    ],
    toolchains = use_cpp_toolchain() + [
        _GVM_TOOLCHAIN_TYPE,
    ],
)

_NATIVE_IMAGE_UTILS = struct(
    output_groups = _OUTPUT_GROUPS,
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
        data = [],
        extra_args = [],
        allow_fallback = False,
        check_toolchains = _DEFAULT_CHECK_TOOLCHAINS_CONDITION,
        native_image_tool = None,  # uses toolchains by default
        native_image_settings = [_DEFAULT_NATIVE_IMAGE_SETTINGS],
        profiles = [],
        additional_outputs = [],
        default_outputs = True,
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
        data: Data files to make available during the compilation. No default; optional.
        extra_args: Extra `native-image` args to pass. Last wins. No default; optional.
        allow_fallback: Whether to allow fall-back to a partial native image; defaults to `False`.
        additional_outputs: Additional outputs to expect from the rule (for example, polyglot language resources).
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        native_image_tool: Specific `native-image` executable target to use.
        native_image_settings: Suite(s) of Native Image build settings to use.
        profiles: Profiles to use for profile-guided optimization (PGO) and obtained from a native image compiled with `--pgo-instrument`.
        default_outputs: Whether to consider default output files; when `False`, the developer specifies all outputs on top of the
            binary itself.
        **kwargs: Extra keyword arguments are passed to the underlying `native_image` rule.
    """

    if shared_library:
        # buildifier: disable=print
        print("GraalVM rules for Bazel at >0.11.x uses `native_image_shared_library`. Please migrate at your convenience.")

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
        allow_fallback = allow_fallback,
        executable_name = executable_name,
        native_image_tool = native_image_tool,
        native_image_settings = native_image_settings,
        profiles = profiles,
        additional_outputs = additional_outputs,
        default_outputs = default_outputs,
        **kwargs
    )

def native_image_shared_library(
        name,
        deps,
        executable_name = _SHARED_LIB_NAME_CONDITION,
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
        data = [],
        extra_args = [],
        allow_fallback = False,
        check_toolchains = _DEFAULT_CHECK_TOOLCHAINS_CONDITION,
        native_image_tool = None,  # uses toolchains by default
        native_image_settings = [_DEFAULT_NATIVE_IMAGE_SETTINGS],
        profiles = [],
        out_headers = [],
        additional_outputs = [],
        default_outputs = True,
        **kwargs):
    """Generates and compiles a GraalVM native image from a Java library target.

    Args:
        name: Name of the target; required.
        deps: Dependency `java_library` targets to assemble the classpath from. Mandatory.
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
        static_zlib: A cc_library or cc_import target that provides zlib as a static library.
            On Linux, this is used when Graal statically links zlib into the binary, e.g. with
            `-H:+StaticExecutableWithDynamicLibC`.
        c_compiler_option: Extra C compiler options to pass through `native-image`. No default; optional.
        data: Data files to make available during the compilation. No default; optional.
        extra_args: Extra `native-image` args to pass. Last wins. No default; optional.
        allow_fallback: Whether to allow fall-back to a partial native image; defaults to `False`.
        out_headers: Shared library headers expected to be emitted by the rule (in addition to defaults).
        additional_outputs: Additional outputs to expect from the rule (for example, polyglot language resources).
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        native_image_tool: Specific `native-image` executable target to use.
        native_image_settings: Suite(s) of Native Image build settings to use.
        profiles: Profiles to use for profile-guided optimization (PGO) and obtained from a native image compiled with `--pgo-instrument`.
        default_outputs: Whether to consider default output files; when `False`, the developer specifies all outputs on top of the
            binary itself.
        **kwargs: Extra keyword arguments are passed to the underlying `native_image` rule.
    """

    _native_image_shared_library(
        name = name,
        deps = deps,
        include_resources = include_resources,
        reflection_configuration = reflection_configuration,
        jni_configuration = jni_configuration,
        initialize_at_build_time = initialize_at_build_time,
        initialize_at_run_time = initialize_at_run_time,
        native_features = native_features,
        debug = debug,
        optimization_mode = optimization_mode,
        shared_library = True,
        data = data,
        extra_args = extra_args,
        check_toolchains = check_toolchains,
        static_zlib = static_zlib,
        c_compiler_option = c_compiler_option,
        allow_fallback = allow_fallback,
        executable_name = executable_name,
        native_image_tool = native_image_tool,
        native_image_settings = native_image_settings,
        profiles = profiles,
        out_headers = out_headers,
        additional_outputs = additional_outputs,
        default_outputs = default_outputs,
        **kwargs
    )

# Aliases.
utils = _NATIVE_IMAGE_UTILS
