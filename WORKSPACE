workspace(name = "rules_graal")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "graal_osx",
    url = "https://github.com/oracle/graal/releases/download/vm-1.0.0-rc16/graalvm-ce-1.0.0-rc16-macos-amd64.tar.gz",
    sha256 = "e464bb24daafc5994412d115a7aa292d3fc3f9826f627832aa18197814bb4fb0",
    build_file_content = """exports_files(glob(["**/*"]))""",
    strip_prefix = "graalvm-ce-1.0.0-rc16/Contents/Home",
)

git_repository(
    name = "rules_adroit",
    commit = "e98240c73746934b8cfcf05020f5e936aee5bd9f",
    remote = "git://github.com/andyscott/rules_adroit",
)

register_toolchains(
    "@rules_adroit//toolchains:shellcheck_from_host_path",
)