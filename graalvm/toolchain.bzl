"Toolchain types and rules for GraalVM."

load(
    "//internal:toolchain.bzl",
    _register_graalvm_toolchains = "register_graalvm_toolchains",
)

## Exports.

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
