"Defines a provider which exposes Native Image compilation setting info."

# buildifier: disable=name-conventions
_GraalVMLibC = struct(
    GLIBC = "glibc",
    MUSL = "musl",
)

# buildifier: disable=name-conventions
_GraalVMCompilerBackend = struct(
    NATIVE = "native",
    LLVM = "llvm",
)

_DEFAULT_LIBC = _GraalVMLibC.GLIBC
_DEFAULT_COMPILER = _GraalVMCompilerBackend.NATIVE
_DEFAULT_BUILD_OPT = "2"  # fully optimize

# buildifier: disable=name-conventions
_DEFAULTS = struct(
    LIBC = _DEFAULT_LIBC,
    BUILD_OPT = _DEFAULT_BUILD_OPT,
    COMPILER_BACKEND = _DEFAULT_COMPILER,
)

_NativeImageInfo = provider(
    fields = [
        "opt",
        "libc",
        "compiler_backend",
    ],
    doc = """
    Defines a provider which keeps track of native image build settings,
    including the libc to build against and compiler backend.

    Attributes:
        opt: Optimization to use for this target and configuration.
        libc: Selected `libc` to build against; either `glibc` or `musl`.
        compiler_backend: Compiler backend to use; either `native` or `llvm`.
    """,
)

# buildifier: disable=unused-variable
def _gvm_nativeimage_info(ctx):
    """Provide info about a Native Image target's tooling settings."""

    return _NativeImageInfo(
        #
    )

def _gvm_nativeimage_settings(ctx):
    """Generate Native Image tooling settings directly in an explicit target."""

    return _NativeImageInfo(
        opt = ctx.attr.opt,
        libc = ctx.attr.libc,
        compiler_backend = ctx.attr.compiler_backend,
    )

_native_image_info = rule(
    implementation = _gvm_nativeimage_info,
    attrs = {
        "libc": attr.label(
            doc = "Libc setting to build against.",
            mandatory = True,
        ),
        "compiler_backend": attr.label(
            doc = "Compiler backend setting to build against.",
            mandatory = True,
        ),
    },
)

_native_image_settings = rule(
    implementation = _gvm_nativeimage_settings,
    attrs = {
        "opt": attr.string(
            default = _DEFAULT_BUILD_OPT,
            doc = "Optimization mode to use. Defaults to `2` per GraalVM docs.",
            mandatory = True,
            values = [
                "0",
                "1",
                "2",
                "b",
            ],
        ),
        "libc": attr.string(
            default = _DEFAULT_LIBC,
            doc = "Libc to build against. Defaults to `glibc` per GraalVM docs.",
            mandatory = True,
            values = [
                _GraalVMLibC.GLIBC,
                _GraalVMLibC.MUSL,
            ],
        ),
        "compiler_backend": attr.string(
            default = _DEFAULT_COMPILER,
            doc = "Compiler backend to build against. Defaults to native C compiler.",
            mandatory = True,
            values = [
                _GraalVMCompilerBackend.NATIVE,
                _GraalVMCompilerBackend.LLVM,
            ],
        ),
    },
)

_ALL_SETTINGS = [
    "opt",
    "libc",
    "compiler_backend",
]

# Exports.

# buildifier: disable=name-conventions
GraalVMLibC = _GraalVMLibC

# buildifier: disable=name-conventions
GraalVMCompilerBackend = _GraalVMCompilerBackend

NativeImageInfo = _NativeImageInfo

ALL_SETTINGS = _ALL_SETTINGS
DEFAULT_LIBC = _DEFAULT_LIBC
DEFAULT_COMPILER = _DEFAULT_COMPILER
DEFAULT_BUILD_OPT = _DEFAULT_BUILD_OPT
DEFAULTS = _DEFAULTS

native_image_settings = _native_image_settings

native_image_info = _native_image_info
