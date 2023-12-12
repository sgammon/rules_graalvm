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
        omit_bazel_skylib = False,
        omit_apple_support = False):
    """Defines dependencies for the GraalVM Rules for Bazel.

    This function only needs to be called if consuming the GraalVM Rules from a non-Bzlmod environment.
    The only dependencies the rules have are: (1) `rules_java`, (2) `bazel_skylib`, and
    (3) `apple_support`. Any of those can be omitted with the provided arguments.

    Args:
      omit_rules_java: Omit the `rules_java` dependency.
      omit_bazel_skylib: Omit the `bazel_skylib` dependency.
      omit_apple_support: Omit the `apple_support` dependency.
    """

    if not omit_rules_java:
        maybe(
            name = "rules_java",
            repo_rule = http_archive,
            sha256 = "27abf8d2b26f4572ba4112ae8eb4439513615018e03a299f85a8460f6992f6a3",
            urls = [
                "https://github.com/bazelbuild/rules_java/releases/download/6.4.0/rules_java-6.4.0.tar.gz",
            ],
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
