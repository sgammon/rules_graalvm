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
    "@rules_testing//lib:truth.bzl",
    "matching",
)
load(
    "//graal:graal.bzl",
    "native_image",
)
load(
    "//graalvm:defs.bzl",
    modern_native_image = "native_image",
)

# Test: `gvm_modern_nativeimage`
# ---
# Verifies that the new Native Image rules behave as expected, and produce identical binary
# outputs to the previous rules.

# buildifier: disable=unused-variable
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

# buildifier: disable=unused-variable
def _test_gvm_default_nativeimage_tool_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_gvm_modern_nativeimage_native-bin",
    )
    env.expect.that_target(target).executable().short_path_equals(
        "tests/analysis/nativeimage/test_gvm_modern_nativeimage_native-bin",
    )

# Test: `gvm_modern_nativeimage_cc_toolchain_flags`
# ---
# Verifies that `cc_toolchain_flags` passes the C++ toolchain's flags to Native Image and runs the
# C compiler through a wrapper.
def _test_gvm_modern_nativeimage_cc_toolchain_flags(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
        tags = ["manual"],
    )
    modern_native_image(
        name = "%s_native" % name,
        cc_toolchain_flags = True,
        main_class = "Main",
        tags = ["manual"],
        deps = [":%s_java" % name],
    )
    analysis_test(
        name = name,
        impl = _test_gvm_modern_nativeimage_cc_toolchain_flags_impl,
        target = "%s_native" % name,
    )

def _test_gvm_modern_nativeimage_cc_toolchain_flags_impl(env, target):
    argv = env.expect.that_target(target).action_named("NativeImage").argv()
    argv.contains_predicate(matching.str_matches(
        "--native-compiler-path=*/tests/analysis/nativeimage/test_gvm_modern_nativeimage_cc_toolchain_flags_native_native_compiler.sh",
    ))
    argv.contains_predicate(matching.str_startswith("-H:CCompilerOption="))

## Exports.
def rules_graalvm_nativeimage_testsuite(name):
    test_suite(
        name = name,
        tests = [
            #            _test_gvm_modern_nativeimage,
            _test_gvm_modern_nativeimage_cc_toolchain_flags,
        ],
    )

testsuite = rules_graalvm_nativeimage_testsuite
