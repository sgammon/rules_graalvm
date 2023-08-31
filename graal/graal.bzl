"Rules for building native binaries using the GraalVM `native-image` tool on Bazel 5 and older."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "//internal/native_image:rules.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _graal_binary_implementation = "graal_binary_implementation",
)

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_ATTRS, **{
        "native_image_tool": attr.label(
            cfg = "exec",
            default = Label("%s//:native-image" % _DEFAULT_GVM_REPO),
            allow_files = True,
            executable = True,
            mandatory = False,
        ),
        "_cc_toolchain": attr.label(
            default = Label(_BAZEL_CURRENT_CPP_TOOLCHAIN),
        ),
        "_legacy_rule": attr.bool(
            default = True,
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
        main_class,
        include_resources = None,
        reflection_configuration = None,
        jni_configuration = None,
        initialize_at_build_time = [],
        initialize_at_run_time = [],
        native_features = [],
        data = [],
        extra_args = [],
        check_toolchains = select({
            "@bazel_tools//src/conditions:windows": True,
            "//conditions:default": False,
        }),
        c_compiler_option = [],
        default_executable_name = select({
            "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
            "//conditions:default": "%target%-bin",
        }),
        **kwargs):
    """Generates and compiles a GraalVM native image from a Java library target.

    Args:
        name: Name of the target; required.
        deps: Dependency `java_library` targets to assemble the classpath from. Mandatory.
        main_class: Entrypoint main class to build from; mandatory.
        include_resources: Glob to pass to `IncludeResources`. No default; optional.
        reflection_configuration: Reflection configuration file. No default; optional.
        jni_configuration: JNI configuration file. No default; optional.
        initialize_at_build_time: Classes or patterns to pass to `--initialize-at-build-time`. No default; optional.
        initialize_at_run_time: Classes or patterns to pass to `--initialize-at-run-time`. No default; optional.
        native_features: GraalVM `Feature` classes to include and apply. No default; optional.
        data: Data files to make available during the compilation. No default; optional.
        extra_args: Extra `native-image` args to pass. Last wins. No default; optional.
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        c_compiler_option: Extra C compiler options to pass through `native-image`. No default; optional.
        default_executable_name: Set the name of the output binary; defaults to `%target%-bin`, or `%target%-bin.exe` on Windows.
            The special string `%target%`, if present, is replaced with `name`.
        static_zlib: A cc_library or cc_import target that provides zlib as a static library.
            On Linux, this is used when Graal statically links zlib into the binary, e.g. with
            `-H:+StaticExecutableWithDynamicLibC`.
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
        data = data,
        extra_args = extra_args,
        check_toolchains = check_toolchains,
        c_compiler_option = c_compiler_option,
        default_executable_name = default_executable_name,
        pass_compiler_path = select({
            "@bazel_tools//src/conditions:windows": False,
            "//conditions:default": True,
        }),
        **kwargs
    )

def graal_binary(
        name,
        deps,
        main_class,
        include_resources = None,
        reflection_configuration = None,
        jni_configuration = None,
        initialize_at_build_time = [],
        initialize_at_run_time = [],
        native_features = [],
        data = [],
        extra_args = [],
        check_toolchains = select({
            "@bazel_tools//src/conditions:windows": True,
            "//conditions:default": False,
        }),
        c_compiler_option = [],
        default_executable_name = select({
            "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
            "//conditions:default": "%target%-bin",
        }),
        **kwargs):
    """Alias for the renamed `native_image` rule. Identical.

    Args:
        name: Name of the target; required.
        deps: Dependency `java_library` targets to assemble the classpath from. Mandatory.
        main_class: Entrypoint main class to build from; mandatory.
        include_resources: Glob to pass to `IncludeResources`. No default; optional.
        reflection_configuration: Reflection configuration file. No default; optional.
        jni_configuration: JNI configuration file. No default; optional.
        initialize_at_build_time: Classes or patterns to pass to `--initialize-at-build-time`. No default; optional.
        initialize_at_run_time: Classes or patterns to pass to `--initialize-at-run-time`. No default; optional.
        native_features: GraalVM `Feature` classes to include and apply. No default; optional.
        data: Data files to make available during the compilation. No default; optional.
        extra_args: Extra `native-image` args to pass. Last wins. No default; optional.
        check_toolchains: Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.
        c_compiler_option: Extra C compiler options to pass through `native-image`. No default; optional.
        default_executable_name: Set the name of the output binary; defaults to `%target%-bin`, or `%target%-bin.exe` on Windows.
            The special string `%target%`, if present, is replaced with `name`.
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
        data = data,
        extra_args = extra_args,
        check_toolchains = check_toolchains,
        c_compiler_option = c_compiler_option,
        default_executable_name = default_executable_name,
        **kwargs
    )
