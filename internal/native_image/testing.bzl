"Internals for testing with GraalVM native images."

# Top-level entrypoint for native tests (unless user provides their own).
NATIVE_TEST_ENTRYPOINT = "graalvm.testing.NativeTestRunner"

# Default Bazel entrypoint wrapped by the top-level entrypoint.
DEFAULT_WRAPPED_ENTRYPOINT = "com.google.testing.junit.runner.BazelTestRunner"

# Default GraalVM test discovery entrypoint overridden by the top-level entrypoint.
DEFAULT_NATIVE_BASE_ENTRYPOINT = "org.graalvm.junit.platform.NativeImageJUnitLauncher"

# Compile-time feature which configures reflective access to entrypoints and tests.
NATIVE_TEST_FEATURE = "graalvm.testing.NativeTestFeature"
