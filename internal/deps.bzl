"Defines project dependencies for `rules_graalvm`."

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)
load(
    "@bazel_tools//tools/build_defs/repo:utils.bzl",
    "maybe",
)

def rules_graalvm_repositories(
        omit_rules_java = False,
        omit_rules_cc = False,
        omit_bazel_skylib = False,
        omit_apple_support = False):
    """Defines dependencies for the GraalVM Rules for Bazel.

    This function only needs to be called if consuming the GraalVM Rules from a non-Bzlmod environment.
    The only dependencies the rules have are: (1) `rules_java`, (2) `rules_cc`, (3) `bazel_skylib`,
    and (4) `apple_support`. Any of those can be omitted with the provided arguments.

    Args:
      omit_rules_java: Omit the `rules_java` dependency.
      omit_rules_cc: Omit the `rules_cc` dependency.
      omit_bazel_skylib: Omit the `bazel_skylib` dependency.
      omit_apple_support: Omit the `apple_support` dependency.
    """

    if not omit_rules_java:
        maybe(
            name = "rules_java",
            repo_rule = http_archive,
            sha256 = "17b18cb4f92ab7b94aa343ce78531b73960b1bed2ba166e5b02c9fdf0b0ac270",
            urls = [
                "https://github.com/bazelbuild/rules_java/releases/download/7.12.5/rules_java-7.12.5.tar.gz",
            ],
        )

    if not omit_rules_cc:
        maybe(
            name = "rules_cc",
            repo_rule = http_archive,
            sha256 = "712d77868b3152dd618c4d64faaddefcc5965f90f5de6e6dd1d5ddcd0be82d42",
            strip_prefix = "rules_cc-0.1.1",
            urls = [
                "https://github.com/bazelbuild/rules_cc/releases/download/0.1.1/rules_cc-0.1.1.tar.gz",
            ],
            # `cc/defs.bzl` in modern rules_cc load-depends on protobuf for the
            # deprecated `cc_proto_library` re-export. Bazel's builtin Java
            # toolchains load that file in hybrid WORKSPACE builds, which would
            # force protobuf onto every WORKSPACE consumer; sever the edge.
            patch_args = ["-p1"],
            patches = [Label("//internal:rules_cc_protobuf.patch")],
        )

    if not omit_bazel_skylib:
        maybe(
            name = "bazel_skylib",
            repo_rule = http_archive,
            sha256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz",
                "https://github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz",
            ],
        )

    if not omit_apple_support:
        maybe(
            name = "build_bazel_apple_support",
            repo_rule = http_archive,
            sha256 = "45d6bbad5316c9c300878bf7fffc4ffde13d620484c9184708c917e20b8b63ff",
            url = "https://github.com/bazelbuild/apple_support/releases/download/1.8.1/apple_support.1.8.1.tar.gz",
        )
