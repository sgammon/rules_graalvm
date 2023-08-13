"Repository rule definitions, intended for use by rule users."

load(
    "//internal:graalvm_bindist.bzl",
    _graalvm_repository = "graalvm_repository",
)

## Exports
graalvm_repository = _graalvm_repository
