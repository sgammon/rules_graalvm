"Bazel Workspace (non-Bzlmod) definitions."

load(
    "//internal:deps.bzl",
    _rules_graalvm_repositories = "rules_graalvm_repositories",
)

rules_graalvm_repositories = _rules_graalvm_repositories
