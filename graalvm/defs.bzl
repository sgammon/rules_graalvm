"Target rule definitions, intended for use by rule users."

load(
    "//graalvm/nativeimage:rules.bzl",
    _native_image = "native_image",
)
load("//graalvm/webimage:rules.bzl", _web_image = "web_image")

## Exports
native_image = _native_image
web_image = _web_image
