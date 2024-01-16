"Defines common values used for native testing."

load(
    "//internal/testing:bzl",
    _NATIVE_TEST_ENTRYPOINT = "NATIVE_TEST_ENTRYPOINT",
    _DEFAULT_WRAPPED_ENTRYPOINT = "DEFAULT_WRAPPED_ENTRYPOINT",
    _DEFAULT_NATIVE_BASE_ENTRYPOINT = "DEFAULT_NATIVE_BASE_ENTRYPOINT",
    _NATIVE_TEST_FEATURE = "NATIVE_TEST_FEATURE",
)

# Top-level entrypoint for native tests (unless user provides their own).
NATIVE_TEST_ENTRYPOINT = _NATIVE_TEST_ENTRYPOINT

# Default Bazel entrypoint wrapped by the top-level entrypoint.
DEFAULT_WRAPPED_ENTRYPOINT = _DEFAULT_WRAPPED_ENTRYPOINT

# Default GraalVM test discovery entrypoint overridden by the top-level entrypoint.
DEFAULT_NATIVE_BASE_ENTRYPOINT = _DEFAULT_NATIVE_BASE_ENTRYPOINT

# Compile-time feature which configures reflective access to entrypoints and tests.
NATIVE_TEST_FEATURE = _NATIVE_TEST_FEATURE
