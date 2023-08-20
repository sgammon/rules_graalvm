"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@bazel_skylib//lib:dicts.bzl",
    "dicts",
)
load(
    "//internal/native_image:rules.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
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
        config_common.toolchain_type(
            _BAZEL_CPP_TOOLCHAIN_TYPE,
            mandatory = True,
        ),
        config_common.toolchain_type(
            _GVM_TOOLCHAIN_TYPE,
            mandatory = False,
        ),
    ],
)

## Exports.
native_image = _native_image
