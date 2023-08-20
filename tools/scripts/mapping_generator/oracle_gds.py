"""
Defines utilities for interacting with Oracle's download service in the mapping generator tool.
"""

from .definitions import Distribution
from .logger import logger

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
