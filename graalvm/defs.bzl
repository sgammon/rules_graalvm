"Target rule definitions, intended for use by rule users."

load(
    "//graalvm/nativeimage:layer_rules.bzl",
    _native_image_layer = "native_image_layer",
)
load(
    "//graalvm/nativeimage:rules.bzl",
    _native_image = "native_image",
)
load(
    "//internal/native_image:settings.bzl",
    _NativeImageLayerInfo = "NativeImageLayerInfo",
)

## Exports
native_image = _native_image
native_image_layer = _native_image_layer

# buildifier: disable=name-conventions
NativeImageLayerInfo = _NativeImageLayerInfo
