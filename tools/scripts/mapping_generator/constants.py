"""
Defines constants used in the mapping generator tool.
"""

from .definitions import *

DEFAULT_COMPONENTS = [
    Component.NATIVE_IMAGE,
    Component.JS,
    Component.WASM,
    Component.PYTHON,
    Component.LLVM,
    Component.RUBY,
    Component.ESPRESSO,
]

DEFAULT_PLATFORMS = [
    Platform.MACOS_X64,
    Platform.MACOS_AARCH64,
    Platform.LINUX_X64,
    Platform.LINUX_AARCH64,
    Platform.WINDOWS_X64,
]

DEFAULT_DISTRIBUTIONS = [
    Distribution.COMMUNITY,
    Distribution.ORACLE,
]

DEFAULT_JAVA_VERSIONS = [
    JavaVersion.JAVA_8,
    JavaVersion.JAVA_11,
    JavaVersion.JAVA_17,
    JavaVersion.JAVA_20,
]

TRANSITIONAL_RELEASES = [
    # None yet.
]

JAVA_VERSION_TAGS = {
    JavaVersion.JAVA_8: "@rules_graalvm//platform/jvm:java8",
    JavaVersion.JAVA_11: "@rules_graalvm//platform/jvm:java11",
    JavaVersion.JAVA_17: "@rules_graalvm//platform/jvm:java17",
    JavaVersion.JAVA_19: "@rules_graalvm//platform/jvm:java19",
    JavaVersion.JAVA_20: "@rules_graalvm//platform/jvm:java20",
    JavaVersion.JAVA_21: "@rules_graalvm//platform/jvm:java21",
}

COMPONENT_TAGS = {
    Component.PYTHON: ["@rules_graalvm//platform/engine/python"],
    Component.RUBY: ["@rules_graalvm//platform/engine/ruby"],
    Component.JS: ["@rules_graalvm//platform/engine/javascript"],
    Component.ESPRESSO: ["@rules_graalvm//platform/engine/java"],
    Component.WASM: ["@rules_graalvm//platform/engine/wasm"],
    Component.LLVM: ["@rules_graalvm//platform/engine/llvm"],
}

PLATFORM_TAG_MAPPINGS = {
    Platform.MACOS_AARCH64: [
        "@platforms//cpu:aarch64",
        "@platforms//os:macos",
    ],
    Platform.MACOS_X64: [
        "@platforms//cpu:x86_64",
        "@platforms//os:macos",
    ],
    Platform.LINUX_AARCH64: [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    Platform.LINUX_X64: [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    Platform.WINDOWS_X64: [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
}

ALIGNMENT_VERSIONS = [
    # jvm version -- java version -- gvm version
    ("20.0.2", (JavaVersion.JAVA_20,), "23.0.1"),
    ("20.0.1", (JavaVersion.JAVA_20,), "23.0.1"),
    ("17.0.8", (JavaVersion.JAVA_17,), "23.0.1"),
    ("17.0.7", (JavaVersion.JAVA_17,), "23.0.1"),
]

SUPPORTED_JAVAS = [
    ("23.0.1", (JavaVersion.JAVA_17, JavaVersion.JAVA_20)),
]

TRANSITIONAL_VERSIONS = [
    "22.3.3",
]

COMMUNITY_COMPONENT_REPOS = {
    "js": "oracle/graaljs",
    "python": "oracle/graalpython",
    "ruby": "oracle/truffleruby",
}

# Latest download endpoint for Oracle GVM
ORACLE_DOWNLOAD_BASE_LATEST = "https://download.oracle.com/java/{java_version_major}/latest/jdk-{java_version}_{platform}_bin.{ext}"

# Archive download endpoint for Oracle GVM
ORACLE_DOWNLOAD_BASE_ARCHIVE = "https://download.oracle.com/java/{java_version_major}/archive/jdk-{java_version}_{platform}_bin.{ext}"

# Latest download endpoint for Oracle GVM components
ORACLE_DOWNLOAD_COMPONENT_LATEST = "" # TODO

# Archive download endpoint for Oracle GVM components
ORACLE_DOWNLOAD_COMPONENT_ARCHIVE = "" # TODO

# GitHub repo to pull CE releases from
DEFAULT_COMMUNITY_REPO = "graalvm/graalvm-ce-builds"

# GitHub repo download base for SDKs
COMMUNITY_DOWNLOAD_BASE = "https://github.com/{repo}/releases/download/jdk-{java_version}/graalvm-community-jdk-{java_version}_{platform}_bin.{ext}"

# GitHub repo download base for components
COMMUNITY_DOWNLOAD_COMPONENT = "https://github.com/{repo}/releases/download/graal-{version}/{component}-installable-svm-java{java_version_major}-{platform}-{version}.{ext}"

# Transitional download URLs for CE SDKs
COMMUNITY_DOWNLOAD_BASE_TRANSITIONAL = "https://github.com/{repo}/releases/download/vm-{version}/graalvm-ce-java{java_version_major}-{platform}-{version}.{ext}"

# GitHub repo download base for components
COMMUNITY_DOWNLOAD_COMPONENT_TRANSITIONAL = "https://github.com/{repo}/releases/download/vm-{version}/{component}-installable-svm-java{java_version_major}-{platform}-{version}.{ext}"
