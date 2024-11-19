"Binary mappings for GraalVM distribution artifacts."

# ! THIS FILE IS GENERATED. DO NOT EDIT. !

# Last updated: 2024-09-29T13:05PDT by sam

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
_ComponentDependencies = {
    "regex": [_DistributionComponent.ICU4J],
    "js": [_DistributionComponent.ICU4J, _DistributionComponent.REGEX],
    "python": [_DistributionComponent.LLVM],
    "ruby": [_DistributionComponent.LLVM],
    "llvm-toolchain": [_DistributionComponent.LLVM],
}

# Aligned GraalVM distribution versions.
# buildifier: disable=name-conventions
_AlignedVersions = {
    "23.0.1": "24.1.1",
    "23.0.0": "24.1.0",
    "22.0.2": "24.0.2",
    "22.0.1": "24.0.1",
    "22.0.0": "24.0.0",
    "21.0.2": "23.1.2",
    "21.0.1": "23.1.1",
    "21.0.0": "23.1.0",
    "20.0.2": "23.0.1",
    "20.0.1": "23.0.1",
    "17.0.8": "23.0.1",
    "17.0.7": "23.0.1",
}

# VM release versions for calculating prefixes.
# buildifier: disable=name-conventions
_VmReleaseVersions = {
    "24.1.1": "23.0.1+11.1",
    "24.1.0": "23+37.1",
    "24.0.2": "22.0.2+9.1",
    "24.0.1": "22.0.1+8.1",
    "24.0.0": "22+36.1",
    "23.1.2": "21.0.2+13.1",
    "21.0.2": "21.0.2+13.1",
    "21.0.1": "21.0.1+12.1",
    "23.1.1": "21.0.1+12.1",
    "23.1.0": "21+35.1",
    "23.0.1": "23.0.1+11.1",
    "23.0.0": "23+37.1",
    "22.0.2": "22.0.2+9.1",
    "22.0.1": "22.0.1+8.1",
    "22.0.0": "22+36.1",
    "21.0.0": "21+35.1",
    "20.0.2": "20.0.2+9.1",
    "20.0.1": "20.0.1+9.1",
    "17.0.8": "17.0.8+7.1",
    "17.0.7": "17.0.7+7.1",
}

# VM release versions (for Oracle GVM) for calculating prefixes.
# buildifier: disable=name-conventions
_VmReleaseVersionsOracle = {
    "24.1.1": "23.0.1+11.1",
    "24.1.0": "23+37.1",
    "24.0.2": "22.0.2+9.1",
    "24.0.1": "22.0.1+8.1",
    "24.0.0": "22+36.1",
    "23.1.2": "21.0.2+13.1",
    "21.0.2": "21.0.2+13.1",
    "21.0.1": "21.0.1+12.1",
    "23.1.1": "21.0.1+12.1",
    "23.1.0": "21+35.1",
    "23.0.1": "23.0.1+11.1",
    "23.0.0": "23+37.1",
    "22.0.2": "22.0.2+9.1",
    "22.0.1": "22.0.1+8.1",
    "22.0.0": "22+36.1",
    "21.0.0": "21+35.1",
    "20.0.2": "20.0.2+9.1",
    "20.0.1": "20.0.1+9.1",
    "17.0.8": "17.0.8+9.1",
    "17.0.7": "17.0.8+9.1",
}

def _generate_distribution_coordinate(dist, platform, version, java_version, component = None):
    """Generate a well-formed distribution coordinate key.

    Generates a key for the generated binary distribution map, which holds download
    URLs and known-good integrity values.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        java_version: Intended/requested Java version.
        component: Component to download; if downloading a JDK, `None` is expected.

    Returns:
        Generated distribution coordinate key.
    """

    aligned_version = None
    if version == "23.1.0" and java_version == "21":
        version = "21.0.0"
        aligned_version = "23.1.0"
    elif version == "24.0.0" and java_version == "22":
        version = "22.0.0"
        aligned_version = "24.0.0"
    elif version == "24.0.1" and java_version == "22":
        version = "22.0.1"
        aligned_version = "24.0.1"
    elif version == "24.0.2" and java_version == "22":
        version = "22.0.2"
        aligned_version = "24.0.2"
    elif version == "24.1.0" and java_version == "23":
        version = "23.0.0"
        aligned_version = "24.1.0"
    elif version == "24.1.1" and java_version == "23":
        version = "23.0.1"
        aligned_version = "24.1.1"

    segments = [
        dist,
        version,
        platform,
    ]
    if component != None:
        segments.append(component)

    segments.append(aligned_version or _AlignedVersions.get(version, version))

    # format:  `<dist>_<rlse>_<platfrm>_<vrsn>`
    # example: `oracle_20.0.2_linux-x64_23.0.1`
    return "_".join(segments)

def _resolve_distribution_artifact(dist, platform, version, java_version, component = None, strict = True):
    """Resolve a distribution artifact URL and integrity set.

    Given the provided inputs, attempts to resolve a distribution config payload
    which includes an artifact URL and integrity values. If no matching artifact
    can be located, an error is thrown.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        java_version: Intended/requested Java version.
        component: Component to download; if downloading a JDK, `None` is expected.
        strict: Fail if the component cannot be found.

    Returns:
        Distribution artifact config payload, or throws.
    """

    if dist == None:
        fail("Cannot calculate GraalVM artifact coordinate with `None` as `dist`")
    if platform == None:
        fail("Cannot calculate GraalVM artifact coordinate with `None` as `platform`")
    if version == None:
        fail("Cannot calculate GraalVM artifact coordinate with `None` as `version`")

    target_key = _generate_distribution_coordinate(dist, platform, version, java_version, component)
    config = _GRAALVM_BINDIST.get(target_key)
    if config == None and strict:
        fail("Failed to resolve distribution artifact at key '" + target_key + "'")
    return config

