"Binary mappings for GraalVM distribution artifacts."

# ! THIS FILE IS GENERATED. DO NOT EDIT. !

# Last updated: 2023-08-19T01:49:29.084173 by Sandboxed user

# To learn how to regenerate this file, consult the contributor docs for
# the `rules_graalvm` repository: https://github.com/sgammon/rules_graalvm

# Enumerates available distribution types.
# buildifier: disable=name-conventions
_DistributionType = struct(
    ORACLE = "oracle",
    COMMUNITY = "ce",
    ENTERPRISE = "ee",
)

# Enumerates available platform types.
# buildifier: disable=name-conventions
_DistributionPlatform = struct(
    MACOS_X64 = "macos-x64",
    MACOS_AARCH64 = "macos-aarch64",
    LINUX_X64 = "linux-x64",
    LINUX_AARCH64 = "linux-aarch64",
    WINDOWS_X64 = "windows-x64",
)

# Enumerates available platform types.
# buildifier: disable=name-conventions
_DistributionComponent = struct(
    NATIVE_IMAGE = "native-image",
    JS = "js",
    WASM = "wasm",
    PYTHON = "python",
    LLVM = "llvm",
    RUBY = "ruby",
    ESPRESSO = "espresso",
    REGEX = "regex",
    ICU4J = "icu4j",
    TRUFFLEJSON = "trufflejson",
)

# Lists dependencies for known components.
# buildifier: disable=name-conventions
_ComponentDependencies = struct(
    JS = [_DistributionComponent.REGEX, _DistributionComponent.ICU4J],
)

# Aligned GraalVM distribution versions.
# buildifier: disable=name-conventions
_AlignedVersions = {
    "20.0.2": "23.0.1",
    "20.0.1": "23.0.1",
    "17.0.8": "23.0.1",
    "17.0.7": "23.0.1",
}

# VM release versions for calculating prefixes.
# buildifier: disable=name-conventions
_VmReleaseVersions = {
    "20.0.2": "20.0.2+9.1",
    "20.0.1": "20.0.1+9.1",
    "17.0.8": "17.0.8+9.1",
    "17.0.7": "17.0.7+9.1",
}

def _generate_distribution_coordinate(dist, platform, version, component = None):
    """Generate a well-formed distribution coordinate key.

    Generates a key for the generated binary distribution map, which holds download
    URLs and known-good integrity values.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        component: Component to download; if downloading a JDK, `None` is expected.

    Returns:
        Generated distribution coordinate key.
    """

    segments = [
        dist,
        version,
        platform,
    ]
    if component != None:
        segments.append(component)
    segments.append(_AlignedVersions.get(version, version))

    # format:  `<dist>_<rlse>_<platfrm>_<vrsn>`
    # example: `oracle_20.0.2_linux-x64_23.0.1`
    return "_".join(segments)

def _resolve_distribution_artifact(dist, platform, version, component = None, strict = True):
    """Resolve a distribution artifact URL and integrity set.

    Given the provided inputs, attempts to resolve a distribution config payload
    which includes an artifact URL and integrity values. If no matching artifact
    can be located, an error is thrown.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        component: Component to download; if downloading a JDK, `None` is expected.
        strict: Fail if the component cannot be found.

    Returns:
        Distribution artifact config payload, or throws.
    """

    target_key = _generate_distribution_coordinate(dist, platform, version, component)
    config = _GRAALVM_BINDIST.get(target_key)
    if config == None and strict:
        fail("Failed to resolve distribution artifact at key '" + target_key + "'")
    return config

