workspace(name = "rules_graal")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load("@rules_graal//graal:graal_bindist.bzl", "graal_bindist_repository")

graal_bindist_repository(
    name = "graal",
    version = "19.0.0",
)

git_repository(
    name = "rules_adroit",
    commit = "e98240c73746934b8cfcf05020f5e936aee5bd9f",
    remote = "git://github.com/andyscott/rules_adroit",
)

register_toolchains(
    "@rules_adroit//toolchains:shellcheck_from_host_path",
)
