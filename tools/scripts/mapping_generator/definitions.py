"""
  Enumerative definitions for use in the mapping generator tool.
"""

from enum import StrEnum as Enum, IntEnum


class Distribution(Enum):
    """Enumerates available GraalVM distributions."""

    COMMUNITY = "ce"
    ENTERPRISE = "ee"
    ORACLE = "oracle"

    def label(self):
        """Return a human-readable label for this distribution."""

        return {
            Distribution.COMMUNITY: "GraalVM CE",
            Distribution.ENTERPRISE: "GraalVM EE",
            Distribution.ORACLE: "Oracle GraalVM"
        }[self]


class Component(Enum):
    """Enumerates available GraalVM components."""

    BASE = "base"  # special component representing base JDK
    NATIVE_IMAGE = "native-image"
    JS = "js"
    WASM = "wasm"
    PYTHON = "python"
    LLVM = "llvm"
    LLVM_TOOLCHAIN = "llvm-toolchain"
    RUBY = "ruby"
    ESPRESSO = "espresso"
    ESPRESSO_LLVM = "espresso-llvm"
    ICU4J = "icu4j"
    REGEX = "regex"
    TRUFFLE_JSON = "trufflejson"
    ANTLR4 = "antlr4"

    def label(self):
        """Return a human-readable label for this component."""

        return {
            Component.ANTLR4: "ANTLR4",
            Component.NATIVE_IMAGE: "Native Image",
            Component.JS: "GraalJs",
            Component.WASM: "GraalWasm",
            Component.PYTHON: "GraalPython",
            Component.LLVM: "Sulong",
            Component.LLVM_TOOLCHAIN: "LLVM Toolchain",
            Component.RUBY: "TruffleRuby",
            Component.ESPRESSO: "Espresso",
            Component.ESPRESSO_LLVM: "Espresso for LLVM",
            Component.ICU4J: "ICU4j",
            Component.REGEX: "TruffleRegex",
            Component.TRUFFLE_JSON: "TruffleJson",
        }[self]


class Platform(Enum):
    """Enumerates available GraalVM platforms."""

    MACOS_X64 = "macos-x64"
    MACOS_AARCH64 = "macos-aarch64"
    LINUX_X64 = "linux-x64"
    LINUX_AARCH64 = "linux-aarch64"
    WINDOWS_X64 = "windows-x64"

    def label(self):
        """Return a human-readable label for this component."""

        return {
            Platform.MACOS_X64: "macOS (amd64)",
            Platform.MACOS_AARCH64: "macOS (arm64)",
            Platform.LINUX_X64: "Linux (amd64)",
            Platform.LINUX_AARCH64: "Linux (arm64)",
            Platform.WINDOWS_X64: "Windows (amd64)",
        }[self]


JAVA_MIN = 8
JAVA_MAX = 22


class JavaVersion(IntEnum):
    """Enumerates supported Java versions."""

    JAVA_8 = 8
    JAVA_11 = 11
    JAVA_17 = 17
    JAVA_19 = 19
    JAVA_20 = 20
    JAVA_21 = 21
    JAVA_22 = 22

    @classmethod
    def from_parsed(cls, parsed):
        """Resolve a Java major version from a parsed version of the JVM."""
        if not (JAVA_MIN < parsed.semver.major < JAVA_MAX):
            raise NotImplementedError("Java version %s not supported" % parsed.semver.major)
        return JavaVersion["JAVA_%s" % parsed.semver.major]

    def label(self):
        """Return a human-readable label for this Java version."""

        return {
            JavaVersion.JAVA_8: "Java 8",
            JavaVersion.JAVA_11: "Java 11",
            JavaVersion.JAVA_17: "Java 17",
            JavaVersion.JAVA_19: "Java 19",
            JavaVersion.JAVA_20: "Java 20",
            JavaVersion.JAVA_21: "Java 21",
        }[self]
