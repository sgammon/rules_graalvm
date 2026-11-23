#!/usr/bin/env python3
"""Generate `_GRAALVM_BINDIST` entries for a GraalVM Community release.

Usage:
    python3 tools/scripts/ce_release_entries.py graal-25.5.5.0.3 [graal-... ...]

Reads the release's assets from `graalvm/graalvm-ce-builds`, takes each archive's
sha256 from its published `.sha256` sidecar, and reads the archive's top-level
directory (the `prefix`) from the start of the Linux x64 tarball. Prints Starlark
dict entries to paste into `internal/graalvm_bindist_map.bzl`, plus the version
table rows that go with them.

Only GraalVM "Innovation" releases (tags `graal-<graalvm version>`) are handled;
their archives are named `graalvm-community-jdk-<N>i<M>-<jdk version>_<platform>_bin.*`.

Set `GITHUB_TOKEN` to avoid GitHub API rate limits. Uses the standard library only.
"""

import json
import os
import re
import sys
import tarfile
import urllib.request

_REPO = "graalvm/graalvm-ce-builds"
_ASSET = re.compile(
    r"^graalvm-community-jdk-(?P<major>\d+)i(?P<innovation>\d+)-(?P<jdk>[\d.]+)"
    r"_(?P<platform>(?:linux|macos|windows)-(?:x64|aarch64))_bin\.(?:tar\.gz|zip)$",
)
_OS = {"linux": ("linux", "Linux"), "macos": ("macos", "macOS"), "windows": ("windows", "Windows")}
_CPU = {"x64": ("x86_64", "amd64"), "aarch64": ("aarch64", "arm64")}


def _get(url, accept=None):
    headers = {"User-Agent": "rules_graalvm-release-entries"}
    if accept:
        headers["Accept"] = accept
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    if token and url.startswith("https://api.github.com/"):
        headers["Authorization"] = "Bearer " + token
    return urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=120)


def _prefix(url):
    """Return the archive's top-level directory, reading only the first tar member."""
    with _get(url) as resp, tarfile.open(fileobj=resp, mode="r|gz") as tar:
        for member in tar:
            return member.name.split("/", 1)[0]
    raise SystemExit("empty archive: " + url)


def _entries(tag):
    if not tag.startswith("graal-"):
        raise SystemExit("expected an Innovation release tag like `graal-25.5.5.0.3`, got: " + tag)
    graal_version = tag[len("graal-"):]
    release = json.load(_get("https://api.github.com/repos/%s/releases/tags/%s" % (_REPO, tag)))
    assets = {a["name"]: a["browser_download_url"] for a in release["assets"]}

    archives = []
    for name, url in sorted(assets.items()):
        match = _ASSET.match(name)
        if match:
            archives.append((match, url))
    if not archives:
        raise SystemExit("no archives matched in release " + tag)

    jdk_versions = {m.group("jdk") for m, _ in archives}
    if len(jdk_versions) != 1:
        raise SystemExit("expected one JDK version in %s, found %s" % (tag, sorted(jdk_versions)))
    jdk_version = jdk_versions.pop()

    tarball = next(url for m, url in archives if m.group("platform") == "linux-x64")
    prefix = _prefix(tarball)

    out = []
    for match, url in archives:
        sidecar = assets.get(match.group(0) + ".sha256")
        if not sidecar:
            raise SystemExit("missing .sha256 for " + match.group(0))
        sha256 = _get(sidecar).read().decode().split()[0].strip()
        if not re.fullmatch(r"[0-9a-f]{64}", sha256):
            raise SystemExit("bad sha256 for %s: %r" % (match.group(0), sha256))
        os_name, cpu_name = match.group("platform").split("-")
        os_constraint, os_label = _OS[os_name]
        cpu_constraint, cpu_label = _CPU[cpu_name]
        major = match.group("major")
        out.append("\n".join([
            '    "ce_%s_%s_%s": {' % (jdk_version, match.group("platform"), graal_version),
            "        # GraalVM CE %s Innovation %s (Java %s), %s (%s), Version %s" % (
                major, match.group("innovation"), jdk_version, os_label, cpu_label, graal_version),
            '        "url": "%s",' % url,
            '        "sha256": "%s",' % sha256,
            '        "prefix": "%s",' % prefix,
            '        "compatible_with": [',
            '            "@platforms//cpu:%s",' % cpu_constraint,
            '            "@platforms//os:%s",' % os_constraint,
            '            "@rules_graalvm//platform/jvm:java%s",' % major,
            "        ],",
            "    },",
        ]))
    return graal_version, jdk_version, out


def main(tags):
    if not tags:
        raise SystemExit(__doc__)
    tables = []
    for tag in tags:
        graal_version, jdk_version, entries = _entries(tag)
        print("\n".join(entries))
        tables.append((graal_version, jdk_version))
    print("\n# _InnovationVersions:")
    for graal_version, jdk_version in tables:
        print('    "%s": "%s",' % (graal_version, jdk_version))
    print("# _CommunityAlignedVersions:")
    for graal_version, jdk_version in tables:
        print('    "%s": "%s",' % (jdk_version, graal_version))


if __name__ == "__main__":
    main(sys.argv[1:])
