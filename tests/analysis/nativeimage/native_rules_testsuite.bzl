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
load("@rules_testing//lib:truth.bzl", "matching")
load("@rules_testing//lib:util.bzl", "TestingAspectInfo")
load(
    "//graalvm:defs.bzl",
    "native_image",
    "native_image_layer",
)

# Helper target tags — `manual` excludes these from wildcard builds like `//tests/...` because
# layered native-image builds require GraalVM >= 24 (Early Adopter feature). Analysis tests only
# exercise analysis-time structure, so the helpers are not intended to be built directly in CI
# where the bundled GraalVM version may be older.
_HELPER_TAGS = ["manual"]

# Passed to every `analysis_test` call so the underlying test target gets classified as `small`.
# Bazel otherwise defaults test size to MEDIUM, then emits a noisy warning because analysis tests
# complete in milliseconds. `analysis_test` itself does not take `size` directly, but forwards
# anything in `attr_values` to the generated test target.
_ANALYSIS_TEST_ATTRS = {"size": "small"}

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
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

# buildifier: disable=unused-variable
def _test_gvm_default_nativeimage_tool_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_gvm_modern_nativeimage_native-bin",
    )
    env.expect.that_target(target).executable().short_path_equals(
        "tests/analysis/nativeimage/test_gvm_modern_nativeimage_native-bin",
    )

# Test: `native_image_configuration_file_directories`
# ---
# A Native Image configuration directory is an action input, not a host path encoded through
# `extra_args`. Verify a label-backed pair of directories is declared in the action and emitted
# in deterministic order even when the caller supplies the labels in reverse order.
def _test_native_image_configuration_file_directories(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        tags = _HELPER_TAGS,
        configuration_file_directories = [
            ":%s_configuration_b" % name,
            ":%s_configuration_a" % name,
        ],
    )
    analysis_test(
        name = name,
        impl = _test_native_image_configuration_file_directories_impl,
        target = "%s_native" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_native_image_configuration_file_directories_impl(env, target):
    native_action = [
        registered_action
        for registered_action in target[TestingAspectInfo].actions
        if registered_action.mnemonic == "NativeImage"
    ][0]
    configuration_args = [
        argument
        for argument in native_action.argv
        if argument.startswith("-H:ConfigurationFileDirectories=")
    ]
    env.expect.that_int(len(configuration_args)).equals(1)
    env.expect.that_str(configuration_args[0].replace(";", ":")).equals(
        "-H:ConfigurationFileDirectories=tests/analysis/nativeimage/configuration/a:tests/analysis/nativeimage/configuration/b",
    )
    env.expect.that_collection([
        input_file.short_path
        for input_file in native_action.inputs.to_list()
    ]).contains_at_least([
        "tests/analysis/nativeimage/configuration/a/reflect-config.json",
        "tests/analysis/nativeimage/configuration/a/resource-config.json",
        "tests/analysis/nativeimage/configuration/b/reachability-metadata.json",
    ])

# Test: configuration-directory validation
# ---
# Empty and multi-parent labels are ambiguous: each supplied label must name exactly one
# execution-root-relative directory.
def _test_native_image_configuration_file_directories_empty(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        tags = _HELPER_TAGS,
        configuration_file_directories = [":%s_files" % name],
    )
    analysis_test(
        name = name,
        impl = _test_native_image_configuration_file_directories_empty_impl,
        target = "%s_native" % name,
        expect_failure = True,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_native_image_configuration_file_directories_empty_impl(env, target):
    env.expect.that_target(target).failures().contains_predicate(
        matching.contains("configuration_file_directories"),
    )

def _test_native_image_configuration_file_directories_mixed(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        tags = _HELPER_TAGS,
        configuration_file_directories = [":%s_files" % name],
    )
    analysis_test(
        name = name,
        impl = _test_native_image_configuration_file_directories_mixed_impl,
        target = "%s_native" % name,
        expect_failure = True,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_native_image_configuration_file_directories_mixed_impl(env, target):
    env.expect.that_target(target).failures().contains_predicate(
        matching.contains("single directory"),
    )

# Test: `native_image_layer_smoke`
# ---
# Verifies that a minimal `native_image_layer` target analyzes successfully and produces a
# `<name>.nil` TreeArtifact as its default output.
def _test_native_image_layer_smoke(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image_layer(
        name = "%s_layer" % name,
        deps = [":%s_java" % name],
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_native_image_layer_smoke_impl,
        target = "%s_layer" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_native_image_layer_smoke_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_native_image_layer_smoke_layer.nil",
    )

# Test: `native_image_layer_with_directives`
# ---
# Verifies that a `native_image_layer` with well-formed directives analyzes successfully.
def _test_native_image_layer_with_directives(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image_layer(
        name = "%s_layer" % name,
        deps = [":%s_java" % name],
        directives = [
            "module=java.base",
            "package=com.example.*",
        ],
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_native_image_layer_with_directives_impl,
        target = "%s_layer" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_native_image_layer_with_directives_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_native_image_layer_with_directives_layer.nil",
    )

# Test: `native_image_consumes_layer`
# ---
# Verifies that a `native_image` target consuming a parent layer via `layers=[:base]` analyzes
# successfully and produces the usual binary output.
def _test_native_image_consumes_layer(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image_layer(
        name = "%s_base" % name,
        deps = [":%s_java" % name],
        tags = _HELPER_TAGS,
    )
    native_image(
        name = "%s_app" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        layers = [":%s_base" % name],
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_native_image_consumes_layer_impl,
        target = "%s_app" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_native_image_consumes_layer_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_native_image_consumes_layer_app-bin",
    )

# Test: `layer_chain`
# ---
# Verifies that a layer consuming another layer via `layers=[...]` analyzes successfully.
def _test_layer_chain(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image_layer(
        name = "%s_base" % name,
        deps = [":%s_java" % name],
        initialize_at_build_time = ["com.example.Base"],
        tags = _HELPER_TAGS,
    )
    native_image_layer(
        name = "%s_mid" % name,
        deps = [":%s_java" % name],
        layers = [":%s_base" % name],
        initialize_at_build_time = ["com.example.Mid"],
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_layer_chain_impl,
        target = "%s_mid" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_layer_chain_impl(env, target):
    env.expect.that_target(target).default_outputs().contains(
        "tests/analysis/nativeimage/test_layer_chain_mid.nil",
    )

## Exports.
def rules_graalvm_nativeimage_testsuite(name):
    test_suite(
        name = name,
        tests = [
            #            _test_gvm_modern_nativeimage,
            _test_native_image_configuration_file_directories,
            _test_native_image_configuration_file_directories_empty,
            _test_native_image_configuration_file_directories_mixed,
            _test_native_image_layer_smoke,
            _test_native_image_layer_with_directives,
            _test_native_image_consumes_layer,
            _test_layer_chain,
        ],
    )

testsuite = rules_graalvm_nativeimage_testsuite
