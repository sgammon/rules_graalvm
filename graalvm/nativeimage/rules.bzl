"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "//internal/native_image:rules.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _graal_binary_implementation = "graal_binary_implementation",
)
load(
    "//internal/native_image:settings.bzl",
    "NativeImageInfo",
)

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = dicts.add(_NATIVE_IMAGE_ATTRS, **{
        "native_image_tool": attr.label(
            cfg = "exec",
            allow_files = True,
            executable = True,
            mandatory = False,
        ),
        "_legacy_rule": attr.bool(
            default = False,
        ),
        "native_image_settings": attr.label_list(
            providers = [[NativeImageInfo]],
            mandatory = False,
            default = [Label("@rules_graalvm//internal/native_image:defaults")],
        ),
    }),
    executable = True,
    fragments = [
        "cpp",
        "java",
        "platform",
    ],
    toolchains = [
        _BAZEL_CPP_TOOLCHAIN_TYPE,
        _GVM_TOOLCHAIN_TYPE,
    ],
)

## Exports.
def native_image(name, **kwargs):
    """Macro which defines a GraalVM Native Image target."""
    _native_image(
        name = name,
        default_executable_name = select({
            "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
            "//conditions:default": "%target%-bin",
        }),
        enable_default_shell_env = select({
            "@bazel_tools//src/conditions:windows": True,
            "//conditions:default": True,
        }),
        check_toolchains = select({
            "@bazel_tools//src/conditions:windows": True,
            "//conditions:default": False,
        }),
        pass_compiler_path = select({
            "@bazel_tools//src/conditions:windows": False,
            "//conditions:default": True,
        }),
        **kwargs
    )
