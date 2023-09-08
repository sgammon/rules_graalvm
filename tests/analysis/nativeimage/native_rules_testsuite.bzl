"Defines analysis-time tests for new GraalVM Native Image rules."

load(
    "@rules_java//java:defs.bzl",
    "java_library",
)
load(
    "@rules_testing//lib:analysis_test.bzl",
    "analysis_test",
    "test_suite",
)
load(
    "//graal:graal.bzl",
    "native_image",
)

# Test: `gvm_modern_nativeimage`
# ---
# Verifies that the new Native Image rules behave as expected, and produce identical binary
# outputs to the previous rules.

def _test_gvm_modern_nativeimage(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
    )
    analysis_test(
        name = name,
        impl = _test_gvm_default_nativeimage_tool_impl,
        target = "%s_native" % name,
    )

def _test_gvm_default_nativeimage_tool_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_gvm_modern_nativeimage_native-bin",
    )
    env.expect.that_target(target).executable().short_path_equals(
        "tests/analysis/nativeimage/test_gvm_modern_nativeimage_native-bin",
    )

## Exports.
def rules_graalvm_nativeimage_testsuite(name):
    test_suite(
        name = name,
        tests = [
            #            _test_gvm_modern_nativeimage,
        ],
    )

testsuite = rules_graalvm_nativeimage_testsuite
