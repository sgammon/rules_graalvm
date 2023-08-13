"Target rule definitions, intended for use by rule users."

load(
    "//graalvm/nativeimage:rules.bzl",
    _native_image = "native_image",
)

## Exports
native_image = _native_image
