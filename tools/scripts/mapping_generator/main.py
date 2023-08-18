#!/bin/env python

"""
  Mappings Generator
  ------------------

  Generates Starlark SHA256 mappings for GraalVM download artifacts.
"""

import sys, time, os, logging, argparse, itertools

from abc import ABC, abstractmethod
from datetime import datetime
from enum import StrEnum as Enum, IntEnum

import requests
import semver

from github import Github
from github import Auth


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

    BASE = "base" # special component representing base JDK
    NATIVE_IMAGE = "native-image"
    JS = "js"
    WASM = "wasm"
    PYTHON = "python"
    LLVM = "llvm"
    RUBY = "ruby"

    def label(self):
        """Return a human-readable label for this component."""

        return {
            Component.NATIVE_IMAGE: "Native Image",
            Component.JS: "GraalJs",
            Component.WASM: "GraalWasm",
            Component.PYTHON: "GraalPython",
            Component.LLVM: "Sulong",
            Component.RUBY: "TruffleRuby"
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
JAVA_MAX = 21

class JavaVersion(IntEnum):
    """Enumerates supported Java versions."""

    JAVA_8 = 8
    JAVA_11 = 11
    JAVA_17 = 17
    JAVA_19 = 19
    JAVA_20 = 20
    JAVA_21 = 21

    @classmethod
    def from_parsed(cls, parsed):
        """Resolve a Java major version from a parsed version of the JVM."""
        if not (JAVA_MIN < parsed.semver.major < JAVA_MAX):
            import pdb; pdb.set_trace()
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

RESET_SEQ = "\033[0m"
COLOR_SEQ = "\033[1;%dm"
BOLD_SEQ = "\033[1m"
grey = "\x1b[37;20m"
yellow = "\x1b[33;20m"
green = "\x1b[32;20m"
blue = "\x1b[34;20m"
cyan = "\x1b[36;20m"
red = "\x1b[31;20m"
bold_red = "\x1b[31;1m"
bold_white = "\x1b[38;1m"
reset_color = "\x1b[0m"
colorized_output = True

def colorize(color, *values):
    if not colorized_output:
        return " ".join(values)
    return RESET_SEQ + color + " ".join(values) + reset_color

def formatter_message(message, use_color = True):
    if use_color and colorized_output:
        message = message.replace("$RESET", RESET_SEQ).replace("$BOLD", BOLD_SEQ)
    else:
        message = message.replace("$RESET", "").replace("$BOLD", "")
    return message

BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)

COLORS = {
    'WARNING': YELLOW,
    'INFO': CYAN,
    'DEBUG': MAGENTA,
    'CRITICAL': RED,
    'ERROR': RED
}

class ColorizedFormatter(logging.Formatter):
    def __init__(self, msg, use_color = colorized_output):
        logging.Formatter.__init__(self, msg)
        self.use_color = use_color

    def format(self, record):
        levelname = record.levelname
        if self.use_color and levelname in COLORS:
            levelname_color = COLOR_SEQ % (30 + COLORS[levelname]) + levelname + RESET_SEQ
            record.levelname = levelname_color
        return logging.Formatter.format(self, record)

class ColorizedLogger(logging.Logger):
    FORMAT = "[%(levelname)s] %(message)s"
    COLOR_FORMAT = formatter_message(FORMAT, True)
    def __init__(self, name):
        logging.Logger.__init__(self, name, logging.DEBUG)
        color_formatter = ColorizedFormatter(self.COLOR_FORMAT)
        handler.setFormatter(color_formatter)
        self.addHandler(handler)
        return

