"""
Semantic version parsing utility.
"""

import semver

class ParsedVersion:
    """Lightweight value class which wraps a parsed Semantic Version string."""

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
