"""
Defines CLI arguments and processing for the mapping generator tool.
"""

import argparse
from .constants import *

# Argument parser
parser = argparse.ArgumentParser(
    prog="mapping_generator",
    epilog="Copyright (c) Elide Ventures, LLC. All rights reserved.",
    description="""
Generates Starlark mappings for GraalVM release artifacts.
Provide release tags to generate mappings for specific releases,
or omit tags entirely to crawl the entire set of releases from GitHub.

For Oracle GVM releases, this script accesses Oracle's download service.
""",
)

parser.add_argument(
    "-v", "--verbose",
    action="store_true",
    help="Enable verbose logging output",
)

parser.add_argument(
    "--debug",
    action="store_true",
    help="Enable extra debugging features",
)

parser.add_argument(
    "-o", "--out",
    type=str,
    help="Set output file; if omitted, generated mappings are printed to stdout.",
)

parser.add_argument(
    "-q", "--quiet",
    action="store_true",
    help="Reduce logging output. Wins over verbose mode.",
)

parser.add_argument(
    "--no-color",
    action="store_true",
    help="Reduce logging output. Wins over verbose mode.",
)

parser.add_argument(
    "--no-validate",
    action="store_true",
    help="Suppress validations of download URLs. Strongly recommended not to turn these off.",
)

parser.add_argument(
    "--no-check",
    action="store_true",
    help="Suppress checks of SHA256 hashes. Strongly recommended not to turn these off.",
)

parser.add_argument(
    "--no-render",
    action="store_true",
    help="Skip rendering the final file (performs all other steps, modulo other flags).",
)

parser.add_argument(
    "--dry",
    action="store_true",
    help="Don't actually do anything, just plan and exit.",
)

parser.add_argument(
    "--latest",
    action="store_true",
    help="Fetch only the latest release. Takes precedence over all other version selectors.",
)

parser.add_argument(
    "--keep_going",
    action="store_true",
    help="Consider artifacts which don't fetch to be warnings, not errors.",
)

parser.add_argument(
    "--repo-community",
    type=str,
    help="Custom GitHub repositiory to use for Community releases; use format 'org/repo'.",
)

parser.add_argument(
    '--no-release',
    help="Whether to include release fingerprints. Defaults to `true`.",
    action="store_true",
)

parser.add_argument(
    '--no-components',
    help="Omit components from downloads and generated mappings.",
    action="store_true",
)

parser.add_argument(
    '--components',
    nargs="*",
    help="Components to include in generated mappings. Optional; defaults to all known.",
    choices=DEFAULT_COMPONENTS,
)

parser.add_argument(
    '--platforms',
    nargs="*",
    help="OS/arch pairs to generate mappings for. Optiona; defaults to all known.",
    choices=DEFAULT_PLATFORMS,
)

parser.add_argument(
    '--tags',
    nargs="*",
    help="Release tags to generate mappings for. Multiple uses are accumulated.",
)

parser.add_argument(
    '--jdks',
    nargs="*",
    help="JVM versions to generate mappings for; defaults to the full set of known versions.",
)

parser.add_argument(
    '--distributions',
    nargs="*",
    help="Distributions to generate mappings for; accepts ORACLE and COMMUNITY. Defaults to both.",
    choices=DEFAULT_DISTRIBUTIONS,
)
