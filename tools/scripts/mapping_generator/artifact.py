"""
Defines utilities and classes for working with downloaded artifacts and their hashes.
"""

from .constants import *
from .downloader import generate_base_download_urls, generate_component_download_urls
from .versions import ParsedVersion


class DownloadTarget:
    """Resolved target for download and inclusion in output mappings."""

    def __init__(self, args, quad):
        platform, jdk, version, component = quad

        self.args = args
        self.platform = Platform(platform)
        self.component = Component(component)
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
            java_major=self.jdk,
            type=typelabel,
            java=self.jvm is not None and ("/%s" % self.jvm) or "",
            distribution=str(self.distribution),
            platform=str(self.platform),
            component=str(self.component),
            version=str(self.version or (self.latest and "latest")),
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

    def constraints(self):
        """Generate a set of Bazel Platforms constraints matching this target."""
        tags = [] + (
            PLATFORM_TAG_MAPPINGS[self.platform]
        ) + [
            JAVA_VERSION_TAGS[JavaVersion(int(self.jdk))]
        ]

        if self.component is not None and self.component != Component.BASE:
            if self.component in COMPONENT_TAGS:
                tags.extend(COMPONENT_TAGS[self.component])

        return tags

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
