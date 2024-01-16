"Target rule definitions, intended for use by rule users."

load(
    "//graalvm/nativeimage:rules.bzl",
    _native_image = "native_image",
    _native_image_shared_library = "native_image_shared_library",
    _native_image_test = "native_image_test",
)

## Exports
native_image = _native_image
native_image_shared_library = _native_image_shared_library
native_image_test = _native_image_test
