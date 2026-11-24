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

# Test: `optimization_mode_levels`
# ---
# Verifies that every GraalVM optimization level is accepted and passed through as `-O<level>`
# (#570).
def _optimization_mode_test(name, level):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        optimization_mode = level,
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = lambda env, target: env.expect.that_target(target).action_named(
            "NativeImage",
        ).contains_at_least_args(["-O%s" % level]),
        target = "%s_native" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_optimization_mode_none(name):
    _optimization_mode_test(name, "0")

def _test_optimization_mode_size(name):
    _optimization_mode_test(name, "s")

def _test_optimization_mode_level_3(name):
    _optimization_mode_test(name, "3")

# Test: `debug_info_file_forced`
# ---
# Verifies that `debug_info_file = 1` declares `<image-name>.debug` as an output of the build,
# exposed in the default outputs and the `debug_info` output group, so Bazel keeps it (#453).
def _test_debug_info_file_forced(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        debug = True,
        debug_info_file = 1,
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_debug_info_file_forced_impl,
        target = "%s_native" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_debug_info_file_forced_impl(env, target):
    debug_file = matching.file_basename_equals("test_debug_info_file_forced_native-bin.debug")
    env.expect.that_target(target).default_outputs().contains_predicate(debug_file)
    env.expect.that_target(target).output_group("debug_info").contains_predicate(debug_file)
    env.expect.that_target(target).action_named("NativeImage").contains_at_least_args(["-g"])

# Test: `debug_info_file_disabled`
# ---
# Verifies that `debug_info_file = 0` keeps the `.debug` file out of the declared outputs.
def _test_debug_info_file_disabled(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        debug = True,
        debug_info_file = 0,
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_debug_info_file_disabled_impl,
        target = "%s_native" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_debug_info_file_disabled_impl(env, target):
    env.expect.that_target(target).default_outputs().not_contains_predicate(
        matching.file_basename_contains(".debug"),
    )

# Test: `without_apple_support`
# ---
# Verifies that `use_apple_support = False` analyzes and still produces the image (#567).
def _test_without_apple_support(name):
    java_library(
        name = "%s_java" % name,
        srcs = ["Main.java"],
    )
    native_image(
        name = "%s_native" % name,
        main_class = "Main",
        deps = [":%s_java" % name],
        use_apple_support = False,
        tags = _HELPER_TAGS,
    )
    analysis_test(
        name = name,
        impl = _test_without_apple_support_impl,
        target = "%s_native" % name,
        attr_values = _ANALYSIS_TEST_ATTRS,
    )

def _test_without_apple_support_impl(env, target):
    env.expect.that_target(target).action_named("NativeImage").contains_at_least_args(["-H:Class=Main"])

## Exports.
def rules_graalvm_nativeimage_testsuite(name):
    test_suite(
        name = name,
        tests = [
            #            _test_gvm_modern_nativeimage,
            _test_native_image_layer_smoke,
            _test_native_image_layer_with_directives,
            _test_native_image_consumes_layer,
            _test_layer_chain,
            _test_optimization_mode_none,
            _test_optimization_mode_size,
            _test_optimization_mode_level_3,
            _test_debug_info_file_forced,
            _test_debug_info_file_disabled,
            _test_without_apple_support,
        ],
    )

testsuite = rules_graalvm_nativeimage_testsuite
