"Second-stage setup code for the GraalVM Rules project."

load(
    "//internal:config.bzl",
    "PYTHON_VERSION",
    FOREIGN_TOOLCHAINS = "ENABLE_FOREIGN_TOOLCHAINS",
)
load(
    "@rules_jvm_external//:setup.bzl",
    "rules_jvm_external_setup",
)
load(
    "@maven_gvm//:defs.bzl",
    "pinned_maven_install",
)
load(
    "@contrib_rules_jvm//:setup.bzl",
    "contrib_rules_jvm_setup",
)
load(
    "@bazel_skylib_gazelle_plugin//:setup.bzl",
    "bazel_skylib_gazelle_plugin_setup",
)
load(
    "@buildifier_prebuilt//:defs.bzl",
    "buildifier_prebuilt_register_toolchains",
)
load(
    "@llvm//:toolchains.bzl",
    "llvm_register_toolchains",
)
load(
    "@rules_python//python:repositories.bzl",
    "python_register_toolchains",
)

def _rules_graalvm_toolchains(
    repository = "@graalvm",
    enable_zig = FOREIGN_TOOLCHAINS,
    enable_llvm = FOREIGN_TOOLCHAINS):
    """Register toolchains for use in the GraalVM Rules codebase."""

    native.register_toolchains(
        "%s//:toolchain" % repository,
    )
    if enable_llvm:
        llvm_register_toolchains()

    if enable_zig:
        native.register_toolchains(
            "@zig_sdk//toolchain:linux_amd64_gnu.2.28",
            "@zig_sdk//toolchain:linux_arm64_gnu.2.28",
            "@zig_sdk//toolchain:darwin_amd64",
            "@zig_sdk//toolchain:darwin_arm64",
            "@zig_sdk//toolchain:windows_amd64",
            "@zig_sdk//toolchain:windows_arm64",
        )

def _rules_graalvm_setup_workspace(gazelle = True, maven = False, python = True):
    """Perform second-stage setup of the GraalVM Rules codebase."""

    # Rules JVM External

    rules_jvm_external_setup()

    # Contrib Rules JVM

    contrib_rules_jvm_setup()

    # Buildifier

    buildifier_prebuilt_register_toolchains()

    # Python

    if python:
        python_register_toolchains(
            name = "python",
            python_version = PYTHON_VERSION,
        )

    if gazelle:
        # Bazel Skylib: Gazelle Plugin
        bazel_skylib_gazelle_plugin_setup(register_go_toolchains = False)

    if maven:
        # Maven: Pinned
        pinned_maven_install()

rules_graalvm_toolchains = _rules_graalvm_toolchains
rules_graalvm_workspace = _rules_graalvm_setup_workspace
