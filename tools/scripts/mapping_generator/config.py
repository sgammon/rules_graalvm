"""
Configuration values used by the mapping generator tool.
"""

from .rule import *

MAPPING_RULES = [
    # major and full java versions must align
    AlignmentRule(),

    # handle deprecation of components at gvm 23.1.0+
    ComponentDeprecationRule(),

    # there is no graalpython release for windows yet
    Rule.for_platform(
        Platform.WINDOWS_X64,
        components=[Component.PYTHON],
        reason="GraalPython does not provide a Windows release yet",
    ),

    # there is no espresso LLVM release for ARM64 mac yet
    Rule.for_platform(
        Platform.MACOS_AARCH64,
        components=[Component.ESPRESSO_LLVM],
        reason="Espresso LLVM does not provide an Apple M1/M2 release yet",
    ),

    # there is no espresso LLVM release for ARM64 linux yet
    Rule.for_platform(
        Platform.LINUX_AARCH64,
        components=[Component.ESPRESSO_LLVM],
        reason="Espresso LLVM does not provide a Linux ARM64 release yet",
    ),

    # there is no espresso LLVM release for windows yet
    Rule.for_platform(
        Platform.WINDOWS_X64,
        components=[Component.ESPRESSO_LLVM],
        reason="Espresso LLVM does not provide a Windows release yet",
    ),

    # there is no truffleruby release for windows yet
    Rule.for_platform(
        Platform.WINDOWS_X64,
        components=[Component.RUBY],
        reason="TruffleRuby does not provide a Windows release yet",
    ),

    # skip all oracle-provided components, as we cannot calculate download URLs for them
    Rule.for_distribution(
        Distribution.ORACLE,
        components=DEFAULT_COMPONENTS,
        reason="Cannot calculate Oracle GVM component download URLs",
    ),
] + [
    # pins aligned version to supported JVM level (at JVM version tag)
    Rule.supported_jvms_at(
        aligned_version,
        *jvm,
        reason="GraalVM Java version %s is aligned to Java %s" % (aligned_version, jvm),
    ) for (aligned_version, jvm, _) in ALIGNMENT_VERSIONS
] + [
    # pins aligned version to supported JVM level (at JVM version tag)
    Rule.supported_jvms_at(
        gvm,
        *jvm,
        reason="GraalVM version %s supports Java version(s) %s" % (gvm, ", ".join(map(lambda x: str(x), jvm))),
    ) for (gvm, jvm) in SUPPORTED_JAVAS
]
