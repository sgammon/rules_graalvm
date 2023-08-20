"Toolchain types and rules for GraalVM."

load(
    "//internal:toolchain.bzl",
    _register_graalvm_toolchains = "register_graalvm_toolchains",
)

## Exports.
register_graalvm_toolchains = _register_graalvm_toolchains
