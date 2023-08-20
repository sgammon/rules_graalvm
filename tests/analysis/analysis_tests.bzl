"Defines basic analysis-time sanity tests."

load(
    "@rules_testing//lib:analysis_test.bzl",
    "analysis_test",
    "test_suite",
)
load(
    "@rules_testing//lib:util.bzl",
    "util",
)

# Test: `analysis_sanity`
# ---
# Verifies that analysis-time testing is working correctly.
def _test_analysis_time_sanity(name):
    util.helper_target(
        native.filegroup,
        name = name + "_subject",
        srcs = ["hello_world.txt"],
    )
    analysis_test(
        name = name,
        impl = _test_analysis_time_sanity_impl,
        target = name + "_subject",
    )

def _test_analysis_time_sanity_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/hello_world.txt"
    )

## Exports.
def rules_graalvm_analysis_time_sanity_testsuite(name):
  test_suite(
    name = name,
    tests = [
        _test_analysis_time_sanity,
    ],
  )

testsuite = rules_graalvm_analysis_time_sanity_testsuite
