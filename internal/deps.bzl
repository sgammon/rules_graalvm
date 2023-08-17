"Defines project dependencies for `rules_graalvm`."

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)
load(
    "@bazel_tools//tools/build_defs/repo:utils.bzl",
    "maybe",
)


def rules_graalvm_repositories(omit_rules_java = False, omit_bazel_skylib = False):
  """Defines dependencies for the GraalVM Rules for Bazel.
  
  This function only needs to be called if consuming the GraalVM Rules from a non-Bzlmod environment.
  The only dependencies the rules have are: (1) `rules_java`, and (2) `bazel_skylib`. Either or both
  can be omitted with the provided arguments.

  Args:
    omit_rules_java: Omit the `rules_java` dependency.
    omit_bazel_skylib: Omit the `bazel_skylib` dependency.
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
        sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
        ],
    )
