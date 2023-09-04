"Defines provider info for various Native Image build options."

_SETTING_ARCH_DEFAULT = "//graalvm/nativeimage/options:arch"

# buildifier: disable=name-conventions
_NativeImageArchitecture = struct(
    COMPATIBILITY = "compatibility",
    NATIVE = "native",
    AMD_64 = "amd64",
    ARM_64 = "amd64",
)

_NativeImageArchInfo = provider(
    fields = ["target_arch"],
    doc = "Provides target architecture selection support for GraalVM native image targets.",
)

supported_architectures = [
    _NativeImageArchitecture.COMPATIBILITY,
    _NativeImageArchitecture.NATIVE,
    _NativeImageArchitecture.AMD_64,
    _NativeImageArchitecture.ARM_64,
]

def _native_image_arch_impl(ctx):
    target_arch = ctx.build_setting_value
    if target_arch not in supported_architectures:
        fail(str(ctx.label) + " build setting allowed to take values {"
             + ", ".join(supported_architectures) + "} but was set to unallowed value "
             + target_arch)

    return _NativeImageArchInfo(
        target_arch = target_arch,
    )

# Exports.

# buildifier: disable=name-conventions
NativeImageArchitecture = _NativeImageArchitecture

NativeImageArchInfo = _NativeImageArchInfo

SETTING_ARCH_DEFAULT = _SETTING_ARCH_DEFAULT

arch = rule(
    implementation = _native_image_arch_impl,
    build_setting = config.string(
        flag = True,
    )
)
