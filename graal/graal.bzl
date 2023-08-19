"Rules for building native binaries using the GraalVM `native-image` tool on Bazel 5 and older."

load(
    "//internal/native_image:rules.bzl",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _graal_binary_implementation = "graal_binary_implementation",
)

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = {
        "deps": attr.label_list(providers = [[JavaInfo]]),
        "reflection_configuration": attr.label(mandatory = False, allow_single_file = True),
        "jni_configuration": attr.label(mandatory = False, allow_single_file = True),
        "main_class": attr.string(),
        "include_resources": attr.string(),
        "initialize_at_build_time": attr.string_list(),
        "initialize_at_run_time": attr.string_list(),
        "native_features": attr.string_list(),
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
        "check_toolchains": attr.bool(default = False),
        "data": attr.label_list(allow_files = True),
        "extra_args": attr.string_list(),
        "c_compiler_option": attr.string_list(),
    },
    executable = True,
    fragments = [
        "cpp",
    ],
    toolchains = [
        _BAZEL_CPP_TOOLCHAIN_TYPE,
    ],
)

## Exports.
native_image = _native_image
