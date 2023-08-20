"""
Defines logic for calculating the set of artifacts to work with in the mapping generator tool.
"""

from .repo import *
from .oracle_gds import *


def determine_platforms(args):
    """Determine the set of platforms we should generate release mappings for."""

    all_platforms = DEFAULT_PLATFORMS[:]
    target_platforms = args.platforms or []
    if len(target_platforms) > 0:
        logger.debug("Using explicit set of target platforms: '%s'" % ",".join(target_platforms))
        return target_platforms
    else:
        logger.debug("Using default set of all platforms: '%s'" % ",".join(all_platforms))
        return all_platforms


def determine_versions(args, distributions):
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

    all_dists = args.distributions or []

    if len(all_dists) == 0:
        logger.debug(
            "No distributions provided via args. Using default set of all: '%s'" % ",".join(DEFAULT_DISTRIBUTIONS)
        )
        return DEFAULT_DISTRIBUTIONS[:]

    logger.debug("Explicit set of distributions resolved: '%s'" % ",".join(all_dists))
    return all_dists


def determine_components(args):
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


def determine_javas(args):
    """Determine the Java versions we should support for the generated target mappings."""

    all_javas = args.jdks or []

    if len(all_javas) == 0:
        logger.debug(
            "No JDKs provided via args. Using default set of all: '%s'" % ",".join(map(str, DEFAULT_JAVA_VERSIONS))
        )
        return DEFAULT_JAVA_VERSIONS[:]

    logger.debug("Explicit set of JDKs resolved: '%s'" % ",".join(all_javas))
    return all_javas
