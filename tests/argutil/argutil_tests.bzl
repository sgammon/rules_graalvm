"Unit tests for Native Image argument and version helpers."

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//internal:argutil.bzl", "gvm_splits_debug_info")

def _splits_debug_info_test_impl(ctx):
    env = unittest.begin(ctx)
    cases = [
        # Release-train versions: 23.0 made `-H:+StripDebugInfo` the Linux default.
        ("23.0.1", True),
        ("23.1.2", True),
        ("24.1.0", True),
        ("25.0.2", True),
        ("25.5.5.0.3", True),
        ("25.0.2-custom", True),
        # Oracle builds versioned by JDK update.
        ("17.0.12", True),
        ("21.0.12", True),
        ("21.0.1", True),
        # Legacy release-train versions embed debug info in the binary.
        ("22.3.2", False),
        ("22.1.0", False),
        ("21.3.0", False),
        ("21.0.0", False),
        ("20.2.0", False),
        # Unknown versions never declare an output the driver might not write.
        ("", False),
        ("latest", False),
    ]
    for version, expected in cases:
        asserts.equals(env, expected, gvm_splits_debug_info(version), "gvm_splits_debug_info(%r)" % version)
    return unittest.end(env)

_splits_debug_info_test = unittest.make(_splits_debug_info_test_impl)

def argutil_testsuite(name):
    unittest.suite(
        name,
        _splits_debug_info_test,
    )
