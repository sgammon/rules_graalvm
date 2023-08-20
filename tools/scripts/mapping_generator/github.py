"""
Defines GitHub utilities for the mapping generator tool.
"""

import os, sys

from github import Github
from github import Auth

from .definitions import *
from .constants import *
from .logger import logger
from .config import ALIGNMENT_VERSIONS, TRANSITIONAL_RELEASES

# GitHub client
__client = None

def build_auth():
    """Build auth credentials for use with the GitHub API, if applicable."""

    token = os.environ.get("GITHUB_TOKEN")
    if token is not None and len(token) > 0:
        logger.debug("GITHUB_TOKEN environment variable found; using it")
        return Auth.Token(token)
    logger.debug("No GITHUB_TOKEN found; skipping auth")
    return None

def initialize_github_client():
    """Initialize the GitHub client and build auth info."""

    global __client
    __client = Github(auth = build_auth())

def obtain_github_client():
    """Fetch the GitHub client singleton."""
    if __client is None:
        raise Exception("Cannot use GitHub client before it is initialized")
    return __client

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

def fetch_ce_versions(args, distributions):
    """Fetch available release versions from the Community repo."""

    all_ce_versions = []
    if Distribution.COMMUNITY not in distributions:
        logger.debug("Skipping CE version fetch: Not included in distributions")
        return all_ce_versions

    ce_repo = args.repo_community or DEFAULT_COMMUNITY_REPO
    logger.debug("Resolving Community Edition versions from repo '%s'" % ce_repo)

    fetched_repo = obtain_github_client().get_repo(ce_repo)

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
