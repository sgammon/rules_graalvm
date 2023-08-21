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
def native_image(name, **kwargs):
    """Macros which creates a native image via the legacy rules."""
    _native_image(
        name = name,
        default_executable_name = select({
            "@bazel_tools//src/conditions:windows": "%target%-bin.exe",
            "//conditions:default": "%target%-bin",
        }),
        **kwargs
    )
