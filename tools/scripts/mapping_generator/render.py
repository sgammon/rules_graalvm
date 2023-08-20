"""
Utilities for rendering and writing the generated Starlark mappings file.
"""

import os
import sys
import stat

from .logger import logger, say, colorize, grey

mapping_template = """  "%s": {
    # %s
    "url": "%s",
    "sha256": "%s",
    "compatible_with": [
%s
    ],
  },"""

mapping_file_template = """"Binary mappings for GraalVM distribution artifacts."

# ! THIS FILE IS GENERATED. DO NOT EDIT. !

# Last updated: %s by %s

# To learn how to regenerate this file, consult the contributor docs for
# the `rules_graalvm` repository: https://github.com/sgammon/rules_graalvm

# Enumerates available distribution types.
# buildifier: disable=name-conventions
_DistributionType = struct(
    ORACLE = "oracle",
    COMMUNITY = "ce",
    ENTERPRISE = "ee",
)

# Enumerates available platform types.
# buildifier: disable=name-conventions
_DistributionPlatform = struct(
    MACOS_X64 = "macos-x64",
    MACOS_AARCH64 = "macos-aarch64",
    LINUX_X64 = "linux-x64",
    LINUX_AARCH64 = "linux-aarch64",
    WINDOWS_X64 = "windows-x64",
)

# Enumerates available platform types.
# buildifier: disable=name-conventions
_DistributionComponent = struct(
    NATIVE_IMAGE = "native-image",
    JS = "js",
    WASM = "wasm",
    PYTHON = "python",
    LLVM = "llvm",
    RUBY = "ruby",
)

# Aligned GraalVM distribution versions.
# buildifier: disable=name-conventions
_AlignedVersions = [
    "20.0.2",
    "20.0.1",
    "17.0.8",
    "17.0.7",
]

def _generate_distribution_coordinate(dist, platform, version, component = None):
    \"""Generate a well-formed distribution coordinate key.

    Generates a key for the generated binary distribution map, which holds download
    URLs and known-good integrity values.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        component: Component to download; if downloading a JDK, `None` is expected.

    Returns:
        Generated distribution coordinate key.
    \"""

    segments = [
        dist,
        version,
        platform,
    ]
    if component != None:
        segments.append(component)
    segments.append(version)

    # format:  `<dist>_<rlse>_<platfrm>_<vrsn>`
    # example: `oracle_20.0.2_linux-x64_23.0.1`
    return "_".join(segments)

def _resolve_distribution_artifact(dist, platform, version, component = None):
    \"""Resolve a distribution artifact URL and integrity set.

    Given the provided inputs, attempts to resolve a distribution config payload
    which includes an artifact URL and integrity values. If no matching artifact
    can be located, an error is thrown.

    Args:
        dist: Distribution for the coordinate (a `DistributionType`).
        platform: Platform for the release (a `DistributionPlatform`).
        version: Version string for the GraalVM release (aligned releases accepted).
        component: Component to download; if downloading a JDK, `None` is expected.

    Returns:
        Distribution artifact config payload, or throws.
    \"""

    target_key = _generate_distribution_coordinate(dist, platform, version, component)
    config = _GRAALVM_BINDIST[target_key]
    if config == None:
        fail("Failed to resolve distribution artifact at key '" + target_key + "'")
    return config

# Generated mappings.
_GRAALVM_BINDIST = {
%s
}

# Exports.

# buildifier: disable=name-conventions
DistributionType = _DistributionType
# buildifier: disable=name-conventions
DistributionPlatform = _DistributionPlatform
# buildifier: disable=name-conventions
DistributionComponent = _DistributionComponent
# buildifier: disable=name-conventions
AlignedVersions = _AlignedVersions
generate_distribution_coordinate = _generate_distribution_coordinate
resolve_distribution_artifact = _resolve_distribution_artifact"""


def emit_rendered_mappings(target, rendered):
    """Write the rendered final mappings to the provided stream or file target."""
    # make sure to prime the pipe and include a final newline
    print(rendered, flush=True, file=target)


def write_rendered_mappings(args, timestamp, rendered_mappings_file):
    """Write the rendered mappings file to the requested target (or stdout)."""

    outstream = sys.stdout
    if not args.no_render:
        bazel_mappings_update = os.environ.get("BAZEL_MAPPINGS_UPDATE")
        bazel_mappings_target = os.environ.get("BAZEL_MAPPINGS_SRC")
        bazel_stamp_file = os.environ.get("BAZEL_BINDIST_STAMP")

        if args.out and args.out != "-" or (bazel_mappings_update == "1"):
            target_file = bazel_mappings_target or os.path.abspath(args.out)
            logger.debug("Writing output to file '%s'" % target_file)
            try:
                with open(target_file, "w") as outfile:
                    say(colorize(grey, "Writing mappings to output file '%s'..." % target_file))
                    emit_rendered_mappings(outfile, rendered_mappings_file)
                    logger.debug("Wrote to file successfully.")

            except IOError as e:
                logger.error("Failed to write to output file.", e)
                sys.exit(3)

            if bazel_stamp_file is not None:
                try:
                    # write stamp file
                    stamp_abs = os.path.abspath(bazel_stamp_file)
                    say(colorize(grey, "Writing to Bazel stamp file '%s'..." % stamp_abs))
                    with open(stamp_abs, 'w') as stampfile:
                        stampfile.writelines([
                            "#!/bin/env bash\n",
                            "echo \"Updated mappings at: %s\";\n" % timestamp.isoformat(),
                        ])

                    st = os.stat(stamp_abs)
                    os.chmod(stamp_abs, st.st_mode | stat.S_IEXEC)

                except IOError as e:
                    logger.error("Failed to write to Bazel stamp file. Bazel build may fail.", e)

        else:
            logger.debug("Writing rendered output to stdout, as no file was provided")
            say(colorize(grey, "Emitting rendered file to stdout."))
            emit_rendered_mappings(outstream, rendered_mappings_file)
