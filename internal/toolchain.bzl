"Defines toolchain registration functions for use in downstream Bazel projects."

_TARGET_JAVA_TOOLCHAIN = ":toolchain"
_TARGET_GVM_TOOLCHAIN = ":toolchain_graalvm"

GraalVMToolchainInfo = provider(
    doc = "Information about the GraalVM runtime and compiler.",
    fields = [
        "version",
        "native_image_bin_path",
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
            version = ctx.attr.version,
        ),
    )
    return [toolchain_info]

def _gvm_engine_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm = GraalVMEngineInfo(
            language = ctx.attr.language,
            launcher = ctx.attr.launcher,
        ),
    )
    return [toolchain_info]

graalvm_toolchain = rule(
    implementation = _gvm_toolchain_impl,
    attrs = {
        "version": attr.string(
            mandatory = True,
        ),
        "native_image_bin_path": attr.string(
            mandatory = False,
        ),
    },
)

graalvm_engine_toolchain = rule(
    implementation = _gvm_engine_toolchain_impl,
    attrs = {
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
        repository = "@graalvm",
        register_java_toolchain = True,
        register_gvm_toolchain = False):
    """Register GraalVM toolchains for Native Image and installed language components."""

    if register_java_toolchain:
        native.register_toolchains(repo_target(repository, _TARGET_JAVA_TOOLCHAIN))
    if register_gvm_toolchain:
        native.register_toolchains(repo_target(repository, _TARGET_GVM_TOOLCHAIN))
