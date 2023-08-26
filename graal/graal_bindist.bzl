"Legacy repository rule alias."

load(
    "//internal:graalvm_bindist.bzl",
    _graalvm_repository = "graalvm_repository",
)

## Exports
graal_bindist_repository = _graalvm_repository
