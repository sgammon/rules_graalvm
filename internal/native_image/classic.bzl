"Legacy ('classic') rules for building with GraalVM on Bazel."

load(
    "//internal/native_image:builder.bzl",
    _assemble_native_build_options = "assemble_native_build_options",
)
load(
    "//internal/native_image:common.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _DEBUG_CONDITION = "DEBUG_CONDITION",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _OPTIMIZATION_MODE_CONDITION = "OPTIMIZATION_MODE_CONDITION",
    _RULES_REPO = "RULES_REPO",
    _path_list_separator = "path_list_separator",
)
load(
    "//internal/native_image:toolchain.bzl",
    _resolve_cc_toolchain = "resolve_cc_toolchain",
)

def _graal_binary_classic_implementation(ctx):
    graal_attr = ctx.attr.native_image_tool
    classpath_depset = depset(transitive = [
        dep[JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
    ])

    direct_inputs = []
    transitive_inputs = [classpath_depset]

    if graal_attr != None:
        # otherwise, use the legacy code path. the `graal` value is used in the run
        # `executable` so it isn't listed in deps for earlier Bazel versions.
        graal_inputs, _, _ = ctx.resolve_command(tools = [
            graal_attr,
        ])
        graal = graal_inputs[0]
        direct_inputs.append(graal)
    else:
        # still failed to resolve: cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    # resolve the native toolchain
    native_toolchain = _resolve_cc_toolchain(
        ctx,
        transitive_inputs,
        is_windows = ctx.configuration.host_path_separator == ";",
    )

    args = ctx.actions.args()

    binary_name = ctx.attr.executable_name.replace("%target%", ctx.attr.name)
    binary = ctx.actions.declare_file("output/" + binary_name)
    path_list_separator = _path_list_separator(ctx)

    _assemble_native_build_options(
        ctx,
        args,
        binary_name,
        binary.dirname,
        classpath_depset,
        direct_inputs,
        native_toolchain.c_compiler_path,
        path_list_separator,
    )

    if ctx.files.data:
        direct_inputs.extend(ctx.files.data)

    inputs = depset(
        direct_inputs,
        transitive = transitive_inputs,
    )

    ctx.actions.run(
        outputs = [binary],
        arguments = [args],
        executable = graal,
        inputs = inputs,
        mnemonic = "NativeImage",
        env = native_toolchain.env,
    )

    return [DefaultInfo(
        executable = binary,
        files = depset([binary]),
        runfiles = ctx.runfiles(
            collect_data = True,
            collect_default = True,
            files = [],
        ),
    )]

# Exports.
RULES_REPO = _RULES_REPO
DEFAULT_GVM_REPO = _DEFAULT_GVM_REPO
BAZEL_CURRENT_CPP_TOOLCHAIN = _BAZEL_CURRENT_CPP_TOOLCHAIN
BAZEL_CPP_TOOLCHAIN_TYPE = _BAZEL_CPP_TOOLCHAIN_TYPE
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
DEBUG_CONDITION = _DEBUG_CONDITION
OPTIMIZATION_MODE_CONDITION = _OPTIMIZATION_MODE_CONDITION
graal_binary_implementation = _graal_binary_classic_implementation
