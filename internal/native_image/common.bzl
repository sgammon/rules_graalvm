"Defines common properties shared by modern and legacy Native Image rules."

load(
    "//internal/native_image:builder.bzl",
    _assemble_native_build_options = "assemble_native_build_options",
)
load(
    "//internal/native_image/options:arch.bzl",
    "NativeImageArchInfo",
)

_RULES_REPO = "@rules_graalvm"
_DEFAULT_GVM_REPO = "@graalvm"
_GVM_TOOLCHAIN_TYPE = "%s//graalvm/toolchain" % _RULES_REPO
_BAZEL_CPP_TOOLCHAIN_TYPE = "@bazel_tools//tools/cpp:toolchain_type"
_BAZEL_CURRENT_CPP_TOOLCHAIN = "@bazel_tools//tools/cpp:current_cc_toolchain"
_LINUX_CONSTRAINT = "@platforms//os:linux"
_MACOS_CONSTRAINT = "@platforms//os:macos"
_WINDOWS_CONSTRAINT = "@platforms//os:windows"
_SETTING_TARGET_ARCH = "%s//graalvm/nativeimage/options:arch" % _RULES_REPO

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
        providers = [[JavaInfo]],
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
        providers = [[CcInfo]],
    ),
    "data": attr.label_list(
        allow_files = True,
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
    "executable_name": attr.string(
        mandatory = True,
    ),
    "native_arch": attr.label(
        default = Label(_SETTING_TARGET_ARCH),
        providers = [[NativeImageArchInfo]],
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

def _prepare_native_image_rule_context(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        c_compiler_path,
        gvm_toolchain = None):
    """Prepare a `native-image` build context."""

    out_bin_name = ctx.attr.executable_name.replace("%target%", ctx.attr.name)
    binary = ctx.actions.declare_file(out_bin_name)

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
prepare_native_image_rule_context = _prepare_native_image_rule_context
