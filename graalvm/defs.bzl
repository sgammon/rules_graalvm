"Target rule definitions, intended for use by rule users."

load(
    "//graalvm/nativeimage:rules.bzl",
    _native_image = "native_image",
    _native_image_shared_library = "native_image_shared_library",
)

## Exports
native_image = _native_image
native_image_shared_library = _native_image_shared_library
