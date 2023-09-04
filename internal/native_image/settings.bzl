"Defines a provider which exposes Native Image compilation setting info."

load(
    "//internal/native_image/options:arch.bzl",
    "NativeImageArchInfo",
    _SETTING_ARCH_DEFAULT = "SETTING_ARCH_DEFAULT",
    _NativeImageArchitecture = "NativeImageArchitecture",
)

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
_DEFAULT_ARCH = _NativeImageArchitecture.COMPATIBILITY

# buildifier: disable=name-conventions
_DEFAULTS = struct(
    LIBC = _DEFAULT_LIBC,
    BUILD_OPT = _DEFAULT_BUILD_OPT,
    COMPILER_BACKEND = _DEFAULT_COMPILER,
    ARCH = _DEFAULT_ARCH,
)

_NativeImageInfo = provider(
    fields = [
        "opt",
        "libc",
        "compiler_backend",
        "arch",
        "settings",
    ],
    doc = """
    Defines a provider which keeps track of native image build settings,
    including the libc to build against and compiler backend.

    Attributes:
        opt: Optimization to use for this target and configuration.
        libc: Selected `libc` to build against; either `glibc` or `musl`.
        compiler_backend: Compiler backend to use; either `native` or `llvm`.
        arch: Target native architecture setting to use.
    """,
)


def _gvm_nativeimage_info(ctx):
    """Provide info about a Native Image target's tooling settings."""

    return _NativeImageInfo(
        #
        arch = ctx.attr.arch[NativeImageArchInfo].target_arch,
    )

def _gvm_nativeimage_settings(ctx):
    """Generate Native Image tooling settings directly in an explicit target."""

    return _NativeImageInfo(
        opt = ctx.attr.opt,
        libc = ctx.attr.libc,
        compiler_backend = ctx.attr.compiler_backend,
        arch = ctx.attr.arch,
        settings = ctx.attr.settings,
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
        "arch": attr.label(
            default = _SETTING_ARCH_DEFAULT,
            doc = "Target native architecture advice (`march`). If unspecified, uses Bazel or GraalVM's defaults.",
            mandatory = False,
        ),
    },
)

_native_image_settings = rule(
    implementation = _gvm_nativeimage_settings,
    doc = """
Defines a package of Native Image build settings, which can be passed into a `native_image`
target in order to customize how the native image is generated and compiled.

Optimizations settings, `libc`, the compiler backend, and target architecture advice can all
be set via the `native_image_settings` target.
""",
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
        "arch": attr.string(
            default = _DEFAULT_ARCH,
            doc = "Target native architecture advice (`march`). If unspecified, uses Bazel or GraalVM's defaults.",
            mandatory = False,
            values = [
                _NativeImageArchitecture.COMPATIBILITY,
                _NativeImageArchitecture.NATIVE,
                _NativeImageArchitecture.AMD_64,
                _NativeImageArchitecture.ARM_64,
            ],
        ),
        "settings": attr.label(
            default = None,
            doc = "Bazel settings which should override settings specified within this target.",
            providers = [[_NativeImageInfo]],
        ),
    },
)

_ALL_SETTINGS = [
    "opt",
    "libc",
    "compiler_backend",
    "arch",
    "settings",
]

# Exports.

# buildifier: disable=name-conventions
GraalVMLibC = _GraalVMLibC

# buildifier: disable=name-conventions
GraalVMCompilerBackend = _GraalVMCompilerBackend

# buildifier: disable=name-conventions
NativeImageArchitecture = _NativeImageArchitecture

NativeImageInfo = _NativeImageInfo

ALL_SETTINGS = _ALL_SETTINGS
DEFAULT_LIBC = _DEFAULT_LIBC
DEFAULT_SETTING_ARCH = _SETTING_ARCH_DEFAULT
DEFAULT_COMPILER = _DEFAULT_COMPILER
DEFAULT_BUILD_OPT = _DEFAULT_BUILD_OPT
DEFAULT_ARCH = _DEFAULT_ARCH
DEFAULTS = _DEFAULTS

native_image_settings = _native_image_settings

native_image_info = _native_image_info
