"Definitions for engines/components that ship with GraalVM."

# buildifier: disable=name-conventions
_GraalVMComponent = struct(
    JS = "js",
    PYTHON = "python",
    RUBY = "ruby",
    WASM = "wasm",
    LLVM = "llvm",
    ESPRESSO = "espresso",
    NATIVE_IMAGE = "native-image",
)

# buildifier: disable=name-conventions
_GraalVMEngine = struct(
    JS = "js",
    PYTHON = "python",
    RUBY = "ruby",
    WASM = "wasm",
    LLVM = "llvm",
    ESPRESSO = "espresso",
)

# Exports.

# buildifier: disable=name-conventions
GraalVMComponent = _GraalVMComponent

# buildifier: disable=name-conventions
GraalVMEngine = _GraalVMEngine
