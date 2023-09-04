"Defines targets and enumerations for various Native Image builder options."

load(
    "//internal/native_image/options:arch.bzl",
    _NativeImageArchitecture = "NativeImageArchitecture",
)

# Exports

# buildifier: disable=name-conventions
NativeImageArchitecture = _NativeImageArchitecture