# Generated mappings.
_GRAALVM_BINDIST = {
    "ce_17.0.7_linux-aarch64_23.0.1": {
        # GraalVM CE 17.0.7 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.7/graalvm-community-jdk-17.0.7_linux-aarch64_bin.tar.gz",
        "sha256": "cb5bedf6244d30018856559a393029e98de48c9608eb35ec6c4937dcb7d97224",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.7_linux-x64_23.0.1": {
        # GraalVM CE 17.0.7 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.7/graalvm-community-jdk-17.0.7_linux-x64_bin.tar.gz",
        "sha256": "094e5a7dcc4a903b70741d5c3c1688f83e83e2d44eb3d8d798c5d79ed902032c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.7_macos-aarch64_23.0.1": {
        # GraalVM CE 17.0.7 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.7/graalvm-community-jdk-17.0.7_macos-aarch64_bin.tar.gz",
        "sha256": "05d9a51786c578cea346760b3ec3af3721780afb850b739407a2a123f5d081fd",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.7_macos-x64_23.0.1": {
        # GraalVM CE 17.0.7 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.7/graalvm-community-jdk-17.0.7_macos-x64_bin.tar.gz",
        "sha256": "7b38776fc9259af5b9b02ffa21d8c7bf3991fa29bc689d6d1a10a305cd8f50af",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "ce_17.0.7_windows-x64_23.0.1": {
        # GraalVM CE 17.0.7 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.7/graalvm-community-jdk-17.0.7_windows-x64_bin.zip",
        "sha256": "1fa8d5f56e7d2bbc3033e7f1f562d9ff0d07431436ca7d781c40c5433eedd348",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
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
    "ce_17.0.8_linux-aarch64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java17-linux-aarch64-23.0.1.jar",
        "sha256": "175305109fcf0f3212ea878853060099fdf3d3225546dd6b96337ff0d2d4454e",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_17.0.8_linux-aarch64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java17-linux-aarch64-23.0.1.jar",
        "sha256": "0327e0f65acdd147da7cce70a422c69da52d1b60e24c49a54b997d85dc54088f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_17.0.8_linux-aarch64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java17-linux-aarch64-23.0.1.jar",
        "sha256": "6309c8ea3be3f687394393ed14937a084dd0905cef2e8f075fc67d6caeef4f11",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_linux-x64_espresso-llvm_23.0.1": {
        # Espresso for LLVM for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-llvm-installable-ce-java17-linux-amd64-23.0.1.jar",
        "sha256": "c4b480db48c34d351e7e7af70f24c6fb575b318f1477ea935fc2593fba58365d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_linux-x64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java17-linux-amd64-23.0.1.jar",
        "sha256": "3fb44c9051a04997dcf8cd1cc04af0feb09ed0f1b0b325a4f767319aafc01a2c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_17.0.8_linux-x64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java17-linux-amd64-23.0.1.jar",
        "sha256": "3d0cfc56e4c5329bfa66b907e5115f7c0bd14c8230eb0ebfda44f101bc203294",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_17.0.8_linux-x64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java17-linux-amd64-23.0.1.jar",
        "sha256": "770852489943f3d8d29c7cae5ba99c0e309e023501881243fa86ab4d2f8cc13c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_macos-aarch64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "afbd7a7c5ced38d17216d31e4ef67fa9b48621d6662a3c847935b13a87e8746e",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_17.0.8_macos-aarch64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "03f47877f37b3244fbc2bc1c9cae568ffd9fc359c6736deb4323b8e9542ed5cb",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_17.0.8_macos-aarch64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java17-darwin-aarch64-23.0.1.jar",
        "sha256": "7b094bc8f0aa3b8011d2f9db2540e887a2fb31fc4b68db2caab8c3c6be4f761f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_macos-x64_espresso-llvm_23.0.1": {
        # Espresso for LLVM for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-llvm-installable-ce-java17-darwin-amd64-23.0.1.jar",
        "sha256": "11c6e6cd5f32681bfd648f842ff5f6b6e8fd527869024ce0807c4466f2acf63c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_macos-x64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java17-darwin-amd64-23.0.1.jar",
        "sha256": "3c7d6855061005738546701d500c8ab6b6033d566b9a7566030a6e22c8ce264d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_17.0.8_macos-x64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java17-darwin-amd64-23.0.1.jar",
        "sha256": "62e5630ea54f2002c021a04eaafeefba5c841fee44c680de6a2cebc0361b9d91",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_17.0.8_macos-x64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java17-darwin-amd64-23.0.1.jar",
        "sha256": "3903e7d347b0e7d183bb69c52e0e81d9085146cdf96c509ff085dc8a22ebb456",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_windows-x64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java17-windows-amd64-23.0.1.jar",
        "sha256": "99a13a292bf812252192bee1a086aeb680db6f8c37ed591e7051968e5d241642",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_17.0.8_windows-x64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java17-windows-amd64-23.0.1.jar",
        "sha256": "2074a65247af1e9352340a46245e9d317404fbc21534ee4ab6dcc01b56746333",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
        "dependencies": [
            "llvm",
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
    "ce_17.0.8_windows-x64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java17-windows-amd64-23.0.1.jar",
        "sha256": "87cc80b283ffaca0a1f165978807c6cd04f1666b0168d5a6cc22a29ef33deb6e",
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
    "ce_20.0.1_linux-aarch64_23.0.1": {
        # GraalVM CE 20.0.1 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.1/graalvm-community-jdk-20.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "ffb205a6fc0b84cbc5d38e86ce12fe01294ba1507c1a72535f63a57c57513a35",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.1_linux-x64_23.0.1": {
        # GraalVM CE 20.0.1 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.1/graalvm-community-jdk-20.0.1_linux-x64_bin.tar.gz",
        "sha256": "1c965f4698a5435bb8d094c9b2a13f7079e43d9934915964a2ee15fb81b53a79",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.1_macos-aarch64_23.0.1": {
        # GraalVM CE 20.0.1 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.1/graalvm-community-jdk-20.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "be18d18f1fb805a0a3185c3eb6f08d6f7c93172025d8c8bd16c2a70b5105e28c",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.1_macos-x64_23.0.1": {
        # GraalVM CE 20.0.1 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.1/graalvm-community-jdk-20.0.1_macos-x64_bin.tar.gz",
        "sha256": "0baffa8076049915c93e97f61ea9528959c6d30e9f03943c71a7b995fc73e36d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_20.0.1_windows-x64_23.0.1": {
        # GraalVM CE 20.0.1 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.1/graalvm-community-jdk-20.0.1_windows-x64_bin.zip",
        "sha256": "5729ab19ce27a25c12640c530d2d898a51f1a9075cbc3ca7793438044c7e0e41",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
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
    "ce_20.0.2_linux-aarch64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java20-linux-aarch64-23.0.1.jar",
        "sha256": "b938f54036d4179f062fbd236f001691136ace1589657b2a3f53239a6b8a0c4b",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_20.0.2_linux-aarch64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java20-linux-aarch64-23.0.1.jar",
        "sha256": "9a72562bf8995bd78e2d988f4a2b35e9db0eb8c400c6958e48b94d372245926f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_20.0.2_linux-aarch64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java20-linux-aarch64-23.0.1.jar",
        "sha256": "8d0ebfda4c1f8c0a291b1bc7fc5c3a3b04ae0e7c1ee3e3f1cafc649e0a9bb3fb",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_linux-x64_espresso-llvm_23.0.1": {
        # Espresso for LLVM for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-llvm-installable-ce-java20-linux-amd64-23.0.1.jar",
        "sha256": "a94022b12269b4b1e2d54fab24f855204bfa7622a07004fc4f5506c0528eec11",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_linux-x64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java20-linux-amd64-23.0.1.jar",
        "sha256": "dafb348bffa09d1538c9c97a320785d3d2cc6c94dc345f1a84a9372a5626dc7c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_20.0.2_linux-x64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java20-linux-amd64-23.0.1.jar",
        "sha256": "08acbfcd274e461abb255f1ab156fc873d2f05dc8844995d7f43ddb16369e459",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_20.0.2_linux-x64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java20-linux-amd64-23.0.1.jar",
        "sha256": "1b34edf86d4a378bcf00029083da620547c6cc022cfb677b26c1a3946df38dab",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_macos-aarch64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "ce22497e3e2c16ca3db46c58290d620033fda8559d4f696ae138c6ce077b1d7c",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_20.0.2_macos-aarch64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "803d667c4ef9f3749a1758bbeed73951afbc742eff2a4565e7eca7e1a4696fd9",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_20.0.2_macos-aarch64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java20-darwin-aarch64-23.0.1.jar",
        "sha256": "b2e3e3f3054337c2e7b194d557e177b839a2915e505218a574a7a9926e326d08",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_macos-x64_espresso-llvm_23.0.1": {
        # Espresso for LLVM for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/espresso-llvm-installable-ce-java20-darwin-amd64-23.0.1.jar",
        "sha256": "50680a349607300792edcafbdd74f33b612f1a2d47090fddbdfefd21b6811514",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_macos-x64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java20-darwin-amd64-23.0.1.jar",
        "sha256": "40c72a79d3665a658367a71030bb0a22e526c754ebcb7d05a89d10bfa24aec7a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_20.0.2_macos-x64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java20-darwin-amd64-23.0.1.jar",
        "sha256": "6d74c09981caced673c9d9ff053320f5c31ed81e479ecf01cc512561e61c5ac8",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
        "dependencies": [
            "llvm",
        ],
    },
    "ce_20.0.2_macos-x64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java20-darwin-amd64-23.0.1.jar",
        "sha256": "e1df45e8a2d0a16e68fa0f1a277dfdaa9c50e07537395884a4c802b4600ae027",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_windows-x64_icu4j_23.0.1": {
        # ICU4j for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/icu4j-installable-ce-java20-windows-amd64-23.0.1.jar",
        "sha256": "9160df43f6fce928b3671d59f9d611bb1c3bed3952c60eb28ecdd08d5f1560ab",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
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
        "dependencies": [
            "icu4j",
            "regex",
        ],
    },
    "ce_20.0.2_windows-x64_llvm-toolchain_23.0.1": {
        # LLVM Toolchain for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/llvm-toolchain-installable-ce-java20-windows-amd64-23.0.1.jar",
        "sha256": "7b3c977c179b1b0252dda2f38e71f663f6243ca89c2ea50d7643ce18119a5e01",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
        ],
        "dependencies": [
            "llvm",
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
    "ce_20.0.2_windows-x64_regex_23.0.1": {
        # TruffleRegex for GraalVM CE 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/graal-23.0.1/regex-installable-ce-java20-windows-amd64-23.0.1.jar",
        "sha256": "4646722b78da6213fa6094f7dabfdbbb1d9ee490bc30834b7dac846ec0a2d622",
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
    "oracle_17.0.7_linux-aarch64_23.0.1": {
        # Oracle GraalVM 17.0.7 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.7_linux-aarch64_bin.tar.gz",
        "sha256": "73256df1af0507f8cb230bafe506e4dcaba2b3e6d8bb1324bf5a02198890ef97",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.7_linux-x64_23.0.1": {
        # Oracle GraalVM 17.0.7 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.7_linux-x64_bin.tar.gz",
        "sha256": "93db5fd373fc8eb5a5578387f7646cfd414b82e8cfaf9dbcd0145ceae0137398",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.7_macos-aarch64_23.0.1": {
        # Oracle GraalVM 17.0.7 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.7_macos-aarch64_bin.tar.gz",
        "sha256": "cb45f6585ef02134a6a6ffb6de20db96197486ffef8821ad97b11fe2fc0c23b8",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.7_macos-x64_23.0.1": {
        # Oracle GraalVM 17.0.7 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.7_macos-x64_bin.tar.gz",
        "sha256": "905255762546c69e3bb8d815a5d20e2e3cfa5332b868ab90af7aa0afe21e74ea",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.7_windows-x64_23.0.1": {
        # Oracle GraalVM 17.0.7 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.7_windows-x64_bin.zip",
        "sha256": "1ef3705fef76554bba792075df2f206237bd9d8603a4fc5ebb45a67ceb1e20d9",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_linux-aarch64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), Linux (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.8_linux-aarch64_bin.tar.gz",
        "sha256": "10cb0b61571befb20bf7c11ac4e10ff4e4801065a64ae425b39f34d401e352b1",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_linux-x64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), Linux (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.8_linux-x64_bin.tar.gz",
        "sha256": "2d6696aa209daa098c51fefc51906aa7bf0dbe28dcc560ef738328352564181b",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_macos-aarch64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), macOS (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.8_macos-aarch64_bin.tar.gz",
        "sha256": "c73d2917c1b681679d90a7e3851b553c328e4028137e19adb301040fe0d43cfd",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_macos-x64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), macOS (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.8_macos-x64_bin.tar.gz",
        "sha256": "325c1c5adce1e8b569e87f1e4dffe852f73e7c25e720ea15977f2ca1d7dba1bb",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_17.0.8_windows-x64_23.0.1": {
        # Oracle GraalVM 17.0.8 (Java 17), Windows (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.8_windows-x64_bin.zip",
        "sha256": "ea90259f08c7e358bed62c2b48d68d295aa7be38ab3cb922d74bab284e717f64",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java17",
        ],
    },
    "oracle_20.0.1_linux-aarch64_23.0.1": {
        # Oracle GraalVM 20.0.1 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "f1c175018acd6e9976a7374420e44b8c55b5871c2b0452435aba8a136fe8caae",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.1_linux-x64_23.0.1": {
        # Oracle GraalVM 20.0.1 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.1_linux-x64_bin.tar.gz",
        "sha256": "0aef42ae97bc98acbd11dce81018a7916250fced6ee9f95a934816813e48e4f4",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.1_macos-aarch64_23.0.1": {
        # Oracle GraalVM 20.0.1 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "b94877df825ccefbe8b6751e087d54aa9b8129f9d2919d29ea18e00900392da1",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.1_macos-x64_23.0.1": {
        # Oracle GraalVM 20.0.1 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.1_macos-x64_bin.tar.gz",
        "sha256": "b6f14aae4f9d6a1514446f6f2b83685e796ec083a205b613a9873b29454333ef",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.1_windows-x64_23.0.1": {
        # Oracle GraalVM 20.0.1 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.1_windows-x64_bin.zip",
        "sha256": "d5b915df33d0f959d2d51e67eb1bfa94666443b6e66fa5c7be2b4933ece3cf61",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_linux-aarch64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), Linux (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "890596363a864bdbe55c6a9678a87384e62660056b6951c385cceaae4807fbb8",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_linux-x64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), Linux (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.2_linux-x64_bin.tar.gz",
        "sha256": "242862bfd2fd2633950a8d85dd1fb4d0307c35cbc7445089aa593a931c8b17db",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_macos-aarch64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), macOS (arm64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "f1b1068672feef3dc66cba8ccccc14d623b26e284870a156bb10ea3ea51af706",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_macos-x64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), macOS (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.2_macos-x64_bin.tar.gz",
        "sha256": "72c74c3702437824cba3db3435897cce3643e9443acac59f6cfd43f9444b1004",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "oracle_20.0.2_windows-x64_23.0.1": {
        # Oracle GraalVM 20.0.2 (Java 20), Windows (amd64), Version 23.0.1
        "url": "https://download.oracle.com/graalvm/20/archive/graalvm-jdk-20.0.2_windows-x64_bin.zip",
        "sha256": "3ec83085b54a8de7d0c0ca893d225718cf6ff514f406af6d31a615da63ae9019",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java20",
        ],
    },
    "ce_21.0.0_linux-aarch64_23.1.0": {
        # GraalVM CE 21.0.0 (Java 21), Linux (arm64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.0/graalvm-community-jdk-21.0.0_linux-aarch64_bin.tar.gz",
        "sha256": "bb4e92cf7eae91e474061aeae5ae75053a65cd558dbee76947827bf54d1b30a5",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.0_linux-x64_23.1.0": {
        # GraalVM CE 21.0.0 (Java 21), Linux (amd64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.0/graalvm-community-jdk-21.0.0_linux-x64_bin.tar.gz",
        "sha256": "6c422941ccc58be5b891bb6499feeb72cd2b74d6729a29bf1fb8cc1a7d58b319",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.0_macos-aarch64_23.1.0": {
        # GraalVM CE 21.0.0 (Java 21), macOS (arm64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.0/graalvm-community-jdk-21.0.0_macos-aarch64_bin.tar.gz",
        "sha256": "c58de71e60af7970ca087cb9f5af9a8770562aee0cac99d6017b63b8c0d50f37",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.0_macos-x64_23.1.0": {
        # GraalVM CE 21.0.0 (Java 21), macOS (amd64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.0/graalvm-community-jdk-21.0.0_macos-x64_bin.tar.gz",
        "sha256": "935a32c4621d5144b4678dd135884435de3185683025cf0258dc1ed95d1f7fe1",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.0_windows-x64_23.1.0": {
        # GraalVM CE 21.0.0 (Java 21), Windows (amd64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.0/graalvm-community-jdk-21.0.0_windows-x64_bin.zip",
        "sha256": "808b65fae4ab03a2f52b5850852d7c7e098608aa8bbab918d40e8aeec870ae5f",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.0_linux-aarch64_23.1.0": {
        # Oracle GraalVM 21.0.0 (Java 21), Linux (arm64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21_linux-aarch64_bin.tar.gz",
        "sha256": "eb1eaf9d1e1e01263b0acd552552686084903ae11a9a7698a144ef8c3ee02dec",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.0_linux-x64_23.1.0": {
        # Oracle GraalVM 21.0.0 (Java 21), Linux (amd64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21_linux-x64_bin.tar.gz",
        "sha256": "be1ab3c9b08b5747b7cd577c991d25b52157cff1c8c5f290f8556c593b57a6f4",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.0_macos-aarch64_23.1.0": {
        # Oracle GraalVM 21.0.0 (Java 21), macOS (arm64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21_macos-aarch64_bin.tar.gz",
        "sha256": "c2ca434adef1e497c8a4d942ae1dbf6bbd1c8174a6fcdafc65cde0e853285300",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.0_macos-x64_23.1.0": {
        # Oracle GraalVM 21.0.0 (Java 21), macOS (amd64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21_macos-x64_bin.tar.gz",
        "sha256": "0744ab104998f8f45d9ae582134963f5d273286dff9aff586aed24f5f8434660",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.0_windows-x64_23.1.0": {
        # Oracle GraalVM 21.0.0 (Java 21), Windows (amd64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21_windows-x64_bin.zip",
        "sha256": "392acacbdae30487050968892b22ef05d2dc29b7e25816e16c5080795a813c82",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_linux-aarch64_23.1.0": {
        # GraalVM CE 21.0.1 (Java 21), Linux (arm64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "de0340929da0f3360d82d8c8ca6ea8a11499fd62ca7a182579115362575b616d",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_linux-x64_23.1.0": {
        # GraalVM CE 21.0.1 (Java 21), Linux (amd64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_linux-x64_bin.tar.gz",
        "sha256": "5283ee48a61633f59a49ecdf0ef0ab4c5a8b006c16ce95209df740bd2aee73bf",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_macos-aarch64_23.1.0": {
        # GraalVM CE 21.0.1 (Java 21), macOS (arm64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "50c42bc748e528a9702eaa66e894cf6d125a19b91f1df1c3a484bdcf02feff44",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_macos-x64_23.1.0": {
        # GraalVM CE 21.0.1 (Java 21), macOS (amd64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_macos-x64_bin.tar.gz",
        "sha256": "dafe240fb9e420cfef84ad8871b85cffc64988fd5520c4601e15b04687317a6a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_windows-x64_23.1.0": {
        # GraalVM CE 21.0.1 (Java 21), Windows (amd64), Version 23.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_windows-x64_bin.zip",
        "sha256": "18034bcfdd54319292eece7a4a669075433b76adbd6d04d32dcf23f74f7b8f0e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_linux-aarch64_23.1.0": {
        # Oracle GraalVM 21.0.1 (Java 21), Linux (arm64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "dd5a145a0550eab76b4b36c010d826ed796ef6f74a75af69fa8a4157a2431e26",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_linux-x64_23.1.0": {
        # Oracle GraalVM 21.0.1 (Java 21), Linux (amd64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_linux-x64_bin.tar.gz",
        "sha256": "1a65e2d3f90ca12fa7c534eec2e32329515d1955cf6be1c56a7e88f02af4bce2",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_macos-aarch64_23.1.0": {
        # Oracle GraalVM 21.0.1 (Java 21), macOS (arm64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "4b5ddffad649b3e64853ba230b6e8f7acd65322bb8f11852e0521ab1bb4d8b03",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_macos-x64_23.1.0": {
        # Oracle GraalVM 21.0.1 (Java 21), macOS (amd64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_macos-x64_bin.tar.gz",
        "sha256": "0647d57ec98d7aa19d2801b3ec58697d7eb44a408df511bd49d39f0150a08f87",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_windows-x64_23.1.0": {
        # Oracle GraalVM 21.0.1 (Java 21), Windows (amd64), Version 23.1.0
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_windows-x64_bin.zip",
        "sha256": "16ec0dbd1d4707870410bd59212186087a5bc126c31917e9836daed8018053c8",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_linux-aarch64_23.1.1": {
        # GraalVM CE 21.0.1 (Java 21), Linux (arm64), Version 23.1.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "de0340929da0f3360d82d8c8ca6ea8a11499fd62ca7a182579115362575b616d",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_linux-x64_23.1.1": {
        # GraalVM CE 21.0.1 (Java 21), Linux (amd64), Version 23.1.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_linux-x64_bin.tar.gz",
        "sha256": "5283ee48a61633f59a49ecdf0ef0ab4c5a8b006c16ce95209df740bd2aee73bf",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_macos-aarch64_23.1.1": {
        # GraalVM CE 21.0.1 (Java 21), macOS (arm64), Version 23.1.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "50c42bc748e528a9702eaa66e894cf6d125a19b91f1df1c3a484bdcf02feff44",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_macos-x64_23.1.1": {
        # GraalVM CE 21.0.1 (Java 21), macOS (amd64), Version 23.1.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_macos-x64_bin.tar.gz",
        "sha256": "dafe240fb9e420cfef84ad8871b85cffc64988fd5520c4601e15b04687317a6a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.1_windows-x64_23.1.1": {
        # GraalVM CE 21.0.1 (Java 21), Windows (amd64), Version 23.1.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.1/graalvm-community-jdk-21.0.1_windows-x64_bin.zip",
        "sha256": "18034bcfdd54319292eece7a4a669075433b76adbd6d04d32dcf23f74f7b8f0e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_linux-aarch64_23.1.1": {
        # Oracle GraalVM 21.0.1 (Java 21), Linux (arm64), Version 23.1.1
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "dd5a145a0550eab76b4b36c010d826ed796ef6f74a75af69fa8a4157a2431e26",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_linux-x64_23.1.1": {
        # Oracle GraalVM 21.0.1 (Java 21), Linux (amd64), Version 23.1.1
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_linux-x64_bin.tar.gz",
        "sha256": "1a65e2d3f90ca12fa7c534eec2e32329515d1955cf6be1c56a7e88f02af4bce2",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_macos-aarch64_23.1.1": {
        # Oracle GraalVM 21.0.1 (Java 21), macOS (arm64), Version 23.1.1
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "4b5ddffad649b3e64853ba230b6e8f7acd65322bb8f11852e0521ab1bb4d8b03",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_macos-x64_23.1.1": {
        # Oracle GraalVM 21.0.1 (Java 21), macOS (amd64), Version 23.1.1
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_macos-x64_bin.tar.gz",
        "sha256": "0647d57ec98d7aa19d2801b3ec58697d7eb44a408df511bd49d39f0150a08f87",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.1_windows-x64_23.1.1": {
        # Oracle GraalVM 21.0.1 (Java 21), Windows (amd64), Version 23.1.1
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.1_windows-x64_bin.zip",
        "sha256": "16ec0dbd1d4707870410bd59212186087a5bc126c31917e9836daed8018053c8",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.2_linux-aarch64_23.1.2": {
        # GraalVM CE 21.0.2 (Java 21), Linux (arm64), Version 23.1.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "a34be691ce68f0acf4655c7c6c63a9a49ed276a11859d7224fd94fc2f657cd7a",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.2_linux-x64_23.1.2": {
        # GraalVM CE 21.0.2 (Java 21), Linux (amd64), Version 23.1.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_linux-x64_bin.tar.gz",
        "sha256": "b048069aaa3a99b84f5b957b162cc181a32a4330cbc35402766363c5be76ae48",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.2_macos-aarch64_23.1.2": {
        # GraalVM CE 21.0.2 (Java 21), macOS (arm64), Version 23.1.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "515e3a93acc7e1938daba83eda4272e5495fd302d7cdd99ec7ebf408ed505ab7",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.2_macos-x64_23.1.2": {
        # GraalVM CE 21.0.2 (Java 21), macOS (amd64), Version 23.1.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_macos-x64_bin.tar.gz",
        "sha256": "7a8aa93fa45d1721908477abf4732a32637d420ffcb66ada9fb6456440b0d9e1",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_21.0.2_windows-x64_23.1.2": {
        # GraalVM CE 21.0.2 (Java 21), Windows (amd64), Version 23.1.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_windows-x64_bin.zip",
        "sha256": "e17b7bead097bf372a5c75df17815b0a2f30b777a019d25eff7706b21421f7fa",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.2_linux-aarch64_23.1.2": {
        # Oracle GraalVM 21.0.2 (Java 21), Linux (arm64), Version 23.1.2
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "dfac8d0e7ff8a128e8e8283e1ed6e3540dc44e7a9084c956e8deb9f84a268338",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.2_linux-x64_23.1.2": {
        # Oracle GraalVM 21.0.2 (Java 21), Linux (amd64), Version 23.1.2
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_linux-x64_bin.tar.gz",
        "sha256": "ee6286773c659afeefdf2f989a133e7a631c60897f2263ac183794ee1d6438f4",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.2_macos-aarch64_23.1.2": {
        # Oracle GraalVM 21.0.2 (Java 21), macOS (arm64), Version 23.1.2
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "b504f7c570836a9c6b1b92813c5123718636d0ff0f832321129a4fe3a7b9a0b3",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.2_macos-x64_23.1.2": {
        # Oracle GraalVM 21.0.2 (Java 21), macOS (amd64), Version 23.1.2
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_macos-x64_bin.tar.gz",
        "sha256": "3e24632f27be74d039508ea2b0b7862ef8c40784f55785cf6b6e40b4b28d9d53",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "oracle_21.0.2_windows-x64_23.1.2": {
        # Oracle GraalVM 21.0.2 (Java 21), Windows (amd64), Version 23.1.2
        "url": "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.2_windows-x64_bin.zip",
        "sha256": "bc5027e506775813131509247424d4af839ad23224a7787b7770ae82eeb3b32d",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java21",
        ],
    },
    "ce_22.0.0_linux-aarch64_24.0.0": {
        # GraalVM CE 22.0.0 (Java 22), Linux (arm64), Version 24.0.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.0/graalvm-community-jdk-22.0.0_linux-aarch64_bin.tar.gz",
        "sha256": "da9a0e11b110ebccff33ade502516d00f574ec3247868007e452cef4143e0904",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.0_linux-x64_24.0.0": {
        # GraalVM CE 22.0.0 (Java 22), Linux (amd64), Version 24.0.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.0/graalvm-community-jdk-22.0.0_linux-x64_bin.tar.gz",
        "sha256": "e5eeb486a23101753f18181d002c3ede9da13c463fb61d3ea448abe774db0657",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.0_macos-aarch64_24.0.0": {
        # GraalVM CE 22.0.0 (Java 22), macOS (arm64), Version 24.0.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.0/graalvm-community-jdk-22.0.0_macos-aarch64_bin.tar.gz",
        "sha256": "87b111900c5f78f919bb55103978d3b9ff44789140bb20be1c59abd23871cc86",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.0_macos-x64_24.0.0": {
        # GraalVM CE 22.0.0 (Java 22), macOS (amd64), Version 24.0.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.0/graalvm-community-jdk-22.0.0_macos-x64_bin.tar.gz",
        "sha256": "691b71450bcfea19eb5a3564f7a159072f9bd51a7a901e3a4775127da24a10d1",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.0_windows-x64_24.0.0": {
        # GraalVM CE 22.0.0 (Java 22), Windows (amd64), Version 24.0.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.0/graalvm-community-jdk-22.0.0_windows-x64_bin.zip",
        "sha256": "c4118b3b8fa81e7efe648d3caa0b694adfb34bfb9e2f168d8561db6b422f311c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.0_linux-aarch64_24.0.0": {
        # Oracle GraalVM 22.0.0 (Java 22), Linux (arm64), Version 24.0.0
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22_linux-aarch64_bin.tar.gz",
        "sha256": "d303d30c10764feaab076efe79019df3c981b0487fcac3df7a5313f76f61040e",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.0_linux-x64_24.0.0": {
        # Oracle GraalVM 22.0.0 (Java 22), Linux (amd64), Version 24.0.0
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22_linux-x64_bin.tar.gz",
        "sha256": "d1860b5b7588310e70b259c891156f6d0cbc34d0d1feec3b37169ed2a415f3c3",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.0_macos-aarch64_24.0.0": {
        # Oracle GraalVM 22.0.0 (Java 22), macOS (arm64), Version 24.0.0
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22_macos-aarch64_bin.tar.gz",
        "sha256": "61632065cfcdc4e121362f1fd25a543955836bbacd6c1aadbcbe0d469d5ab8a3",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.0_macos-x64_24.0.0": {
        # Oracle GraalVM 22.0.0 (Java 22), macOS (amd64), Version 24.0.0
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22_macos-x64_bin.tar.gz",
        "sha256": "5b83f20dbc4c636ed41f19c3309f09839d4f5c6442dba986f460589c494a476c",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.0_windows-x64_24.0.0": {
        # Oracle GraalVM 22.0.0 (Java 22), Windows (amd64), Version 24.0.0
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22_windows-x64_bin.zip",
        "sha256": "1aba8b1c57cd98c07fd993a4d3f10de57640c50f513af66d4395e57d22266f02",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.1_linux-aarch64_24.0.1": {
        # GraalVM CE 22.0.1 (Java 22), Linux (arm64), Version 24.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.1/graalvm-community-jdk-22.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "2a510338cc6b63d2bb6aebe0ce0f8df9b76d9255207456cb1f0c9c820e6428cf",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.1_linux-x64_24.0.1": {
        # GraalVM CE 22.0.1 (Java 22), Linux (amd64), Version 24.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.1/graalvm-community-jdk-22.0.1_linux-x64_bin.tar.gz",
        "sha256": "e34ec7e8e8c6a4bb99ab4fa32c3e04d01f2f2bd88920ddda7545fd35a0511f75",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.1_macos-aarch64_24.0.1": {
        # GraalVM CE 22.0.1 (Java 22), macOS (arm64), Version 24.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.1/graalvm-community-jdk-22.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "b96a16359c800374af5fbd3cb685aaa91cfc590ea4be35538c24b37e12c769c0",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.1_macos-x64_24.0.1": {
        # GraalVM CE 22.0.1 (Java 22), macOS (amd64), Version 24.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.1/graalvm-community-jdk-22.0.1_macos-x64_bin.tar.gz",
        "sha256": "553c2dff3febd45f917e45f4dd620c194d8225bc28d13f5545ddffea9eeb30f8",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.1_windows-x64_24.0.1": {
        # GraalVM CE 22.0.1 (Java 22), Windows (amd64), Version 24.0.1
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.1/graalvm-community-jdk-22.0.1_windows-x64_bin.zip",
        "sha256": "623a4c5984f1210e61346e3ff942ec6f83d1928790ef9ae7dd28067e5c8de1aa",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.2_linux-aarch64_24.0.2": {
        # GraalVM CE 22.0.2 (Java 22), Linux (arm64), Version 24.0.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.2/graalvm-community-jdk-22.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "28ca4c815fa68b86141d9dcf1a46c1f58f74dead41de9042de1202337bb014d9",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.2_linux-x64_24.0.2": {
        # GraalVM CE 22.0.2 (Java 22), Linux (amd64), Version 24.0.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.2/graalvm-community-jdk-22.0.2_linux-x64_bin.tar.gz",
        "sha256": "ebac1dd96a5e0fbcd1dd9804fa58815f146390a40aae966f02a8c26d1974364f",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.2_macos-aarch64_24.0.2": {
        # GraalVM CE 22.0.2 (Java 22), macOS (arm64), Version 24.0.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.2/graalvm-community-jdk-22.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "883dfd503f2bbf9cd824564763c49cafa6b3c5e9d8c024093962131b4ef5101f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.2_macos-x64_24.0.2": {
        # GraalVM CE 22.0.2 (Java 22), macOS (amd64), Version 24.0.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.2/graalvm-community-jdk-22.0.2_macos-x64_bin.tar.gz",
        "sha256": "0512dda1b1ea569b2a6c3dc6671e102a4d5457e3b2dfa47bf656bd32893d12e4",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_22.0.2_windows-x64_24.0.2": {
        # GraalVM CE 22.0.2 (Java 22), Windows (amd64), Version 24.0.2
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-22.0.2/graalvm-community-jdk-22.0.2_windows-x64_bin.zip",
        "sha256": "107a37cea666c2ad6ad9eaa408b4041f822a24071a33c5057762ce48833e99a3",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.1_linux-aarch64_24.0.1": {
        # Oracle GraalVM 22.0.1 (Java 22), Linux (arm64), Version 24.0.1
        "url": "https://download.oracle.com/graalvm/22/latest/graalvm-jdk-22_linux-aarch64_bin.tar.gz",
        "sha256": "134166ea6141ee8dfda6eec95563a85d3f4174f5a2497071da13ef96bb83e65b",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.1_linux-x64_24.0.1": {
        # Oracle GraalVM 22.0.1 (Java 22), Linux (amd64), Version 24.0.1
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "d583cdb01ca023a37eed45d9d184b68b7a8d7f50b58dde1369041f294c34f4a3",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.1_macos-aarch64_24.0.1": {
        # Oracle GraalVM 22.0.1 (Java 22), macOS (arm64), Version 24.0.1
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "7735153e287cd63a29bb1031f2c018770a2734e5c7cb28ab5143a1bd2b4ad45f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.1_macos-x64_24.0.1": {
        # Oracle GraalVM 22.0.1 (Java 22), macOS (amd64), Version 24.0.1
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.1_macos-x64_bin.tar.gz",
        "sha256": "c1a477f4be38130f30ce745cebbb580f71c6159d94503e3e10b7ab5a7c4da66b",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.1_windows-x64_24.0.1": {
        # Oracle GraalVM 22.0.1 (Java 22), Windows (amd64), Version 24.0.1
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.1_windows-x64_bin.zip",
        "sha256": "7af4aa5935af940c937cdb01fe0a106b97cddf0fb3d886afc89f9febb41fd9b9",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.2_linux-aarch64_24.0.2": {
        # Oracle GraalVM 22.0.2 (Java 22), Linux (arm64), Version 24.0.2
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_linux-aarch64_bin.tar.gz",
        "sha256": "b247a6c25814cc9cea9b65cec8a9236e52302a71c34aaa7376e9eb301f8396fb",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.2_linux-x64_24.0.2": {
        # Oracle GraalVM 22.0.2 (Java 22), Linux (amd64), Version 24.0.2
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_linux-x64_bin.tar.gz",
        "sha256": "1881aa2c431b0506ecb170439832b053b757368d7109bd422298ca23e7939cd0",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.2_macos-aarch64_24.0.2": {
        # Oracle GraalVM 22.0.2 (Java 22), macOS (arm64), Version 24.0.2
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_macos-aarch64_bin.tar.gz",
        "sha256": "3b821806404325746b0a3de32128123d58def395b691df1c42679d9737d587e7",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.2_macos-x64_24.0.2": {
        # Oracle GraalVM 22.0.2 (Java 22), macOS (amd64), Version 24.0.2
        "url": "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_macos-x64_bin.tar.gz",
        "sha256": "9fcbf3ff96f38f31e2f590bb62adf19e065535c82e27b5fd742def005bef3528",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "oracle_22.0.2_windows-x64_24.0.2": {
        # Oracle GraalVM 22.0.2 (Java 22), Windows (amd64), Version 24.0.2
        "url": "https://download.oracle.com/graalvm/22/latest/graalvm-jdk-22_windows-x64_bin.zip",
        "sha256": "43e24d62b40399d3887fd9d107a823c62a69cdefcacc2df5e7170215628c844a",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java22",
        ],
    },
    "ce_23.0.0_linux-aarch64_24.1.0": {
        # GraalVM CE 23.0.0 (Java 23), Linux (arm64), Version 24.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-23.0.0/graalvm-community-jdk-23.0.0_linux-aarch64_bin.tar.gz",
        "sha256": "42ae53bdb4112d86eb3e12fe6d30a65b800a4ff8a658c7c3bc77e0a678078b20",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "ce_23.0.0_linux-x64_24.1.0": {
        # GraalVM CE 23.0.0 (Java 23), Linux (amd64), Version 24.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-23.0.0/graalvm-community-jdk-23.0.0_linux-x64_bin.tar.gz",
        "sha256": "440eb64bf548f37086f97d236a028d0a6ccf5cee9ed9caed2f70ded5a68312a0",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "ce_23.0.0_macos-aarch64_24.1.0": {
        # GraalVM CE 23.0.0 (Java 23), macOS (arm64), Version 24.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-23.0.0/graalvm-community-jdk-23.0.0_macos-aarch64_bin.tar.gz",
        "sha256": "cda587f6d15134dc237fbb1111c7e339c8a0b2f4c1a4817a436c7c15d8ba2a9b",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "ce_23.0.0_macos-x64_24.1.0": {
        # GraalVM CE 23.0.0 (Java 23), macOS (amd64), Version 24.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-23.0.0/graalvm-community-jdk-23.0.0_macos-x64_bin.tar.gz",
        "sha256": "1338b838e5c845688643ed9e91bf2a0236e4d53bf1dc9cb4f693bde0409d4daa",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "ce_23.0.0_windows-x64_24.1.1": {
        # GraalVM CE 23.0.0 (Java 23), Windows (amd64), Version 24.1.0
        "url": "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-23.0.0/graalvm-community-jdk-23.0.0_windows-x64_bin.zip",
        "sha256": "ef0e28d9ccdf68e31c911ec2069e010f35f1b484e6f70a4a6cce098f8bf8247e",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "oracle_23.0.1_linux-aarch64_24.1.1": {
        # Oracle GraalVM 23.0.1 (Java 23), Linux (arm64), Version 24.1.0
        "url": "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.1_linux-aarch64_bin.tar.gz",
        "sha256": "1835a98b87c439c8c654d97956c22d409855952e5560a8127f56c50f3f919d7d",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "oracle_23.0.1_linux-x64_24.1.1": {
        # Oracle GraalVM 23.0.1 (Java 23), Linux (amd64), Version 24.1.0
        "url": "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.1_linux-x64_bin.tar.gz",
        "sha256": "46ec9582ebe114f93470403f2cc123238ac0c7982129c358af7d8e1de52dd663",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "oracle_23.0.1_macos-aarch64_24.1.1": {
        # Oracle GraalVM 23.0.1 (Java 23), macOS (arm64), Version 24.1.0
        "url": "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.1_macos-aarch64_bin.tar.gz",
        "sha256": "c00a7a62ce453aa026bff65e5a18c63464f725c01e5a71771856226928ba5b0f",
        "compatible_with": [
            "@platforms//cpu:aarch64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "oracle_23.0.1_macos-x64_24.1.1": {
        # Oracle GraalVM 23.0.1 (Java 23), macOS (amd64), Version 24.1.0
        "url": "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.1_macos-x64_bin.tar.gz",
        "sha256": "539699d8ff4979623bc7bdf8282ac6f76cd2560f47d14ec5438bada24f136f96",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
            "@rules_graalvm//platform/jvm:java23",
        ],
    },
    "oracle_23.0.1_windows-x64_24.1.1": {
        # Oracle GraalVM 23.0.1 (Java 23), Windows (amd64), Version 24.1.0
        "url": "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.1_windows-x64_bin.zip",
        "sha256": "e758646504cfaf23cf218a22691ad70491f3196448a77d03d78e50dff2145533",
        "compatible_with": [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
            "@rules_graalvm//platform/jvm:java23",
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

# buildifier: disable=name-conventions
VmReleaseVersionsOracle = _VmReleaseVersionsOracle

generate_distribution_coordinate = _generate_distribution_coordinate
resolve_distribution_artifact = _resolve_distribution_artifact