DEFAULT_COMPONENTS = [
    Component.NATIVE_IMAGE,
    Component.JS,
    Component.WASM,
    Component.PYTHON,
    Component.LLVM,
    Component.RUBY,
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
ORACLE_DOWNLOAD_COMPONENT_LATEST = ""

# Archive download endpoint for Oracle GVM components
ORACLE_DOWNLOAD_COMPONENT_ARCHIVE = ""

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

# GitHub client
client = None

# Transitional URL download targets
_transitional_download_targets = set()

# Download targets requiring auth
_download_targets_requiring_auth = set()

# Argument parser
parser = argparse.ArgumentParser(
    prog = "mapping_generator",
    epilog = "Copyright (c) Elide Ventures, LLC. All rights reserved.",
    description = """
Generates Starlark mappings for GraalVM release artifacts.
Provide release tags to generate mappings for specific releases,
or omit tags entirely to crawl the entire set of releases from GitHub.

For Oracle GVM releases, this script accesses Oracle's download service.
""",
)

parser.add_argument(
    "-v", "--verbose",
    action = "store_true",
    help = "Enable verbose logging output",
)

parser.add_argument(
    "--debug",
    action = "store_true",
    help = "Enable extra debugging features",
)

parser.add_argument(
    "-o", "--out",
    type = str,
    help = "Set output file; if omitted, generated mappings are printed to stdout.",
)

parser.add_argument(
    "-q", "--quiet",
    action = "store_true",
    help = "Reduce logging output. Wins over verbose mode.",
)

parser.add_argument(
    "--no-color",
    action = "store_true",
    help = "Reduce logging output. Wins over verbose mode.",
)

parser.add_argument(
    "--no-validate",
    action = "store_true",
    help = "Suppress validations of download URLs. Strongly recommended not to turn these off.",
)

parser.add_argument(
    "--no-check",
    action = "store_true",
    help = "Suppress checks of SHA256 hashes. Strongly recommended not to turn these off.",
)

parser.add_argument(
    "--no-render",
    action = "store_true",
    help = "Skip rendering the final file (performs all other steps, modulo other flags).",
)

parser.add_argument(
    "--dry",
    action = "store_true",
    help = "Don't actually do anything, just plan and exit.",
)

parser.add_argument(
    "--latest",
    action = "store_true",
    help = "Fetch only the latest release. Takes precedence over all other version selectors.",
)

parser.add_argument(
    "--keep_going",
    action = "store_true",
    help = "Consider artifacts which don't fetch to be warnings, not errors.",
)

parser.add_argument(
    "--repo-community",
    type = str,
    help = "Custom GitHub repositiory to use for Community releases; use format 'org/repo'.",
)

parser.add_argument(
    '--no-release',
    help = "Whether to include release fingerprints. Defaults to `true`.",
    action = "store_true",
)

parser.add_argument(
    '--no-components',
    help = "Omit components from downloads and generated mappings.",
    action = "store_true",
)

parser.add_argument(
    '-c', '--components',
    nargs = "*",
    help = "Components to include in generated mappings. Optional; defaults to all known.",
    choices = DEFAULT_COMPONENTS,
)

parser.add_argument(
    '-p', '--platforms',
    nargs = "*",
    help = "OS/arch pairs to generate mappings for. Optiona; defaults to all known.",
    choices = DEFAULT_PLATFORMS,
)

parser.add_argument(
    '-t', '--tags',
    nargs = "*",
    help = "Release tags to generate mappings for. Multiple uses are accumulated.",
)

parser.add_argument(
    '-j', '--jdks',
    nargs = "*",
    help = "JVM versions to generate mappings for; defaults to the full set of known versions.",
)

parser.add_argument(
    '-d', '--dist',
    nargs = "*",
    help = "Distributions to generate mappings for; accepts ORACLE and COMMUNITY. Defaults to both.",
    choices = DEFAULT_DISTRIBUTIONS,
)

loggingConfig = {
    "encoding": "utf-8",
}

# Global logger to use
logger = logging.getLogger("generator")
handler = logging.StreamHandler()


class MappingRuleAction(Enum):
    SKIP = "SKIP"
    REQUIRE_AUTH = "REQUIRE_AUTH"
    USE_TRANSITIONAL = "USE_TRANSITIONAL"

class RuleMatchMode(Enum):
    ANY = "ANY"
    ALL = "ALL"

def _setify(value):
    if isinstance(value, str):
        return set([value])
    elif isinstance(value, set):
        return value
    else:
        return set(value)

class ParsedVersion:
    @classmethod
    def of(cls, version):
        return ParsedVersion(version, semver.Version.parse(version))

    def __init__(self, raw, version):
        self.raw = raw
        self.semver = version

    def __repr__(self):
        return "Version(%s)" % self.__str__()

    def __str__(self):
        return self.raw

    def __hash__(self):
        return self.raw.__hash__()

    def __hash__(self):
        return self.raw.__hash__()

    def __eq__(self, other):
        if other is None or (not isinstance(other, ParsedVersion) and not isinstance(other, str)):
            return False
        return self.semver.__eq__(other.semver)

    def __gt__(self, other):
        if other is None or (not isinstance(other, ParsedVersion) and not isinstance(other, str)):
            return False
        return self.semver.__gt__(other.semver)

    def __lt__(self, other):
        if other is None or (not isinstance(other, ParsedVersion) and not isinstance(other, str)):
            return False
        return self.semver.__lt__(other.semver)

    def __ge__(self, other):
        if other is None or (not isinstance(other, ParsedVersion) and not isinstance(other, str)):
            return False
        return self.semver.__ge__(other.semver)

    def __le__(self, other):
        if other is None or (not isinstance(other, ParsedVersion) and not isinstance(other, str)):
            return False
        return self.semver.__le__(other.semver)

class AbstractRule(ABC):
    """Concept of a rule."""

    @abstractmethod
    def applies_to(self, target):
        raise NotImplementedError("Must be implemented by subclass")

    @abstractmethod
    def actions(self, target):
        raise NotImplementedError("Must be implemented by subclass")

class Rule(AbstractRule):
    """Specifies a rule which filters a download for some reason."""

    def __init__(self,
                 action,
                 mode,
                 reason = None,
                 version_min = None,
                 version_max = None,
                 versions = None,
                 jdks = None,
                 platforms = None,
                 distributions = None,
                 components = None):
        """Initialize a new skip rule."""

        self.mode = mode
        self._actions = [action]
        self.reason = reason
        self.version_min = version_min
        self.version_max = version_max
        self.versions = None
        self.platforms = None
        self.distributions = None
        self.components = None
        self.jdks = None

        if versions:
            self.versions = _setify(versions)
        if platforms:
            self.platforms = _setify(platforms)
        if distributions:
            self.distributions = _setify(distributions)
        if components:
            self.components = _setify(components)
        if jdks:
            self.jdks = _setify(jdks)

    def __repr__(self):
        """Generate a string representation for a mapping rule."""
        criteria = [i for i in map(lambda x: x[1](x[0]), filter(lambda x: x[0] is not None, [
            (self.version_min, lambda x: "version >= %s" % str(x)),
            (self.version_max, lambda x: "version <= %s" % str(x)),
            (self.versions, lambda x: "version in (%s)" % x),
            (self.platforms, lambda x: "platform in (%s)" % ",".join(x)),
            (self.distributions, lambda x: "dist in (%s)" % ",".join(x)),
            (self.components, lambda x: "component in (%s)" % ",".join(x)),
            (self.jdks, lambda x: "JDK in (%s)" % ",".join(map(str, x))),
        ]))]
        return "Rule({action}, {mode}({criteria}), reason = \"{reason}\")".format(
            action = ", ".join(map(lambda x: str(x), self._actions)),
            reason = self.reason or "Not given",
            mode = self.mode,
            criteria = ", ".join(criteria),
        )

    @classmethod
    def parse_version_maybe(cls, version):
        """Parse a version string if needed."""
        if isinstance(version, str):
            return ParsedVersion.of(version)
        return version

    @classmethod
    def unsupported_jvms_after(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action = MappingRuleAction.SKIP,
            mode = RuleMatchMode.ALL,
            jdks = jdks,
            version_min = cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def supported_jvms_after(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action = MappingRuleAction.SKIP,
            mode = RuleMatchMode.ALL,
            jdks = [i for i in DEFAULT_JAVA_VERSIONS if i not in jdks],
            version_min = cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def unsupported_jvms_at(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a specific GraalVM version."""
        return Rule(
            action = MappingRuleAction.SKIP,
            mode = RuleMatchMode.ALL,
            jdks = jdks,
            versions = [cls.parse_version_maybe(version)],
            **kwargs
        )

    @classmethod
    def supported_jvms_at(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a specific GraalVM version."""
        return Rule(
            action = MappingRuleAction.SKIP,
            mode = RuleMatchMode.ALL,
            jdks = [i for i in DEFAULT_JAVA_VERSIONS if i not in jdks],
            versions = [cls.parse_version_maybe(version)],
            **kwargs
        )

    @classmethod
    def at_least_version(cls, version, mode = RuleMatchMode.ALL, action = MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action = action,
            mode = mode,
            version_min = cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def at_most_version(cls, version, mode = RuleMatchMode.ALL, action = MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action = action,
            mode = mode,
            version_max = cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def at_version(cls, version, mode = RuleMatchMode.ALL, action = MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action = action,
            mode = mode,
            versions = [cls.parse_version_maybe(version)],
            **kwargs
        )

    @classmethod
    def for_distribution(cls, distribution, mode = RuleMatchMode.ALL, action = MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download for a GraalVM distribution."""
        return Rule(
            action = action,
            mode = mode,
            distributions = [distribution],
            **kwargs
        )

    @classmethod
    def for_platform(cls, platform, mode = RuleMatchMode.ALL, action = MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download on a speciic platform."""
        return Rule(
            action = action,
            mode = mode,
            platforms = [platform],
            **kwargs
        )

    def applies_to(self, target):
        """Decide whether this skip rule applies to the provided target."""
        logger.debug("Checking rule '%s' against target '%s'" % (self, target))
        conditions = [
            (self.platforms, target.platform, lambda x: x in self.platforms),
            (self.distributions, target.distribution, lambda x: x in self.distributions),
            (self.components, target.component, lambda x: x in self.components),
            (self.versions, target.version, lambda x: x in self.versions),
            (self.version_min, target.version, lambda x: x >= self.version_min),
            (self.version_max, target.version, lambda x: x <= self.version_max),
            (self.jdks, target.jdk, lambda x: x in self.jdks),
        ]
        applies = False
        mode = all
        if self.mode == RuleMatchMode.ANY:
            mode = any

        # if this rule has version constraints and we're evaluating a "latest"
        # SDK version, we should not apply the rule.
        if target.latest and any(filter(lambda x: x is not None, [self.versions, self.version_min, self.version_max])):
            # corner case: if the rule is "latest", the greatest available `version_min` rules
            # should still apply.
            if self.version_min is not None:
                all_version_mins = [i for i in filter(lambda x: x.version_min is not None, MAPPING_RULES)]
                for candidate in all_version_mins:
                    if candidate.version_min > self.version_min:
                        # there is a greater version-min, so we should reject this rule.
                        return False

                # this is at the "greatest" version minimum, so apply it forcibly to this `latest`
                # SDK rule we are processing.
                return True

            # there is no version minimum rule to compare to, and the `latest` version of the SDK
            # is unknown, so we cannot enforce this rule, which has version constraints.
            return False


        evaluated_conditions = [
            i for i in map(lambda x: x[2](x[1]), filter(lambda x: x[0] is not None and x[1] is not None, conditions))
        ]
        applies = mode(evaluated_conditions)
        return applies

    def actions(self, target):
        """Return the action(s) to take on the provided target."""
        return [i for i in map(lambda x: (x, self.reason), self._actions)]

class AlignmentRule(AbstractRule):
    """Enforce that the major and full Java versions align."""

    def applies_to(self, target):
        # we only have this attribute with a specific JVM version declared
        if target.jvm is not None:
            major = JavaVersion.from_parsed(target.jvm)
            if int(target.jdk) == int(major):
                return False  # it aligns
            else:
                return True  # it does not align
        return False  # not eligible

    def actions(self, target):
        return [(MappingRuleAction.SKIP, "Version misalignment")]

class DownloadTarget:
    """Resolved target for download and inclusion in output mappings."""

    def __init__(self, args, quad):
        platform, jdk, version, component = quad

        self.args = args
        self.platform = Platform(platform)
        self.component = component
        self.jdk = jdk
        self.jvm = None
        self.latest = False
        self.version = None
        self.__cached_coordinate = None

        if version.startswith("oracle"):
            self.distribution = Distribution.ORACLE
            if version == "oracle-latest":
                self.latest = True
                self.version = None
            else:
                self.latest = False
                self.version = ParsedVersion.of(version[(len("oracle") + 1):])
        else:
            self.distribution = Distribution.COMMUNITY
            if version == "ce-latest":
                self.latest = True
                self.version = None
            else:
                self.latest = False
                self.version = ParsedVersion.of(version[(len("ce") + 1):])

        # fix: if this version is an "aligned" version with an OpenJDK release, then we
        # need to find it in `aligned_versions` and set the version properly.
        if self.version.raw in [x for (x, _, _) in ALIGNMENT_VERSIONS]:
            self.jvm = self.version
            self.version = ParsedVersion.of([z for (_, _, z) in ALIGNMENT_VERSIONS][0])
    
    def __hash__(self):
        """Use the coordinate key for a target's hash identity."""

        return self.coordinate().__hash__()

    def __repr__(self):
        """Generate a string representation for this download target."""

        typelabel = "SDK"
        if self.component != Component.BASE:
            typelabel = "Component"

        return "{type}({distribution}, {version}, {platform}, java{java_major}{java}, {component})".format(
            java_major = self.jdk,
            type = typelabel,
            java = self.jvm is not None and ("/%s" % self.jvm) or "",
            distribution = str(self.distribution),
            platform = str(self.platform),
            component = str(self.component),
            version = str(self.version or (self.latest and "latest")),
        )

    def generate_download_urls(self):
        """Generate a pair of download URLs for this target."""

        # base sdk download URLs
        if self.component == Component.BASE:
            return generate_base_download_urls(self)

        # component download urls
        else:
            return generate_component_download_urls(self)

    def coordinate(self):
        """Generate a well-formed dictionary key for this target, which is used in the final mapping."""

        if self.__cached_coordinate is None:
            version_str = self.version.raw
            if self.latest:
                version_str = "latest"

            # component fragments
            fragments = (i for i in map(str, filter(lambda frag: frag is not None and frag, [
                self.distribution,
                self.jvm or self.jdk,
                self.platform,
                self.component != Component.BASE and str(self.component) or "",
                version_str,
            ])))
            self.__cached_coordinate = "_".join(fragments)
        return self.__cached_coordinate

    def description(self):
        """Generate a human-readable label describing this target."""

        segments = []

        first_stanza = []

        # stanza: component (omitted if SDK)
        if self.component != Component.BASE:
            first_stanza.append(self.component.label())
            first_stanza.append("for")

        # stanza: vm version
        first_stanza.append(self.distribution.label())

        # if we're printing a description for an aligned release, we can just
        # use the aligned version only. it's the "version" of graalvm and the
        # full version of this JVM.
        if self.jvm is not None:
            first_stanza.append(self.jvm.raw)
            first_stanza.append("(%s)" % self.jdk.label())
        else:
            first_stanza.append("(%s)" % self.jdk.label())

        segments.append(first_stanza)

        # stanza: platform
        segments.append([self.platform.label()])

        # stanza: graalvm version
        segments.append([
            "Version",
            self.version.raw
        ])

        return ", ".join(map(lambda x: " ".join(x), segments))


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

def say(*args):
    """Print to stdout."""
    print(*args, end = "\n", file = sys.stderr)

def build_auth():
    """Build auth credentials for use with the GitHub API, if applicable."""

    token = os.environ["GITHUB_TOKEN"]
    if token is not None and len(token) > 0:
        logger.debug("GITHUB_TOKEN environment variable found; using it")
        return Auth.Token(token)
    logger.debug("No GITHUB_TOKEN found; skipping auth")
    return None

def handle_flags(args):
    """Handle flags before executing."""

    global logger
    global colorized_output

    if not args.no_color and (os.environ.get("NOCOLOR", None) is None):
        colorized_output = True
    else:
        colorized_output = False

    # prepare logging/output
    if args.verbose and not args.quiet:
        loggingConfig.update({
            "level": logging.DEBUG
        })
        logger.setLevel(logging.DEBUG)
    elif not args.quiet:
        loggingConfig.update({
            "level": logging.INFO,
        })
        logger.setLevel(logging.INFO)

    # initialize logging configuration
    logging.basicConfig(**loggingConfig)
    return False  # don't exit

def determine_platforms(args, distributions):
    """Determine the set of platforms we should generate release mappings for."""

    all_platforms = DEFAULT_PLATFORMS[:]
    target_platforms = args.platforms or []
    if len(target_platforms) > 0:
        logger.debug("Using explicit set of target platforms: '%s'" % ",".join(target_platforms))
        return target_platforms
    else:
        logger.debug("Using default set of all platforms: '%s'" % ",".join(all_platforms))
        return all_platforms

def fetch_ce_versions(args, distributions):
    """Fetch available release versions from the Community repo."""

    all_ce_versions = []
    if Distribution.COMMUNITY not in distributions:
        logger.debug("Skipping CE version fetch: Not included in distributions")
        return all_ce_versions

    ce_repo = args.repo_community or DEFAULT_COMMUNITY_REPO
    logger.debug("Resolving Community Edition versions from repo '%s'" % ce_repo)

    fetched_repo = client.get_repo(ce_repo)

    # if instructed, only fetch the latest version
    if args.latest:
        logger.debug("Fetching latest CE version from repo '%s'" % ce_repo)
        return [fetch_latest_ce_version(args, fetched_repo)]

    if args.tags and len(args.tags) > 0:
        logger.debug("Resolving explicit CE tags '%s'" % ",".join(args.tags))
        all_ce_versions = [fetch_named_ce_release(args, fetched_repo, t).tag_name.split("-")[1] for t in args.tags]

    # otherwise, we need to fetch the full suite of releases, and append them all,
    # processing the tag prefix to understand what release it is a part of.
    all_releases = fetched_repo.get_releases()

    return all_ce_versions

def get_latest_release_with_prefix(repo, prefix):
    """Fetch the latest semver release tag available for the provided prefix."""

    return (i for i in filter(lambda x: x.tag_name.startswith("%s-" % prefix), repo.get_releases())).__next__()

def fetch_latest_ce_version(args, repo):
    """Fetch the latest GraalVM CE release."""

    release = get_latest_release_with_prefix(repo, "vm")
    tag = release.tag_name.split("-")[1]  # drop `vm-` prefix
    logger.debug("Resolved latest CE tagged release: '%s'" % tag)
    return tag

def fetch_named_ce_release(args, repo, name):
    """Fetch the named GraalVM CE release."""

    # fix: if it's on the Java release track, it uses the `jdk-` tag. otherwise, use `vm-` if it's a
    # transitional version, or fallback to `graal-`.
    prefix = "graal-"
    if name in [x[0] for x in ALIGNMENT_VERSIONS]:
        prefix = "jdk-"
    elif name in TRANSITIONAL_RELEASES:
        prefix = "graal-"

    release = repo.get_release("%s%s" % (prefix, name))
    if not release:
        logger.error("Targeted CE release could not be found: '%s' (tag '%s' missing)" % (name, "vm-%s" % name))
        return sys.exit(1)

    logger.debug("Resolved named CE tagged release: '%s'" % name)
    return release

def fetch_named_gvm_version(args, name):
    """Fetch the named Oracle GraalVM release."""

    return name # TODO

def fetch_latest_gvm_version(args):
    """Fetch the latest Oracle GraalVM release."""
    return "latest"  # special symbol

def fetch_oracle_versions(args, distributions):
    """Fetch available Oracle versions from their download service."""

    all_gvm_versions = []
    if Distribution.ORACLE not in distributions:
        logger.debug("Skipping Oracle version fetch: Not included in distributions")
        return all_gvm_versions

    # if instructed, only fetch the latest version
    if args.latest:
        logger.debug("Fetching latest Oracle GVM version")
        return [fetch_latest_gvm_version(args)]

    if args.tags and len(args.tags) > 0:
        logger.debug("Resolving explicit Oracle tags '%s'" % ",".join(args.tags))
        all_gvm_versions = [fetch_named_gvm_version(args, t) for t in args.tags]

    return all_gvm_versions

def determine_versions(args, distributions, platforms):
    """Determine the set of versions we should generate release mappings for."""

    all_versions = []

    if args.latest or len(all_versions) == 0 or len(args.tags) > 0:
        if args.latest:
            logger.debug("Fetching latest version only (via args)")
        elif len(args.tags) > 0:
            logger.debug("Explicit set of versions resolved: '%s'" % ",".join(all_versions))
        else:
            logger.debug("No versions provided via args. Resolving via GitHub API")
        ce_versions = [i for i in map(lambda x: "ce-%s" % x, fetch_ce_versions(args, distributions))]
        oracle_versions = [i for i in map(lambda x: "oracle-%s" % x, fetch_oracle_versions(args, distributions))]
        return ce_versions + oracle_versions

    return all_versions

def determine_distributions(args):
    """Determine the set of distribution types we should generate release mappings for."""

    all_dists = args.dist or []

    if len(all_dists) == 0:
        logger.debug(
            "No distributions provided via args. Using default set of all: '%s'" % ",".join(DEFAULT_DISTRIBUTIONS)
        )
        return DEFAULT_DISTRIBUTIONS[:]

    logger.debug("Explicit set of distributions resolved: '%s'" % ",".join(all_dists))
    return all_dists

def determine_components(args, distributions, platforms, versions):
    """Determine the set of components which should be downloaded and generated into mappings."""

    all_components = args.components or []

    if args.no_components:
        logger.debug(
            "Args indicate `--no-components`; omitting all components"
        )
        return []

    if len(all_components) == 0:
        logger.debug(
            "No components provided via args. Using default set of all: '%s'" % ",".join(DEFAULT_COMPONENTS)
        )
        return DEFAULT_COMPONENTS[:]

    logger.debug("Explicit set of components resolved: '%s'" % ",".join(all_components))
    return all_components

def determine_javas(args, distributions, platforms, versions):
    """Determine the Java versions we should support for the generated target mappings."""

    all_javas = args.jdks or []

    if len(all_javas) == 0:
        logger.debug(
            "No JDKs provided via args. Using default set of all: '%s'" % ",".join(map(str, DEFAULT_JAVA_VERSIONS))
        )
        return DEFAULT_JAVA_VERSIONS[:]

    logger.debug("Explicit set of JDKs resolved: '%s'" % ",".join(all_javas))
    return all_javas

def target_needs_transitional(target):
    """Return whether a target needs a transitional download URL."""
    return target in _transitional_download_targets

def download_ext_for_target(target, default = "tar.gz"):
    """Resolve the file extension for a download, given the current platform."""
    # we should use zip archives on window
    extension = default
    if "windows" in target.platform:
        extension = "zip"
    return extension

def prepare_download_ctx(target, **kwargs):
    """Prepare context for rendering a download URL."""
    return dict(
        java_version_major = str(target.jdk),
        java_version = str(target.jvm or target.version),
        platform = str(target.platform),
        version = str(target.version),
        **kwargs
    )

def generate_base_download_urls(target):
    """Generate a pair of download URLs for the provided distribution, platform, and version.

    The resulting download URL pair is arranged as a tuple as follows:
    - The primary download URL for the artifact itself, then
    - The SHA256 fingerprint download URL for the artifact

    Args:
        args: Parsed arguments from the command line.
        distribution: Distribution type we're downloading.
        platform: Platform we are downloading for.
        version: Expected version for the resulting artifact.
    """

    template = None
    if target.distribution == Distribution.ORACLE:
        if target.latest:
            template = ORACLE_DOWNLOAD_BASE_LATEST
        else:
            template = ORACLE_DOWNLOAD_BASE_ARCHIVE
    else:
        if target in _transitional_download_targets:
            template = COMMUNITY_DOWNLOAD_BASE_TRANSITIONAL
        else:
            template = COMMUNITY_DOWNLOAD_BASE

    render_ctx = prepare_download_ctx(
        target,
        ext = download_ext_for_target(target),
        repo = target.args.repo_community or DEFAULT_COMMUNITY_REPO,
    )
    artifact = template.format(**render_ctx)
    render_ctx["ext"] = "%s.sha256" % render_ctx["ext"]
    hash = template.format(**render_ctx)
    return (artifact, hash)

def generate_component_download_urls(target):
    """Generate a pair of download URLs for the provided distribution, platform, and version,
    and component name.

    The resulting download URL pair is arranged the same as in `generate_base_download_url`.

    Args:
        args: Parsed arguments from the command line.
        distribution: Distribution type we're downloading.
        platform: Platform we are downloading for.
        version: Expected version for the resulting artifact.
        component: Name of the subject component.
    """

    if target.distribution == Distribution.ORACLE:
        raise NotImplementedError("Can't fetch Oracle components from automated scripts; please rely on `gu`")

    if target in _transitional_download_targets:
        template = COMMUNITY_DOWNLOAD_COMPONENT_TRANSITIONAL
    else:
        template = COMMUNITY_DOWNLOAD_COMPONENT

    # sanity check: we require a component by now
    if not target.component or target.component == Component.BASE:
        raise NotImplementedError("Cannot download nameless component or `BASE` component")

    # use component-specific repositories for applicable components
    repo_target = target.args.repo_community or DEFAULT_COMMUNITY_REPO
    if target.distribution == Distribution.COMMUNITY:
        if target.component in COMMUNITY_COMPONENT_REPOS:
            repo_target = COMMUNITY_COMPONENT_REPOS[target.component]

    render_ctx = prepare_download_ctx(
        target,
        repo = repo_target,
        ext = "jar",
        component = str(target.component),
    )
    artifact = template.format(**render_ctx)
    render_ctx["ext"] = "%s.sha256" % render_ctx["ext"]
    hash = template.format(**render_ctx)

    if target.distribution == Distribution.COMMUNITY:
        # fix: graalvm ce releases use `darwin` in the URL instead of `macos`
        artifact = artifact.replace("macos", "darwin")
        hash = hash.replace("macos", "darwin")

        # fix: graalvm ce releases use `amd64` in the URL instead of `x64`
        artifact = artifact.replace("x64", "amd64")
        hash = hash.replace("x64", "amd64")

    return (artifact, hash)

def filter_supported_targets(args, targets):
    """Filter the provided set of download `targets` based on available support."""
    all_targets = [DownloadTarget(args, t) for t in targets]
    targets_requiring_auth = set()
    targets_requiring_transitional_urls = set()
    allowed_targets = []
    skipped_targets = {}

    if len(MAPPING_RULES) == 0:
        allowed_targets = all_targets[:]
    else:
        for target in all_targets:
            should_skip = False
            for rule in MAPPING_RULES:
                if rule.applies_to(target):
                    for (action, reason) in rule.actions(target):
                        if action == MappingRuleAction.SKIP:
                            should_skip = True
                            skipped_reasons = skipped_targets.get(target, [])
                            skipped_reasons.append(reason)
                            skipped_targets[target] = skipped_reasons
                        elif action == MappingRuleAction.REQUIRE_AUTH:
                            targets_requiring_auth.add(target)
                        elif action == MappingRuleAction.USE_TRANSITIONAL:
                            targets_requiring_transitional_urls.add(target)

            if not should_skip:
                allowed_targets.append(target)

    return (allowed_targets, skipped_targets, targets_requiring_auth, targets_requiring_transitional_urls)

def check_url_liveness(args, url):
    """Check a download URL for validity."""
    logger.debug("Checking URL for liveness: '%s'" % url)
    try:
        result = requests.head(
            url,
            allow_redirects = True,
        )
    except requests.exceptions.ConnectionError as e:
        return False
    if result.status_code == 200:
        return True
    return False

def download_file(args, url):
    """Fetch a download URL endpoint."""
    logger.debug("Downloading from URL: '%s'" % url)
    try:
        response = requests.get(
            url,
            allow_redirects = True,
        )
        if response.status_code == 200:
            return (response, response.status_code)
        return (None, "HTTP error status %s" % response.status_code)
    except requests.exceptions.ConnectionError as e:
        return (None, "Error status -1 (Connection error)")

def download_text(args, url, sanitize = True):
    """Fetch a download URL endpoint."""
    (response, err) = download_file(args, url)
    if response is None:
        return (response, err)
    if response.apparent_encoding is None:
        return (None, "Error -2: Cannot identify encoding")
    decoded = response.content.decode(response.apparent_encoding)
    if sanitize:
        decoded = decoded.replace("\n", "")
    return (decoded, err)

def emit_rendered_mappings(target, rendered):
    """Write the rendered final mappings to the provided stream or file target."""
    # make sure to prime the pipe and include a final newline
    print("", flush = True, file = target)
    print(rendered, flush = True, file = target)
    print("\n", flush = True, file = target)

def print_report(args, javas, platforms, distributions, versions, components, skipped_targets, all_targets):
    """Print a simple report before we proceed with action.
    
    In dry run mode, execution stops after this report is printed."""

    formatted_targets = "\n".join(map(lambda x: "- %s" % str(x), all_targets))
    formatted_skipped_targets = "None.\n"
    if len(skipped_targets) > 0:
        formatted_skipped_targets = ""
        for target in skipped_targets.keys():
            skipped_target_fmt = "- %s\n" % target
            found_version_misalignment = False
            for reason in skipped_targets[target]:
                if reason == "Version misalignment":
                    found_version_misalignment = True
                skipped_target_fmt += "--- Reason: %s\n" % (reason or "Not given")

            if args.debug or (found_version_misalignment == False):
                formatted_skipped_targets += skipped_target_fmt


    mapping_rules = "\n".join(map(lambda x: "- %s" % str(x), MAPPING_RULES))

    if not args.quiet:
        highlight = lambda x: colorize(bold_white, x)
        say(colorize(grey, """
Generating mappings for product of:
- Platforms: {platforms}
- JDKs: {javas}
- Components: {components}
- Distributions: {distributions}
- Versions: {versions}
    """.format(
            platforms = ", ".join(map(highlight, platforms)),
            javas = ", ".join(map(highlight, map(lambda x: "java%s" % x, javas))),
            distributions = ", ".join(map(highlight, distributions)),
            versions = ", ".join(map(highlight, versions)),
            components = ", ".join(map(highlight, components)),
        )))
        logger.debug("""
Mapping rules:
{mapping_rules}

Skipped targets:
{skipped_targets}
Eligible targets:
{targets}
""".format(
            mapping_rules = mapping_rules,
            skipped_targets = formatted_skipped_targets,
            targets = formatted_targets,
        ))

def generate(args):
    """Generate release mappings for the GraalVM Rules for Bazel.
    
    This tool will use a `GITHUB_TOKEN` present in the environment to query GitHub for the
    set of releases available for GraalVM. Then, it generates download URLs for each, with
    knowledge about which versions support which JVM release versions, operating systems,
    and architectures.
    
    Then, downloads are performed against the `sha256` hash for each artifact. The results
    are enclosed in a dict which can be dropped in to a Starlark file.
    
    Args:
        args: Parsed arguments from the command line.
    """

    global client
    global _transitional_download_targets
    global _download_targets_requiring_auth

    # respond to provided args, build client
    exit = handle_flags(args)
    if exit: sys.exit(0)  # the flags told us to exit

    logger.debug("Preparing GitHub authorization")
    client = Github(auth = build_auth())

    # determine the set of versions, platforms, and distribution types we should generate
    # mappings for, either via provided args, or via the set of known defaults.
    subject_distributions = determine_distributions(args)
    subject_platforms = determine_platforms(args, subject_distributions)
    subject_versions = determine_versions(args, subject_distributions, subject_platforms)
    subject_javas = determine_javas(args, subject_distributions, subject_platforms, subject_versions)
    subject_components = determine_components(args, subject_distributions, subject_platforms, subject_versions)

    # if we should generate mappings for releases, include the symbolic `base` component
    base_components = [Component.BASE]
    if args.no_release:
        base_components = []

    # produce full cartesian product of all variants
    all_targets = []
    if args.no_release:
        # if we're not downloading releases, produce a product of all component downloads.
        all_targets += itertools.product(*[
            subject_platforms,
            subject_javas,
            subject_versions,
            subject_components
        ])
    else:
        # otherwise, produce a target list which includes the bases first, and then a filtered
        # set of components.
        all_targets += itertools.product(*[
            subject_platforms,
            subject_javas,
            subject_versions,
            base_components
        ])

        # now append the components, after all bases.
        all_targets += itertools.product(*[
            subject_platforms,
            subject_javas,
            subject_versions,
            subject_components
        ])

    # filter targets based on omission of support for various platform, version, distribution,
    # and component pairs.
    (all_targets, skipped_targets, targets_requiring_auth, targets_requiring_transitional_urls) = (
        filter_supported_targets(args, all_targets)
    )
    if len(targets_requiring_auth) > 0:
        _transitional_download_targets = targets_requiring_auth
    if len(targets_requiring_transitional_urls) > 0:
        _download_targets_requiring_auth = targets_requiring_transitional_urls

    # print a report showing our download targets
    print_report(
        args,
        subject_javas,
        subject_platforms,
        subject_distributions,
        subject_versions,
        subject_components,
        skipped_targets,
        all_targets,
    )

    download_urls = set()
    generated_tasks = []

    # start processing, by generating pairs of download URLs for each target we intend to
    # generate a mapping for. we iterate based on the set of base components first.
    for target in all_targets:
        logger.debug("Processing target '%s'" % target)
        pair = target.generate_download_urls()
        if not pair:
            logger.error("Failed to generate download URL for target: %s" % target)
            return sys.exit(1)
        if pair in download_urls:
            logger.debug("- Found duplicate download URL pair: %s" % str(pair))
            continue
        else:
            download_urls.add(pair)
            generated_tasks.append((target, pair))
            download, sha = pair
            logger.debug("- Generated artifact URL: %s" % download)
            logger.debug("- Generated hash URL: %s" % sha)

    # next, with our unique set of filtered URLs, we can begin downloading and mapping.
    checked_tasks = []
    if args.no_validate:
        checked_tasks = generated_tasks
    else:
        say(colorize(grey, "Validating %s artifact URLs..." % len(generated_tasks)))
        for (task, (download, sha)) in generated_tasks:
            failed = False
            if not check_url_liveness(args, download):
                if args.keep_going:
                    say(colorize(yellow, "✗ URL not valid ") + ("%s " % task) + colorize(grey, download))
                    failed = True
                else:
                    logger.error("Artifact URL liveness check failed: '%s'" % download)
                    sys.exit(2)

            if not check_url_liveness(args, sha):
                if args.keep_going:
                    say(colorize(yellow, "✗ SHA URL not valid ") + ("%s " % task) + colorize(grey, download))
                    failed = True
                else:
                    logger.error("Artifact URL liveness check failed: '%s'" % download)
                    sys.exit(2)

            elif not args.quiet:
                say(colorize(green, "✓ Valid ") + ("%s " % task) + colorize(grey, download.split("/")[-1]))

            if not failed:
                checked_tasks.append((task, (download, sha)))

    check_status = ""
    if len(checked_tasks) == len(generated_tasks):
        check_status = colorize(green, "All targets are valid.")
    else:
        check_status = colorize(yellow, "Some targets failed liveness checks (%s/%s)." % (
            len(generated_tasks) - len(checked_tasks),
            len(generated_tasks)
        ))

    if args.dry:
        say(
            check_status +
            colorize(grey, " Exiting early for dry run; would download ") +
            colorize(cyan, "%s artifacts" % len(checked_tasks)) +
            ".\n"
        )
        return

    say(
        check_status +
        colorize(grey, " Downloading ") +
        colorize(cyan, "%s fingerprints" % len(checked_tasks)) +
        "...\n"
    )
    time.sleep(4)

    # for each mapping, fetch the SHA256
    failed_tasks = []
    registered_hashes = {}
    for (task, (download, sha)) in checked_tasks:
        failed = False
        # sanity check: should only be downloading sha256 files
        if not sha.endswith(".sha256"):
            import pdb; pdb.set_trace()
            raise NotImplementedError("Downloader should not be downloading full artifacts. Please report this.")

        (result, err) = download_text(args, sha)
        if result is None:
            if args.keep_going:
                failed_tasks.append((task, (download, sha)))
                failed = True
                say(colorize(bold_red, "✗ Download failed ") + ("%s " % task) + colorize(grey, err))
                continue
            else:
                logger.error("Artifact URL download failed for target %s: '%s'" % (task, download))
                sys.exit(2)
        else:
            registered_hashes[task] = (download, sha, result)
            say(colorize(green, "✓ SHA256 ") + colorize(grey, result) + (" %s" % task))

    if len(failed_tasks) > 0:
        say(colorize(yellow, "Some targets failed to download (%s/%s).\n" % (
            len(failed_tasks) - len(checked_tasks),
            len(checked_tasks)
        )))
    else:
        say(
            colorize("All target fingerprints obtained. ") +
            colorize(grey, "Building ") +
            colorize(cyan, "%s artifact" % len(checked_tasks)) +
            colorize(grey, " mappings...\n")
        )

    # build mappings in starlark
    mapping_template = """  "%s": {
    # %s
    "url": "%s",
    "sha256": "%s",
  },"""

    mapping_file_template = """
"Binary mappings for GraalVM distribution artifacts."

# ! THIS FILE IS GENERATED. DO NOT EDIT. !

# Last updated: %s by %s

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
)

# Aligned GraalVM distribution versions.
# buildifier: disable=name-conventions
_AlignedVersions = [
    "20.0.2",
    "20.0.1",
    "17.0.8",
    "17.0.7",
]

def _generate_distribution_coordinate(dist, platform, version, component = None):
    \"""Generate a well-formed distribution coordinate key.

    Generates a key for the generated binary distribution map, which holds download
    URLs and known-good integrity values.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        component: Component to download; if downloading a JDK, `None` is expected.

    Returns:
        Generated distribution coordinate key.
    \"""

    segments = [
        dist,
        version,
        platform,
    ]
    if component != None:
        segments.append(component)
    segments.append(version)

    # format:  `<dist>_<rlse>_<platfrm>_<vrsn>`
    # example: `oracle_20.0.2_linux-x64_23.0.1`
    return "_".join(segments)

def _resolve_distribution_artifact(dist, platform, version, component = None):
    \"""Resolve a distribution artifact URL and integrity set.

    Given the provided inputs, attempts to resolve a distribution config payload
    which includes an artifact URL and integrity values. If no matching artifact
    can be located, an error is thrown.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        component: Component to download; if downloading a JDK, `None` is expected.

    Returns:
        Distribution artifact config payload, or throws.
    \"""

    target_key = _generate_distribution_coordinate(dist, platform, version, component)
    config = _GRAALVM_BINDIST[target_key]
    if config == None:
        fail("Failed to resolve distribution artifact at key '" + target_key + "'")
    return config

# Generated mappings.
_GRAALVM_BINDIST = {
%s
}

# Exports.

# buildifier: disable=name-conventions
DistributionType = _DistributionType
# buildifier: disable=name-conventions
DistributionPlatform = _DistributionPlatform
# buildifier: disable=name-conventions
DistributionComponent = _DistributionComponent
# buildifier: disable=name-conventions
AlignedVersions = _AlignedVersions
generate_distribution_coordinate = _generate_distribution_coordinate
resolve_distribution_artifact = _resolve_distribution_artifact
"""

    rendered_mappings = {}
    for (task, (download, sha, result)) in registered_hashes.items():
        coordinate = task.coordinate()
        rendered_mappings[coordinate] = (mapping_template % (
            coordinate,
            task.description(),
            download,
            result,
        ))

    sorted_mappings = []
    for key in sorted(rendered_mappings.keys()):
        rendered = rendered_mappings[key]
        sorted_mappings.append(rendered)

    # render the final file
    rendered_mappings_file = mapping_file_template % (
        datetime.now().isoformat(), # timestamp
        os.environ.get("USER", "Sandboxed user"), # timestamp
        "\n".join(sorted_mappings),  # mappings
    )

    outstream = sys.stdout
    if not args.no_render:
        if args.out and args.out != "-":
            logger.debug("Writing output to file '%s'" % args.out)
            try:
                with open(os.path.abspath(), "w") as outfile:
                    say(colorize(grey, "Writing mappings to output file '%s'..." % args.out))
                    emit_rendered_mappings(outfile, rendered_mappings_file)
                    logger.debug("Wrote to file successfully.")

            except IOError as e:
                logger.error("Failed to write to output file.", e)
                sys.exit(3)
        else:
            logger.debug("Writing rendered output to stdout, as no file was provided")
            say(colorize(grey, "Emitting rendered file to stdout."))
            emit_rendered_mappings(outstream, rendered_mappings_file)

    say(colorize(green, "All done. Enjoy. 🎉🥳"))
    print("", flush = True)  # terminate stream cleanly
    sys.exit(0)

def invoke():
    """Run the mappings generator."""

    try:
        generate(args = parser.parse_args())
    except KeyboardInterrupt as e:
        say(colorize(yellow, "Exiting on keyboard interrupt."))

if __name__ == "__main__": invoke()
