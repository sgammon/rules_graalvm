"""
Utilities for downloading assets over HTTP(s) via the mapping generator tool.
"""

import requests

from .definitions import *
from .constants import *
from .logger import logger

# Transitional URL download targets
_transitional_download_targets = set()


def prepare_download_ctx(target, **kwargs):
    """Prepare context for rendering a download URL."""
    return dict(
        java_version_major = str(target.jdk),
        java_version = str(target.jvm or target.version),
        platform = str(target.platform),
        version = str(target.version),
        **kwargs
    )

def download_ext_for_target(target, default = "tar.gz"):
    """Resolve the file extension for a download, given the current platform."""
    # we should use zip archives on window
    extension = default
    if "windows" in target.platform:
        extension = "zip"
    return extension

def target_needs_transitional(target):
    """Return whether a target needs a transitional download URL."""
    return target in _transitional_download_targets

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
