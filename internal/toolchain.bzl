"Defines toolchain registration functions for use in downstream Bazel projects."

_TARGET_JAVA_TOOLCHAIN = ":toolchain"
_TARGET_GVM_TOOLCHAIN = ":toolchain_gvm"

GraalVMToolchainInfo = provider(
    doc = "Information about the GraalVM runtime and compiler.",
    fields = [
        "native_image_bin",
        "gvm_files",
    ],
)

GraalVMEngineInfo = provider(
    doc = "Information about an installed GraalVM component or engine.",
    fields = [
        "language",
        "launcher",
    ],
)

def _gvm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm = GraalVMToolchainInfo(
            native_image_bin = ctx.attr.native_image_bin,
            gvm_files = ctx.attr.gvm_files,
        ),
    )
    return [toolchain_info]

def _gvm_engine_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm = GraalVMEngineInfo(
            component = ctx.attr.component,
            language = ctx.attr.language,
            launcher = ctx.attr.launcher,
            parent_toolchain = ctx.inputs.parent_toolchain,
        ),
    )
    return [toolchain_info]

graalvm_sdk = rule(
    implementation = _gvm_toolchain_impl,
    attrs = {
        "native_image_bin": attr.label(
            mandatory = True,
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
        "gvm_files": attr.label(
            mandatory = True,
            allow_files = True,
            cfg = "exec",
        ),
    },
)

graalvm_engine = rule(
    implementation = _gvm_engine_toolchain_impl,
    attrs = {
        "parent_toolchain": attr.label(
            mandatory = True,
        ),
        "component": attr.string(
            mandatory = True,
        ),
        "language": attr.string(
            mandatory = False,
        ),
        "launcher": attr.label(
            mandatory = False,
            allow_files = True,
            executable = True,
            cfg = "target",
        ),
    },
)

def repo_target(repo, target):
    return "{}//{}".format(repo, target)

def register_graalvm_toolchains(
        name = "@graalvm",
        register_java_toolchain = True,
        register_gvm_toolchain = True):
    """Register GraalVM toolchains for Native Image and installed language components."""

    if register_java_toolchain:
        native.register_toolchains(repo_target(name, _TARGET_JAVA_TOOLCHAIN))
    if register_gvm_toolchain:
        native.register_toolchains(repo_target(name, _TARGET_GVM_TOOLCHAIN))