# Generated mappings.
_GRAALVM_BINDIST = {
    "ce_17.0.8_linux-aarch64_23.0.1": {
        # GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.8/graalvm-community-jdk-17.0.8_linux-aarch64_bin.tar.gz",
        "sha256": "c4f26318114d6bd125cc95ee070289afdd42c6683867adf832f2ab2819c3b685",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_linux-aarch64_espresso_23.0.1": {
        # Espresso for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "a2d56cba5b09e2466572cf4c7c82541b4b53777b2d83a9585680113abc8453ad",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_17.0.8_linux-aarch64_js_23.0.1": {
        # GraalJs for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "6a5bd10b0e98099d6884191e24e7be40292278dd178151ebc3b77d1be7f65d75",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_17.0.8_linux-aarch64_llvm_23.0.1": {
        # Sulong for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "2b23869f9d599c8f8e89635f7f0a471d3bc55b8f4f5641d628c082f257af9f55",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_17.0.8_linux-aarch64_native-image_23.0.1": {
        # Native Image for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "9ba10c81e353f0f5629b69a34b65a02c1211db64a2882c14938a5978859c5bb2",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_linux-aarch64_python_23.0.1": {
        # GraalPython for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "762b8e28ec573ee406c83e3d1e6247f9c986af37efeac7b702a0ec53f2b4a005",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_17.0.8_linux-aarch64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "2bfd23d2afc1d2a7db38b5bea9ba1dca72e570ee854fc26b038ec8747ae30ef7",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_17.0.8_linux-aarch64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java17-linux-aarch64-23.0.1.jar",
        "sha256": "4bb13c1a905804b50ef3bdba510d44d95e9f59746ad9a71c4f82c976d820e6c1",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_17.0.8_linux-x64_23.0.1": {
        # GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.8/graalvm-community-jdk-17.0.8_linux-x64_bin.tar.gz",
        "sha256": "1dffdf5c7cc5bf38558e9f093eef6a14072a6dff0be3a9906208b37b53ecc009",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_linux-x64_espresso_23.0.1": {
        # Espresso for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "6a719ea20204686d88fbdcffa6c1cb56192c8e0188f68327cf3380468f770d1e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_17.0.8_linux-x64_js_23.0.1": {
        # GraalJs for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "2d97b131192063a1071bb82c8181722b970a874671814a3e3c70d7bc2df1fcee",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_17.0.8_linux-x64_llvm_23.0.1": {
        # Sulong for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "4353554eeda7871895f9b4b6053dc15cf42e7544498230a7cac2707df74eea78",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_17.0.8_linux-x64_native-image_23.0.1": {
        # Native Image for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "e10aebfe396b361e100944ede746316f5e78d15f0853b504863142e755e38fa9",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_linux-x64_python_23.0.1": {
        # GraalPython for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "a8f64aab9439d94f503f5a7d45a820700e52f660c7050214159945bbfb5895a5",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_17.0.8_linux-x64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "b63db35ef339919bd6205901d08fbad1cbe0b4073dfa5ad2544b73eac6d496bb",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_17.0.8_linux-x64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java17-linux-amd64-23.0.1.jar",
        "sha256": "57dc185a704675bc7e8fd96dd7eee8cf2ae50385fd5e8c07a270fe4500ec5f35",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_17.0.8_macos-aarch64_23.0.1": {
        # GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.8/graalvm-community-jdk-17.0.8_macos-aarch64_bin.tar.gz",
        "sha256": "89209bbf8346d8dd0847d431bd8654db7d4ff634745207f20af2045c4869fb49",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_macos-aarch64_espresso_23.0.1": {
        # Espresso for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "636e36ccb4fd4b62fba170adef35384211b73c2e7c079ab803cd2a69604ae496",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_17.0.8_macos-aarch64_js_23.0.1": {
        # GraalJs for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "3b19891a47f47ce54b0a98908fb368a68278eb5bde3f2e6ed4d71a5d64182eef",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_17.0.8_macos-aarch64_llvm_23.0.1": {
        # Sulong for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "d6218402ca6ae453becf1de41ff28a81bb66c6a34064773166808a5260894955",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_17.0.8_macos-aarch64_native-image_23.0.1": {
        # Native Image for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "e53efea01d2aeb006b7d234271dc54e8d1b2274b3ad55d83b368bac786533951",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_macos-aarch64_python_23.0.1": {
        # GraalPython for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "6f2719a30c117fcaa060c0fa46a66eb4df8bf7a18c5e27c729cf31e5a7c5036c",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_17.0.8_macos-aarch64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "3f488f5a4728a0cc34507a4152c9abc8a9e476de755e5d8ba407ce72442e869a",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_17.0.8_macos-aarch64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "e5f5de6a0a8a30d8b8a657802fe84f4a9eefe2f7ad29d997022771524d8de100",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_17.0.8_macos-x64_23.0.1": {
        # GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.8/graalvm-community-jdk-17.0.8_macos-x64_bin.tar.gz",
        "sha256": "cf4bb646018da8bf93f67e5cdae0f583b276d278d0b667d779a68d11d3b6873d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_macos-x64_espresso_23.0.1": {
        # Espresso for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "81270d66f73d80d1d2cebc892790438413c9f7f0c91997eb482e8862bc3b8a42",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_17.0.8_macos-x64_js_23.0.1": {
        # GraalJs for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "0179b7daf431196431dc7c58bba52fc69aafd224eea5719957f7fe6c4ba1535e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_17.0.8_macos-x64_llvm_23.0.1": {
        # Sulong for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "52e77081875aa63e8ec490d6081c388dd8b164c11d68346122bdb51b6f0ec842",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_17.0.8_macos-x64_native-image_23.0.1": {
        # Native Image for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "b0dcd0f1560acee915e5f412b018ee8292643ec33db4477730b0bf52c187e96d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_macos-x64_python_23.0.1": {
        # GraalPython for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "0403ca9b98440ce3d2a8e312f13835b3e7c1ad9c6b4881b840484e5f14605214",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_17.0.8_macos-x64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "744e808875db7c5c83ca2001ea3e85e925b349ba0a9d4046cafd7d099d0e8bf6",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_17.0.8_macos-x64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java17-darwin-amd64-23.0.1.jar",
        "sha256": "af2c15909a3a1636e3a8135e876cd9c9190ede304cb79add237a30a27e314376",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_17.0.8_windows-x64_23.0.1": {
        # GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.8/graalvm-community-jdk-17.0.8_windows-x64_bin.zip",
        "sha256": "31e60e416b015057a7826fa489ac9753261e815a525fa362f8a770a3d0a364b0",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_windows-x64_espresso_23.0.1": {
        # Espresso for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java17-windows-amd64-23.0.1.jar",
        "sha256": "8ba5915da48086fc068cd50bad63e85e67782342c6e999bac49222d0ed837991",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_17.0.8_windows-x64_js_23.0.1": {
        # GraalJs for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java17-windows-amd64-23.0.1.jar",
        "sha256": "ba912ff5773b1d5dc1f6893d1a3730586bbcfd2bbd6a1a0c471c4b259e49e35e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_17.0.8_windows-x64_llvm_23.0.1": {
        # Sulong for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java17-windows-amd64-23.0.1.jar",
        "sha256": "ffecc678d5d34248c961e114145cec62338d0601d6ee9a8f417f60016fbaa3f1",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_17.0.8_windows-x64_native-image_23.0.1": {
        # Native Image for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java17-windows-amd64-23.0.1.jar",
        "sha256": "9a8ce72275e44608d96f9242948356421a37d37707ff43e9b2e0ab762635a205",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.8_windows-x64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java17-windows-amd64-23.0.1.jar",
        "sha256": "a5db5e10dd596e2ca79ca6ecc1a1f2b25cc4ccc8bbe890c982cbd9ace9c1ab26",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_20.0.2_linux-aarch64_23.0.1": {
        # GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.2/graalvm-community-jdk-20.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "6022709c124191da5087d0b0c62c3246943b3d5a386717c8d1af593637217028",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_linux-aarch64_espresso_23.0.1": {
        # Espresso for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "899c736b59aa0fe354630a812f24b5944e3c0e22286e7be3db14ac0bcb88778e",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_20.0.2_linux-aarch64_js_23.0.1": {
        # GraalJs for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "799d6be66923801583fa20f8ea0ee2ad537fe11b1c194930621035adeb47d3aa",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_20.0.2_linux-aarch64_llvm_23.0.1": {
        # Sulong for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "03696746a6ca7150bb55fa1adc6a97bfe3310dc4af87e3e58b399dea9e15caa7",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_20.0.2_linux-aarch64_native-image_23.0.1": {
        # Native Image for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "943147b239c95495f514488b441aab495f68f4de39e5e55a2bd2a3045eea389a",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_linux-aarch64_python_23.0.1": {
        # GraalPython for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "7814163acd96c89b76cbce66091de8da43d42a6ff05a751bf165ca60f548bcb3",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_20.0.2_linux-aarch64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "90862e8cc1d1653b8253e6147365e8bfba98d82d0fbf48c9c8142796cea334b7",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_20.0.2_linux-aarch64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java20-linux-aarch64-23.0.1.jar",
        "sha256": "cfdf7a38e2cdeae94ebe4aab70f9a3f57306faac48b248c8b1d6227a5163c7ac",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_20.0.2_linux-x64_23.0.1": {
        # GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.2/graalvm-community-jdk-20.0.2_linux-x64_bin.tar.gz",
        "sha256": "941a85a690e7b1c4e1fcfac321561ca46033bba3ac4882dd15d4f45edd06726c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_linux-x64_espresso_23.0.1": {
        # Espresso for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "5072bf466f52f4c0e71378bee755139e758ce759d2ccae14beb424734496aa74",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_20.0.2_linux-x64_js_23.0.1": {
        # GraalJs for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "372dda758e2feae88029f3e23d319127ed08e0392272f02d30333e2ae3199b5a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_20.0.2_linux-x64_llvm_23.0.1": {
        # Sulong for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "045f4e4568caff567f7dd30888f88a06a5e593789152f3135a02bda273920640",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_20.0.2_linux-x64_native-image_23.0.1": {
        # Native Image for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "702468f86a1a3025d81f04b0ff4aaed8d65da3204456953552378e6cbbd4d922",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_linux-x64_python_23.0.1": {
        # GraalPython for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "c0afd164f64efc368680ff8690651c3e6e0fd5256d360a2a51c86a82469f93e4",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_20.0.2_linux-x64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "22161003e0fa238ab5b94a6722ce9c7359c0ba0c1c37f0d0d8ae30fdabc57d7e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_20.0.2_linux-x64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java20-linux-amd64-23.0.1.jar",
        "sha256": "aed4f0103742f1ee54c789f162d55debdf3bbfa0dd720f978dfebd262890a07d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_20.0.2_macos-aarch64_23.0.1": {
        # GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.2/graalvm-community-jdk-20.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "96e2227c4319ecb5eed755f8abb1411a56f51dd8f30e9770127bcd1cce2cd644",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_macos-aarch64_espresso_23.0.1": {
        # Espresso for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "462f014888234fa5b0f46b6dc8fb9a510c956b616095d1a411c8ef13087c032a",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_20.0.2_macos-aarch64_js_23.0.1": {
        # GraalJs for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "643807def4fc5c67e3a17ce0b1edc848fff9fd99b49bb4989f9431171d3f9e7f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_20.0.2_macos-aarch64_llvm_23.0.1": {
        # Sulong for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "aebb1384dc4ba84abd9884d477df5257eb581f7b6388006c83f3eb2697343601",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_20.0.2_macos-aarch64_native-image_23.0.1": {
        # Native Image for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "d5a9e6c10429cd0762273971a7bf928bfaa3832bb170d2c3f19a980eb062ccf1",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_macos-aarch64_python_23.0.1": {
        # GraalPython for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "7ad19652becc6406a172afc747dae7bb4d32ba7f66e5c90b7487ea6147d7f7f2",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_20.0.2_macos-aarch64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "ddfc260b9ecccaa52e84a784acb86002756d11c70183662838311572b33ebb66",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_20.0.2_macos-aarch64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "abd923b90fd9e46d5da39873bded91b9a344c47727ca74a2ad2aac054c4109ce",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_20.0.2_macos-x64_23.0.1": {
        # GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.2/graalvm-community-jdk-20.0.2_macos-x64_bin.tar.gz",
        "sha256": "5e57fffa27282f27976a07d27611256ea4219f02756612fe500a5ff80ed5fc2a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_macos-x64_espresso_23.0.1": {
        # Espresso for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "a43cc9ce68a252752d2deef44e5ab5be2a51cb910dc7a3b91824fb7e02fcc449",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_20.0.2_macos-x64_js_23.0.1": {
        # GraalJs for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "6da0d5807d16a7d2d71c74b2ccbdde915983a98a78653146737468c387a802bd",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_20.0.2_macos-x64_llvm_23.0.1": {
        # Sulong for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "6af2fcfcbae803eb8759709508c80b50299449c75d7dfec01d627d313ad19987",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_20.0.2_macos-x64_native-image_23.0.1": {
        # Native Image for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "d3bbaa3c3c562f4f11a3a0f75e0aa7e0162d6aad4e104558ce6ce125b5081c9a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_macos-x64_python_23.0.1": {
        # GraalPython for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graalpython/releases/download/graal-23.0.1/python-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "cf77cae5a2b484f47fbf760ac33854ad281b843e772d2c4ba4605bed7e993d37",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/python",
        ],
    },
    "ce_20.0.2_macos-x64_ruby_23.0.1": {
        # TruffleRuby for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/oracle/truffleruby/releases/download/graal-23.0.1/ruby-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "7b30b5a0a2c8509808d366c12272263d98c078e62a44dbbc43b6a4f289bc9ef7",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/ruby",
        ],
    },
    "ce_20.0.2_macos-x64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java20-darwin-amd64-23.0.1.jar",
        "sha256": "fc67b654f13c6ed5024f6611ff1ae41b08580c0baf98c338495dcd11f03462bc",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "ce_20.0.2_windows-x64_23.0.1": {
        # GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.2/graalvm-community-jdk-20.0.2_windows-x64_bin.zip",
        "sha256": "457708cf7c5fbc88dc62f17f19223b62f29cc723243e6076a18953236e1a0899",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_windows-x64_espresso_23.0.1": {
        # Espresso for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-installable-svm-java20-windows-amd64-23.0.1.jar",
        "sha256": "eb9e125bb75319ab1543d7fe1950c87cef56aa789a1246323e95354328c9d3f2",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/java",
        ],
    },
    "ce_20.0.2_windows-x64_js_23.0.1": {
        # GraalJs for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/oracle/graaljs/releases/download/graal-23.0.1/js-installable-svm-java20-windows-amd64-23.0.1.jar",
        "sha256": "65239e60132e3314d7077d9eda1a229e6a52c21aa5f349f615a33c99bc96d896",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/javascript",
        ],
    },
    "ce_20.0.2_windows-x64_llvm_23.0.1": {
        # Sulong for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-installable-svm-java20-windows-amd64-23.0.1.jar",
        "sha256": "6bd092fec0121b6ab389fe0578b3a054028d7cf5a92ab251e8edab1dd8e7d834",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/llvm",
        ],
    },
    "ce_20.0.2_windows-x64_native-image_23.0.1": {
        # Native Image for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/native-image-installable-svm-java20-windows-amd64-23.0.1.jar",
        "sha256": "2b35275d491797a0bd427ffa7e4fb7ca829b0c5e9db1f355031331f59c1e2c55",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.2_windows-x64_wasm_23.0.1": {
        # GraalWasm for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/wasm-installable-svm-java20-windows-amd64-23.0.1.jar",
        "sha256": "5c70c1dc418198f75adead6290bc4345ba0ccf39897f312ca8260f850a05123b",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
            "@rules_graalvm//platform/engine/wasm",
        ],
    },
    "oracle_17.0.8_linux-aarch64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-aarch64_bin.tar.gz",
        "sha256": "cd24d7b21ec0791c5a77dfe0d9d7836c5b1a8b4b75db7d33d253d07caa243117",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_linux-x64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-x64_bin.tar.gz",
        "sha256": "74b528a33bb2dfa02b4d74a0d66c9aff52e4f52924ce23a62d7f9eb1a6744657",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_macos-aarch64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://download.oracle.com/java/17/archive/jdk-17.0.8_macos-aarch64_bin.tar.gz",
        "sha256": "89f26bda33262d70455e774b55678fc259ae4f29c0a99eb0377d570507be3d04",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_macos-x64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://download.oracle.com/java/17/archive/jdk-17.0.8_macos-x64_bin.tar.gz",
        "sha256": "ddc4928be11642f35b3cb1e6a56463032705fccb74e10ed5a67a73a5fc7b639f",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_windows-x64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://download.oracle.com/java/17/archive/jdk-17.0.8_windows-x64_bin.zip",
        "sha256": "98385c1fd4db7ad3fd7ca2f33a1fadae0b15486cfde699138d47002d7068084a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_20.0.2_linux-aarch64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://download.oracle.com/java/20/archive/jdk-20.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "ee572da97526bd55c07181fc6f5b16130d45fbc7d1e2feda966d2588ea4ac708",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_linux-x64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://download.oracle.com/java/20/archive/jdk-20.0.2_linux-x64_bin.tar.gz",
        "sha256": "499b59be8e3613c223e76f101598d7c28dc04b8e154d860edf2ed05980c67526",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_macos-aarch64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://download.oracle.com/java/20/archive/jdk-20.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "e8718838c2011bab3ab00eb8097ddb20aa3b8fe0a8bb0b9e3c9d801c973477bc",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_macos-x64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://download.oracle.com/java/20/archive/jdk-20.0.2_macos-x64_bin.tar.gz",
        "sha256": "8a0484e95b40a95f65c0a498a5b299e80757343f0ff1cc1ec43fc5249468bedb",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_windows-x64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://download.oracle.com/java/20/archive/jdk-20.0.2_windows-x64_bin.zip",
        "sha256": "79a227ca670e5594560f6caeec26bf466143612d048e7f5b0ad2c3770d465ea6",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
}

# Exports.

# buildifier: disable=name-conventions
DistributionType = _DistributionType

# buildifier: disable=name-conventions
DistributionPlatform = _DistributionPlatform

# buildifier: disable=name-conventions
DistributionComponent = _DistributionComponent

# buildifier: disable=name-conventions
ComponentDependencies = _ComponentDependencies

# buildifier: disable=name-conventions
AlignedVersions = _AlignedVersions

# buildifier: disable=name-conventions
VmReleaseVersions = _VmReleaseVersions

generate_distribution_coordinate = _generate_distribution_coordinate
resolve_distribution_artifact = _resolve_distribution_artifact
