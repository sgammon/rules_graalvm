"""
Configuration values used by the mapping generator tool.
"""

from .definitions import *
from .constants import *
from .rule import *


MAPPING_RULES = [
    # major and full java versions must align
    AlignmentRule(),

    # there is no graalpython release for windows yet
    Rule.for_platform(
        Platform.WINDOWS_X64,
        components = [Component.PYTHON],
        reason = "GraalPython does not provide a Windows release yet",
    ),

    # there is no truffleruby release for windows yet
    Rule.for_platform(
        Platform.WINDOWS_X64,
        components = [Component.RUBY],
        reason = "TruffleRuby does not provide a Windows release yet",
    ),

    # skip all oracle-provided components, as we cannot calculate download URLs for them
    Rule.for_distribution(
        Distribution.ORACLE,
        components = DEFAULT_COMPONENTS,
        reason = "Cannot calculate Oracle GVM component download URLs",
    ),

    # at gvm 21+, only JVM17 and JVM20 are supported
    Rule.supported_jvms_after(
        "21.0.0",
        JavaVersion.JAVA_17,
        JavaVersion.JAVA_20,
        reason = "GraalVM 21+ only supports JVM17 and JVM20",
    )
] + [
    # pins aligned version to supported JVM level (at JVM version tag)
    Rule.supported_jvms_at(
        aligned_version,
        *jvm,
        reason = "GraalVM Java version %s is aligned to Java %s" % (aligned_version, jvm),
    ) for (aligned_version, jvm, _) in ALIGNMENT_VERSIONS
] + [
    # pins aligned version to supported JVM level (at JVM version tag)
    Rule.supported_jvms_at(
        gvm,
        *jvm,
        reason = "GraalVM version %s supports Java version(s) %s" % (gvm, ", ".join(map(lambda x: str(x), jvm))),
    ) for (gvm, jvm) in SUPPORTED_JAVAS
]
