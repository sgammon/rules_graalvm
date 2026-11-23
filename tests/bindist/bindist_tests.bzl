"Unit tests for GraalVM distribution coordinate and version resolution."

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load(
    "//internal:graalvm_bindist_map.bzl",
    "generate_distribution_coordinate",
    "resolve_distribution_artifact",
    "resolve_version_pair",
)

_LINUX = "linux-x64"

def _coordinate_test_impl(ctx):
    env = unittest.begin(ctx)
    cases = [
        # Innovation releases, by GraalVM version and by JDK version.
        (("ce", _LINUX, "25.5.5.0.3", "25"), "ce_25.0.5.0.3_linux-x64_25.5.5.0.3"),
        (("ce", _LINUX, "25.0.5.0.3", "25"), "ce_25.0.5.0.3_linux-x64_25.5.5.0.3"),
        (("ce", _LINUX, "25.4.4.1.1", "25"), "ce_25.0.4.1.1_linux-x64_25.4.4.1.1"),
        (("ce", _LINUX, "25.3.4.1", "25"), "ce_25.0.4.1_linux-x64_25.3.4.1"),
        (("ce", _LINUX, "25.2.4", "25"), "ce_25.0.4_linux-x64_25.2.4"),
        # JDK 25.0.4 on Community still means Innovation 2.
        (("ce", _LINUX, "25.0.4", "25"), "ce_25.0.4_linux-x64_25.2.4"),
        # Oracle keeps the JDK-update line.
        (("oracle", _LINUX, "25.0.4", "25"), "oracle_25.0.4_linux-x64_25.0.4"),
        # `latest` diverges per distribution at Java 25.
        (("ce", _LINUX, "latest", "25"), "ce_25.0.5.0.3_linux-x64_25.5.5.0.3"),
        (("oracle", _LINUX, "latest", "25"), "oracle_25.0.4_linux-x64_25.0.4"),
        (("ce", _LINUX, "latest", "21"), "ce_21.0.2_linux-x64_23.1.2"),
    ]
    for (args, expected) in cases:
        asserts.equals(env, expected, generate_distribution_coordinate(*args))
    return unittest.end(env)

coordinate_test = unittest.make(_coordinate_test_impl)

def _resolves_test_impl(ctx):
    env = unittest.begin(ctx)
    for version in ["25.3.4.1", "25.4.4.1.1", "25.5.5.0.3", "latest"]:
        for platform in ["linux-x64", "linux-aarch64", "macos-aarch64", "windows-x64"]:
            config = resolve_distribution_artifact("ce", platform, version, "25", strict = False)
            asserts.true(env, config != None, "no CE artifact for %s on %s" % (version, platform))
            if config != None:
                asserts.true(env, config["prefix"].startswith("graalvm-community-25."))
    asserts.equals(
        env,
        "oracle_25.0.4_linux-x64_25.0.4",
        generate_distribution_coordinate("oracle", _LINUX, "latest", "25"),
    )
    return unittest.end(env)

resolves_test = unittest.make(_resolves_test_impl)

def _version_pair_test_impl(ctx):
    env = unittest.begin(ctx)
    asserts.equals(env, ("25", "25.0.5.0.3"), resolve_version_pair("25", "latest", "ce"))
    asserts.equals(env, ("25", "25.0.4"), resolve_version_pair("25", "latest", "oracle"))

    # without a distribution, `latest` keeps resolving to the shared release
    asserts.equals(env, ("25", "25.0.4"), resolve_version_pair("25", "latest"))
    asserts.equals(env, ("25", "25.5.5.0.3"), resolve_version_pair("latest", "25.5.5.0.3", "ce"))
    return unittest.end(env)

version_pair_test = unittest.make(_version_pair_test_impl)

def bindist_testsuite(name):
    unittest.suite(
        name,
        coordinate_test,
        resolves_test,
        version_pair_test,
    )
