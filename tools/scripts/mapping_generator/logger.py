"""
Defines a logger for the mapping generator tool, with support for ANSI color.
"""

import os
import sys
import logging

RESET_SEQ = "\033[0m"
COLOR_SEQ = "\033[1;%dm"
BOLD_SEQ = "\033[1m"
grey = "\x1b[37;20m"
yellow = "\x1b[33;20m"
green = "\x1b[32;20m"
blue = "\x1b[34;20m"
cyan = "\x1b[36;20m"
red = "\x1b[31;20m"
bold_red = "\x1b[31;1m"
bold_white = "\x1b[38;1m"
reset_color = "\x1b[0m"
colorized_output = True


def colorize(color, *values):
    if not colorized_output:
        return " ".join(values)
    return RESET_SEQ + color + " ".join(values) + reset_color


def formatter_message(message, use_color=True):
    if use_color and colorized_output:
        message = message.replace("$RESET", RESET_SEQ).replace("$BOLD", BOLD_SEQ)
    else:
        message = message.replace("$RESET", "").replace("$BOLD", "")
    return message


BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)

COLORS = {
    'WARNING': YELLOW,
    'INFO': CYAN,
    'DEBUG': MAGENTA,
    'CRITICAL': RED,
    'ERROR': RED
}


class ColorizedFormatter(logging.Formatter):
    def __init__(self, msg, use_color=colorized_output):
        logging.Formatter.__init__(self, msg)
        self.use_color = use_color

    def format(self, record):
        levelname = record.levelname
        if self.use_color and levelname in COLORS:
            levelname_color = COLOR_SEQ % (30 + COLORS[levelname]) + levelname + RESET_SEQ
            record.levelname = levelname_color
        return logging.Formatter.format(self, record)


class ColorizedLogger(logging.Logger):
    FORMAT = "[%(levelname)s] %(message)s"
    COLOR_FORMAT = formatter_message(FORMAT, True)

    def __init__(self, name):
        logging.Logger.__init__(self, name, logging.DEBUG)
        color_formatter = ColorizedFormatter(self.COLOR_FORMAT)
        handler.setFormatter(color_formatter)
        self.addHandler(handler)
        return


def say(*args):
    """Print to stdout."""
    print(*args, end="\n", file=sys.stderr)


def highlight(value):
    """Highlight a value bold-white in the terminal."""
    return colorize(bold_white, value)


def print_report(args, javas, platforms, distributions, versions, components, skipped_targets, all_targets):
    """Print a simple report before we proceed with action.
    
    In dry run mode, execution stops after this report is printed."""

    from .config import MAPPING_RULES
    formatted_targets = "\n".join(map(lambda x: "- %s" % str(x), all_targets))
    formatted_skipped_targets = "None.\n"
    if len(skipped_targets) > 0:
        formatted_skipped_targets = ""
        for target in skipped_targets.keys():
            skipped_target_fmt = "- %s\n" % target
            found_version_misalignment = False
            for reason in skipped_targets[target]:
                if reason == "Version misalignment":
                    found_version_misalignment = True
                skipped_target_fmt += "--- Reason: %s\n" % (reason or "Not given")

            if args.debug or (not found_version_misalignment):
                formatted_skipped_targets += skipped_target_fmt

    mapping_rules = "\n".join(map(lambda x: "- %s" % str(x), MAPPING_RULES))

    if not args.quiet:
        say(colorize(grey, "Generating mappings for:") + """
- Platforms: {platforms}
- JDKs: {javas}
- Components: {components}
- Distributions: {distributions}
- Versions: {versions}
    """.format(
            platforms=", ".join(map(highlight, platforms)),
            javas=", ".join(map(highlight, map(lambda x: "java%s" % x, javas))),
            distributions=", ".join(map(highlight, distributions)),
            versions=", ".join(map(highlight, versions)),
            components=", ".join(map(highlight, components)),
        ))
        logger.debug("""
Mapping rules:
{mapping_rules}

Skipped targets:
{skipped_targets}
Eligible targets:
{targets}
""".format(
            mapping_rules=mapping_rules,
            skipped_targets=formatted_skipped_targets,
            targets=formatted_targets,
        ))


loggingConfig = {
    "encoding": "utf-8",
}

# Global logger to use
logger = logging.getLogger("generator")
handler = logging.StreamHandler()


def handle_flags(args):
    """Handle flags before executing."""

    global logger
    global colorized_output

    if not args.no_color and (os.environ.get("NOCOLOR", None) is None):
        colorized_output = True
    else:
        colorized_output = False

    # prepare logging/output
    if args.verbose and not args.quiet:
        loggingConfig.update({
            "level": logging.DEBUG
        })
        logger.setLevel(logging.DEBUG)
    elif not args.quiet:
        loggingConfig.update({
            "level": logging.INFO,
        })
        logger.setLevel(logging.INFO)

    # initialize logging configuration
    logging.basicConfig(**loggingConfig)
    return False  # don't exit
