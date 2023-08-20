#!/bin/env python

"""
  Mappings Generator
  ------------------

  Generates Starlark SHA256 mappings for GraalVM artifacts.
"""

import time
import itertools
from datetime import datetime

from .logger import *
from .cli import *
from .downloader import *
from .matrix import *
from .render import *
from .config import *


def generate(args):
    """Generate release mappings for the GraalVM Rules for Bazel.
    
    This tool will use a `GITHUB_TOKEN` present in the environment to query GitHub for the set of releases available for
    GraalVM. Then, it generates download URLs for each, with knowledge about which versions support which JVM release
    versions, operating systems, and architectures.
    
    Then, downloads are performed against the `sha256` hash for each artifact. The results are enclosed in a dict which
    can be dropped in to a Starlark file.

    Args:
        :param args: Parsed arguments from the command line.
    """

    # respond to provided args, build client
    should_exit = handle_flags(args)
    if should_exit:
        sys.exit(0)  # the flags told us to exit

    logger.debug("Preparing GitHub authorization")
    initialize_github_client()
    timestamp = datetime.now()

    # determine the set of versions, platforms, and distribution types we should generate
    # mappings for, either via provided args, or via the set of known defaults.
    subject_distributions = determine_distributions(args)
    subject_javas = determine_javas(args)
    subject_platforms = determine_platforms(args)
    subject_components = determine_components(args)
    subject_versions = determine_versions(args, subject_distributions)

    # if we should generate mappings for releases, include the symbolic `base` component
    base_components = [Component.BASE]
    if args.no_release:
        base_components = []

    # produce full cartesian product of all variants
    all_targets = []
    if args.no_release:
        # if we're not downloading releases, produce a product of all component downloads.
        all_targets += itertools.product(*[
            subject_platforms,
            subject_javas,
            subject_versions,
            subject_components
        ])
    else:
        # otherwise, produce a target list which includes the bases first, and then a filtered
        # set of components.
        all_targets += itertools.product(*[
            subject_platforms,
            subject_javas,
            subject_versions,
            base_components
        ])

        # now append the components, after all bases.
        all_targets += itertools.product(*[
            subject_platforms,
            subject_javas,
            subject_versions,
            subject_components
        ])

    # filter targets based on omission of support for various platform, version, distribution,
    # and component pairs.
    (all_targets, skipped_targets, targets_requiring_auth, targets_requiring_transitional_urls) = (
        filter_supported_targets(args, all_targets)
    )
    if len(targets_requiring_auth) > 0:
        for target in targets_requiring_auth:
            register_transitional_target(target)
    if len(targets_requiring_transitional_urls) > 0:
        for target in targets_requiring_auth:
            register_target_requiring_auth(target)

    # print a report showing our download targets
    print_report(
        args,
        subject_javas,
        subject_platforms,
        subject_distributions,
        subject_versions,
        subject_components,
        skipped_targets,
        all_targets,
    )

    download_urls = set()
    generated_tasks = []

    # start processing, by generating pairs of download URLs for each target we intend to
    # generate a mapping for. we iterate based on the set of base components first.
    for target in all_targets:
        logger.debug("Processing target '%s'" % target)
        pair = target.generate_download_urls()
        if not pair:
            logger.error("Failed to generate download URL for target: %s" % target)
            return sys.exit(1)
        if pair in download_urls:
            logger.debug("- Found duplicate download URL pair: %s" % str(pair))
            continue
        else:
            download_urls.add(pair)
            generated_tasks.append((target, pair))
            download, sha = pair
            logger.debug("- Generated artifact URL: %s" % download)
            logger.debug("- Generated hash URL: %s" % sha)

    # next, with our unique set of filtered URLs, we can begin downloading and mapping.
    checked_tasks = []
    if args.no_validate:
        checked_tasks = generated_tasks
    else:
        say(colorize(grey, "Validating %s artifact URLs..." % len(generated_tasks)))
        for (task, (download, sha)) in generated_tasks:
            failed = False
            if not check_url_liveness(download):
                if args.keep_going:
                    say(colorize(yellow, "✗ URL not valid ") + ("%s " % task) + colorize(grey, download))
                    failed = True
                else:
                    logger.error("Artifact URL liveness check failed: '%s'" % download)
                    sys.exit(2)

            if not check_url_liveness(sha):
                if args.keep_going:
                    say(colorize(yellow, "✗ SHA URL not valid ") + ("%s " % task) + colorize(grey, download))
                    failed = True
                else:
                    logger.error("Artifact URL liveness check failed: '%s'" % download)
                    sys.exit(2)

            elif not args.quiet:
                say(colorize(green, "✓ Valid ") + ("%s " % task) + colorize(grey, download.split("/")[-1]))

            if not failed:
                checked_tasks.append((task, (download, sha)))

    if len(checked_tasks) == len(generated_tasks):
        check_status = colorize(green, "All targets are valid.")
    else:
        check_status = colorize(yellow, "Some targets failed liveness checks (%s/%s)." % (
            len(generated_tasks) - len(checked_tasks),
            len(generated_tasks)
        ))

    if args.dry:
        say(
            check_status +
            colorize(grey, " Exiting early for dry run; would download ") +
            colorize(cyan, "%s artifacts" % len(checked_tasks)) +
            ".\n"
        )
        return

    say(
        check_status +
        colorize(grey, " Downloading ") +
        colorize(cyan, "%s fingerprints" % len(checked_tasks)) +
        "...\n"
    )
    time.sleep(4)

    # for each mapping, fetch the SHA256
    failed_tasks = []
    registered_hashes = {}
    for (task, (download, sha)) in checked_tasks:
        # check: should only be downloading sha256 files
        if not sha.endswith(".sha256"):
            raise NotImplementedError("Downloader should not be downloading full artifacts. Please report this.")

        (result, err) = download_text(sha)
        if result is None:
            if args.keep_going:
                failed_tasks.append((task, (download, sha)))
                say(colorize(bold_red, "✗ Download failed ") + ("%s " % task) + colorize(grey, err))
                continue
            else:
                logger.error("Artifact URL download failed for target %s: '%s'" % (task, download))
                sys.exit(2)
        else:
            registered_hashes[task] = (download, sha, result)
            say(colorize(green, "✓ SHA256 ") + colorize(grey, result) + (" %s" % task))

    if len(failed_tasks) > 0:
        say(colorize(yellow, "Some targets failed to download (%s/%s).\n" % (
            len(failed_tasks) - len(checked_tasks),
            len(checked_tasks)
        )))
    else:
        say(
            colorize("All target fingerprints obtained. ") +
            colorize(grey, "Building ") +
            colorize(cyan, "%s artifact" % len(checked_tasks)) +
            colorize(grey, " mappings...\n")
        )

    rendered_mappings = {}
    for (task, (download, sha, result)) in registered_hashes.items():
        coordinate = task.coordinate()
        tags = task.constraints()

        # join tags into an array of strings, each on new lines, with padding
        if len(tags) == 0:
            raise NotImplementedError("Targets require constraints")
        rendered_tags = "\n".join(map(
            lambda x: "        \"%s\"," % x,
            tags,
        ))

        rendered_mappings[coordinate] = (mapping_template % (
            coordinate,
            task.description(),
            download,
            result,
            rendered_tags,
        ))

    sorted_mappings = []
    for key in sorted(rendered_mappings.keys()):
        rendered = rendered_mappings[key]
        sorted_mappings.append(rendered)

    # render the final file
    rendered_mappings_file = mapping_file_template % (
        timestamp.isoformat(),  # timestamp
        os.environ.get("USER", "Sandboxed user"),  # user
        "\n".join(sorted_mappings),  # mappings
    )
    write_rendered_mappings(
        args,
        timestamp,
        rendered_mappings_file,
    )

    say(colorize(green, "All done. Enjoy. 🎉🥳"))
    print("", flush=True)  # terminate stream cleanly


def invoke():
    """Run the mappings generator."""

    try:
        generate(args=parser.parse_args())
    except KeyboardInterrupt:
        say(colorize(yellow, "Exiting on keyboard interrupt."))


if __name__ == "__main__":
    invoke()
