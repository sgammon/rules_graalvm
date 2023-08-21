"Definitions for engines/components that ship with GraalVM."

load(
    "//internal:graalvm_bindist_map.bzl",
    Component = "DistributionComponent",
)

# buildifier: disable=name-conventions
_GraalVMEngine = struct(
    JS = Component.JS,
    PYTHON = Component.PYTHON,
    RUBY = Component.RUBY,
    WASM = Component.WASM,
    LLVM = Component.LLVM,
    ESPRESSO = Component.ESPRESSO,
    REGEX = Component.REGEX,
)

# Exports.

# buildifier: disable=name-conventions
GraalVMEngine = _GraalVMEngine
