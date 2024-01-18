"Rules for building native binaries using the GraalVM `native-image` tool on Bazel 5 and older."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "//internal/native_image:classic.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _DEBUG = "DEBUG_CONDITION",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _OPTIMIZATION_MODE = "OPTIMIZATION_MODE_CONDITION",
    _graal_binary_implementation = "graal_binary_implementation",
)

_DEFAULT_NATIVE_IMAGE_TOOL = Label("%s//:native-image" % _DEFAULT_GVM_REPO)

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_ATTRS, **{
        "native_image_tool": attr.label(
            cfg = "exec",
            default = _DEFAULT_NATIVE_IMAGE_TOOL,
            allow_files = True,
            executable = True,
            mandatory = False,
        ),
        "_cc_toolchain": attr.label(
            default = Label(_BAZEL_CURRENT_CPP_TOOLCHAIN),
        ),
    }),
    executable = True,
    fragments = [
        "cpp",
    ],
    toolchains = [
        _BAZEL_CPP_TOOLCHAIN_TYPE,
    ],
)

## Exports.
def native_image(
        name,
        deps,
        main_class = None,
        executable_name = select({
            "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
            "//conditions:default": "%target%-bin",
        }),
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
        check_toolchains = select({
            "@bazel_tools//src/conditions:windows": True,
            "//conditions:default": False,
        }),
        native_image_tool = _DEFAULT_NATIVE_IMAGE_TOOL,
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
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        native_image_tool: Specific `native-image` executable target to use.
        **kwargs: Extra keyword arguments are passed to the underlying `native_image` rule.
    """

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
        **kwargs
    )

def graal_binary(
        name,
        deps,
        main_class = None,
        executable_name = select({
            "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
            "//conditions:default": "%target%-bin",
        }),
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
        check_toolchains = select({
            "@bazel_tools//src/conditions:windows": True,
            "//conditions:default": False,
        }),
        native_image_tool = _DEFAULT_NATIVE_IMAGE_TOOL,
        **kwargs):
    """Alias for the renamed `native_image` rule. Identical.

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
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        native_image_tool: Specific `native-image` executable target to use.
        **kwargs: Extra keyword arguments are passed to the underlying `native_image` rule.
    """

    native_image(
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
        static_zlib = static_zlib,
        check_toolchains = check_toolchains,
        c_compiler_option = c_compiler_option,
        executable_name = executable_name,
        native_image_tool = native_image_tool,
        allow_fallback = allow_fallback,
        **kwargs
    )
