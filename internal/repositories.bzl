"Local declarations for the GraalVM Rules project workspace."

load(
    "//internal:config.bzl",
    "GO_VERSION",
    "GRAALVM_COMPONENTS",
    "GRAALVM_DISTRIBUTION",
    "GRAALVM_JAVA_VERSION",
    "GRAALVM_SHA",
    "GRAALVM_VERSION",
    "MAVEN_ARTIFACTS",
    "MAVEN_REPOSITORIES",
    "LLVM_VERSION",
)
load(
    "@buildifier_prebuilt//:deps.bzl",
    "buildifier_prebuilt_deps",
)
load(
    "@bazel_skylib//:workspace.bzl",
    "bazel_skylib_workspace",
)
# load(
#     "@rules_cc//cc:repositories.bzl",
#     "rules_cc_dependencies",
#     "rules_cc_toolchains",
# )
load(
    "@rules_java//java:repositories.bzl",
    "rules_java_dependencies",
    "rules_java_toolchains",
)
load(
    "@rules_python//python:repositories.bzl",
    "py_repositories",
)
load(
    "@//graalvm:repositories.bzl",
    "graalvm_repository",
)
load(
    "@aspect_bazel_lib//lib:repositories.bzl",
    "aspect_bazel_lib_dependencies",
)
load(
    "@rules_jvm_external//:repositories.bzl",
    "rules_jvm_external_deps",
)
load(
    "@io_bazel_stardoc//:setup.bzl",
    "stardoc_repositories",
)
# load(
#     "@rules_jvm_external//:defs.bzl",
#     "maven_install",
# )
load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_register_toolchains",
    "go_rules_dependencies",
)
load(
    "@bazel_gazelle//:deps.bzl",
    "gazelle_dependencies",
)
load(
    "@googleapis//:repository_rules.bzl",
    "switched_rules_by_language",
)
load(
    "@contrib_rules_jvm//:repositories.bzl",
    "contrib_rules_jvm_deps",
)
load(
    "@apple_rules_lint//lint:repositories.bzl",
    "lint_deps",
)
load(
    "@apple_rules_lint//lint:setup.bzl",
    "lint_setup",
)
load(
    "@com_grail_bazel_toolchain//toolchain:deps.bzl",
    llvm_toolchains = "bazel_toolchain_dependencies",
)
load(
    "@hermetic_cc_toolchain//toolchain:defs.bzl",
    zig_toolchains = "toolchains",
)
load(
    "@com_grail_bazel_toolchain//toolchain:rules.bzl",
    "llvm_toolchain",
)

def _setup_rules_graalvm_repositories(maven = True, go_toolchains = True, linters = True):
    """Setup dependencies for the GraalVM Rules project."""

    # Apple Linting Rules
    if linters:
        lint_deps()

        # Linting Rules
        lint_setup({
            # Note: this is an example config!
            "java-spotbugs": "//java:spotbugs-config",
        })

    # rules_cc

    # rules_cc_dependencies()

    # rules_cc_toolchains()

    # Zig

    zig_toolchains()

    # LLVM

    llvm_toolchains()

    llvm_toolchain(
        name = "llvm",
        llvm_version = LLVM_VERSION,
    )

    # Go

    go_rules_dependencies()

    if go_toolchains:
        go_register_toolchains(version = GO_VERSION)

    gazelle_dependencies(go_repository_default_config = "//:WORKSPACE.bazel")

    # Google APIs

    switched_rules_by_language(
        name = "com_google_googleapis_imports",
    )

    # Buildifier

    buildifier_prebuilt_deps()

    # Skylib

    bazel_skylib_workspace()

    # Java

    rules_java_dependencies()

    rules_java_toolchains()

    # Python

    py_repositories()

    # GraalVM

    graalvm_repository(
        name = "graalvm",
        version = GRAALVM_VERSION,
        distribution = GRAALVM_DISTRIBUTION,
        java_version = GRAALVM_JAVA_VERSION,
        sha256 = GRAALVM_SHA,
        components = GRAALVM_COMPONENTS,
    )

    # Aspect: Bazel Lib

    aspect_bazel_lib_dependencies()

    # Rules JVM External

    rules_jvm_external_deps()

    # Contrib Rules JVM

    contrib_rules_jvm_deps()

    # Stardoc

    stardoc_repositories()

    # if maven:
    #     maven_install(
    #         name = "maven_gvm",
    #         artifacts = MAVEN_ARTIFACTS,
    #         repositories = MAVEN_REPOSITORIES,
    #         maven_install_json = "//:maven_install.json",
    #         generate_compat_repositories = True,
    #     )

rules_graalvm_repositories = _setup_rules_graalvm_repositories
