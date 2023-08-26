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
def rules_graalvm_repositories(
    omit_rules_java = False,
    omit_bazel_skylib = False):

    """Register dependency repositories for the GraalVM Rules for Bazel.

    This function only needs to be called if consuming the GraalVM Rules from a non-Bzlmod environment.
    The only dependencies the rules have are: (1) `rules_java`, and (2) `bazel_skylib`. Either or both
    can be omitted with the provided arguments.

    Args:
      omit_rules_java: Omit the `rules_java` dependency.
      omit_bazel_skylib: Omit the `bazel_skylib` dependency.
    """

    _rules_graalvm_repositories(
        omit_rules_java = omit_rules_java,
        omit_bazel_skylib = omit_bazel_skylib,
    )

def register_graalvm_toolchains(
    name = "@graalvm",
    register_java_toolchain = True,
    register_gvm_toolchain = True):

    """Register Bazel toolchains via the installed GraalVM repository.

    The default repository `name` is `@graalvm`, but this should be set to whatever the target repository
    is named (in the call to `graalvm_repository` or `graal_bindist_repository`).

    The GraalVM toolchain registers a custom Bazel toolchain which allows resolution of tools like
    `native-image`. If you opt out of installing the GraalVM toolchain, make sure you properly declare the
    target tool in your `native_image` binary targets.

    Args:
        name: Name of the target repository; defaults to `@graalvm`.
        register_java_toolchain: Whether to register GraalVM as a Java toolchain. Defaults to `True`.
        register_gvm_toolchain: Whether to register a GraalVM-typed toolchain. Defaults to `True`.
    """

    _register_graalvm_toolchains(
        name = name,
        register_java_toolchain = register_java_toolchain,
        register_gvm_toolchain = register_gvm_toolchain,
    )
