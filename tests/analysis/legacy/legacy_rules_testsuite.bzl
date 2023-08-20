"Defines analysis-time tests for legacy GraalVM Native Image rules."

load(
    "@rules_testing//lib:analysis_test.bzl",
    "analysis_test",
    "test_suite",
)
load(
    "@rules_java//java:defs.bzl",
    "java_library",
)
load(
    "//graalvm:defs.bzl",
    "native_image",
)

# Test: `gvm_legacy_nativeimage`
# ---
# Verifies that the `native_image_tool` attribute defaults to a sensible and expected value when using
# the legacy Native Image rule, and that binary outputs are arranged as expected.

def _test_gvm_legacy_nativeimage(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        native_image_tool = "@graalvm//:native-image",
    )
    analysis_test(
        name = name,
        impl = _test_gvm_default_nativeimage_tool_impl,
        target = "%s_native" % name,
    )

def _test_gvm_default_nativeimage_tool_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/legacy/test_gvm_legacy_nativeimage_native-bin",
    )
    env.expect.that_target(target).executable().short_path_equals(
        "tests/analysis/legacy/test_gvm_legacy_nativeimage_native-bin",
    )


## Exports.
def rules_graalvm_legacy_nativeimage_testsuite(name):
  test_suite(
    name = name,
    tests = [
        _test_gvm_legacy_nativeimage,
    ],
  )

testsuite = rules_graalvm_legacy_nativeimage_testsuite
