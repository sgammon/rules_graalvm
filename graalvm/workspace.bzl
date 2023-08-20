"Bazel Workspace (non-Bzlmod) definitions."

load(
    "//internal:deps.bzl",
    _rules_graalvm_repositories = "rules_graalvm_repositories",
)
load(
    "//internal:toolchain.bzl",
    _register_graalvm_toolchains = "register_graalvm_toolchains",
)

# Exports.
rules_graalvm_repositories = _rules_graalvm_repositories
register_graalvm_toolchains = _register_graalvm_toolchains
