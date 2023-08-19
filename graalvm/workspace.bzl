"Bazel Workspace (non-Bzlmod) definitions."

load(
    "//internal:deps.bzl",
    _rules_graalvm_repositories = "rules_graalvm_repositories",
)
load(
    "//internal:toolchain.bzl",
    _rules_graalvm_toolchains = "rules_graalvm_toolchains",
)

# Exports.
rules_graalvm_repositories = _rules_graalvm_repositories
rules_graalvm_toolchains = _rules_graalvm_toolchains
