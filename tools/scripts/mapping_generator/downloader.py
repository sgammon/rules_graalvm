"""
Utilities for downloading assets over HTTP(s) via the mapping generator tool.
"""

import requests
import grequests

from .constants import *
from .logger import logger

# Transitional URL download targets
_transitional_download_targets = set()

# Download targets requiring auth
_download_targets_requiring_auth = set()

# Maximum in-flight requests at any time
MAX_IN_FLIGHT_REQUESTS = 50


def prepare_download_ctx(target, **kwargs):
    """Prepare context for rendering a download URL."""

    # fix: graalvm for java21 is expressed as "21" instead of "21.0.0"
    java_version = str(target.jvm or target.version)
    if target.distribution == Distribution.ORACLE and java_version == "21.0.0":
        java_version = "21"

    return dict(
        java_version_major=str(target.jdk),
        java_version=java_version,
        platform=str(target.platform),
        version=str(target.version),
        **kwargs
    )


def download_ext_for_target(target, default="tar.gz"):
    """Resolve the file extension for a download, given the current platform."""
    # we should use zip archives on windows
    extension = default
    if "windows" in target.platform:
        extension = "zip"
    return extension


def target_needs_transitional(target):
    """Return whether a target needs a transitional download URL."""
    return target in _transitional_download_targets


def begin_download(url):
    """Begin an asynchronous download."""
    logger.debug("Beginning downloading from URL: '%s'" % url)
    return grequests.get(
        url,
        allow_redirects=True,
    )


def download_file(url):
    """Fetch a download URL endpoint."""
    logger.debug("Downloading from URL: '%s'" % url)
    try:
        response = requests.get(
            url,
            allow_redirects=True,
        )
        if response.status_code == 200:
            return response, response.status_code
        return None, "HTTP error status %s" % response.status_code
    except requests.exceptions.ConnectionError:
        return None, "Error status -1 (Connection error)"


def complete_download(response):
    """Complete an asynchronous download."""
    if isinstance(response, tuple):
        return response  # already an error tuple
    if response.status_code == 200:
        return response, response.status_code
    return None, "HTTP error status %s" % response.status_code


def download_text(url, sanitize=True):
    """Fetch a download URL endpoint."""
    (response, err) = download_file(url)
    return decode_response_as_text(response, err, sanitize)


def decode_response_as_text(response, err, sanitize):
    if response is None:
        return response, err
    if response.apparent_encoding is None:
        return None, "Error -2: Cannot identify encoding"
    decoded = response.content.decode(response.apparent_encoding)
    if sanitize:
        decoded = decoded.replace("\n", "")
    return decoded, err


def complete_text_download(response, sanitize=True):
    """Fetch a download URL endpoint."""
    (response, err) = complete_download(response)
    return decode_response_as_text(response, err, sanitize)


def check_url_liveness(url):
    """Check a download URL for validity."""
    logger.debug("Checking URL for liveness: '%s'" % url)
    try:
        result = requests.head(
            url,
            allow_redirects=True,
        )
    except requests.exceptions.ConnectionError:
        return False
    return complete_url_liveness_check(result)


def check_url_liveness_async(url):
    """Check a download URL for validity."""
    logger.debug("Beginning URL liveness check: '%s'" % url)
    return grequests.head(
        url,
        allow_redirects=True,
    )


def complete_url_liveness_check(response):
    """Complete an asynchronous URL liveness check."""
    assert response.response is not None

    if response.response.status_code == 200:
        return True
    return False


def download_err_handler(request, exception):
    """Handle an exception that surfaced during an asynchronous download."""
    logger.debug("Error downloading URL: '%s'" % request.url)
    if isinstance(exception, requests.exceptions.ConnectionError):
        return None, "Error status -1 (Connection error)"
    return None, "Unknown error (%s)" % exception


def execute_async_requests(all_requests, exception_handler=None):
    """Execute all async requests, handling exceptions as we go."""
    return grequests.imap_enumerated(
        all_requests,
        size=MAX_IN_FLIGHT_REQUESTS,
        exception_handler=exception_handler or download_err_handler
    )


def generate_base_download_urls(target):
    """Generate a pair of download URLs for the provided distribution, platform, and version.

    The resulting download URL pair is arranged as a tuple as follows:
    - The primary download URL for the artifact itself, then
    - The SHA256 fingerprint download URL for the artifact

    Args:
        :param target: Target to generate download URLs for.
    """

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
        ext=download_ext_for_target(target),
        repo=target.args.repo_community or DEFAULT_COMMUNITY_REPO,
    )
    artifact = template.format(**render_ctx)
    render_ctx["ext"] = "%s.sha256" % render_ctx["ext"]
    hashval = template.format(**render_ctx)
    return artifact, hashval


def generate_component_download_urls(target):
    """Generate a pair of download URLs for the provided distribution, platform, and version and component name.

    The resulting download URL pair is arranged the same as in `generate_base_download_url`.

    Args:
        :param target: Target to generate download URLs for.
    """

    if target.distribution == Distribution.ORACLE:
        raise NotImplementedError("Can't fetch Oracle components from automated scripts; please rely on `gu`")

    if target in _transitional_download_targets:
        template = COMMUNITY_DOWNLOAD_COMPONENT_TRANSITIONAL
    else:
        template = COMMUNITY_DOWNLOAD_COMPONENT

    # check: we require a component by now
    if not target.component or target.component == Component.BASE:
        raise NotImplementedError("Cannot download nameless component or `BASE` component")

    # use component-specific repositories for applicable components
    repo_target = target.args.repo_community or DEFAULT_COMMUNITY_REPO
    if target.distribution == Distribution.COMMUNITY:
        if target.component in COMMUNITY_COMPONENT_REPOS:
            repo_target = COMMUNITY_COMPONENT_REPOS[target.component]

    render_ctx = prepare_download_ctx(
        target,
        repo=repo_target,
        ext="jar",
        engine=NON_SVM_COMPONENTS.get(target.component) or "installable-svm",
        component=str(target.component),
    )
    artifact = template.format(**render_ctx)
    render_ctx["ext"] = "%s.sha256" % render_ctx["ext"]
    hashval = template.format(**render_ctx)

    if target.distribution == Distribution.COMMUNITY:
        # fix: graalvm ce releases use `darwin` in the URL instead of `macos`
        artifact = artifact.replace("macos", "darwin")
        hashval = hashval.replace("macos", "darwin")

        # fix: graalvm ce releases use `amd64` in the URL instead of `x64`
        artifact = artifact.replace("x64", "amd64")
        hashval = hashval.replace("x64", "amd64")

    return artifact, hashval


def register_transitional_target(target):
    """Register an artifact target as requiring transitional URLs."""
    _transitional_download_targets.add(target)


def register_target_requiring_auth(target):
    """Register an artifact target as requiring authentication to download."""
    _download_targets_requiring_auth.add(target)
