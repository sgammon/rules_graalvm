"Target rule definitions, intended for use by rule users."

load(
    "//graalvm/nativeimage:rules.bzl",
    _native_image = "native_image",
)
load(
    "//graalvm/reachability:rules.bzl",
    _reachability_metadata = "reachability_metadata",
)

## Exports
native_image = _native_image
reachability_metadata = _reachability_metadata
