"""
Defines the classes used for mapping generator artifact rules.
"""

from abc import ABC, abstractmethod
from enum import StrEnum

from .constants import *
from .logger import logger
from .versions import ParsedVersion


class MappingRuleAction(StrEnum):
    """Enumerates the actions that can be taken on an artifact which matches a rule."""

    SKIP = "SKIP"
    REQUIRE_AUTH = "REQUIRE_AUTH"
    USE_TRANSITIONAL = "USE_TRANSITIONAL"


class RuleMatchMode(StrEnum):
    """Match mode for rules."""

    ANY = "ANY"
    ALL = "ALL"


def _setify(value):
    if isinstance(value, str):
        return {value}
    elif isinstance(value, set):
        return value
    else:
        return set(value)


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
                 reason=None,
                 version_min=None,
                 version_max=None,
                 versions=None,
                 jdks=None,
                 platforms=None,
                 distributions=None,
                 components=None):
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
            action=", ".join(map(lambda x: str(x), self._actions)),
            reason=self.reason or "Not given",
            mode=self.mode,
            criteria=", ".join(criteria),
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
            action=MappingRuleAction.SKIP,
            mode=RuleMatchMode.ALL,
            jdks=jdks,
            version_min=cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def supported_jvms_after(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action=MappingRuleAction.SKIP,
            mode=RuleMatchMode.ALL,
            jdks=[i for i in DEFAULT_JAVA_VERSIONS if i not in jdks],
            version_min=cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def unsupported_jvms_at(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a specific GraalVM version."""
        return Rule(
            action=MappingRuleAction.SKIP,
            mode=RuleMatchMode.ALL,
            jdks=jdks,
            versions=[cls.parse_version_maybe(version)],
            **kwargs
        )

    @classmethod
    def supported_jvms_at(cls, version, *jdks, **kwargs):
        """Return a rule which restricts a download to a specific GraalVM version."""
        return Rule(
            action=MappingRuleAction.SKIP,
            mode=RuleMatchMode.ALL,
            jdks=[i for i in DEFAULT_JAVA_VERSIONS if i not in jdks],
            versions=[cls.parse_version_maybe(version)],
            **kwargs
        )

    @classmethod
    def at_least_version(cls, version, mode=RuleMatchMode.ALL, action=MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action=action,
            mode=mode,
            version_min=cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def at_most_version(cls, version, mode=RuleMatchMode.ALL, action=MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action=action,
            mode=mode,
            version_max=cls.parse_version_maybe(version),
            **kwargs
        )

    @classmethod
    def at_version(cls, version, mode=RuleMatchMode.ALL, action=MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download to a GraalVM minimum version."""
        return Rule(
            action=action,
            mode=mode,
            versions=[cls.parse_version_maybe(version)],
            **kwargs
        )

    @classmethod
    def for_distribution(cls, distribution, mode=RuleMatchMode.ALL, action=MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download for a GraalVM distribution."""
        return Rule(
            action=action,
            mode=mode,
            distributions=[distribution],
            **kwargs
        )

    @classmethod
    def for_platform(cls, platform, mode=RuleMatchMode.ALL, action=MappingRuleAction.SKIP, **kwargs):
        """Return a rule which restricts a download on a speciic platform."""
        return Rule(
            action=action,
            mode=mode,
            platforms=[platform],
            **kwargs
        )

    def applies_to(self, target):
        """Decide whether this skip rule applies to the provided target."""
        from .config import MAPPING_RULES
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

        mode = all
        if self.mode == RuleMatchMode.ANY:
            mode = any

        # if this rule has version constraints, and we're evaluating a "latest"
        # SDK version, we should not apply the rule.
        if target.latest and any(filter(lambda x: x is not None, [self.versions, self.version_min, self.version_max])):
            # corner case: if the rule is "latest," the greatest available `version_min` rules
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


COMPONENTS_DEPRECATED_AT = ParsedVersion.of("23.1.0")

class ComponentDeprecationRule(AbstractRule):
    """Enforce that components are distributed via Maven after Java 21/GraalVM 23.1.0."""

    def applies_to(self, target):
        if target.version == COMPONENTS_DEPRECATED_AT and target.component != Component.BASE:
            return True  # need to reject
        return False

    def actions(self, target):
        return [(MappingRuleAction.SKIP, "Components are distributed via Maven at GraalVM 23.1.0 and above")]


def filter_supported_targets(args, targets):
    """Filter the provided set of download `targets` based on available support."""
    from .artifact import DownloadTarget
    from .config import MAPPING_RULES

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

    return allowed_targets, skipped_targets, targets_requiring_auth, targets_requiring_transitional_urls
