"Helpers for working with Native Image-style arguments."

# GraalVM major version that introduced support for the "gated" form of
# `-H:-UnlockExperimentalVMOptions` (the explicit close). On 21 and older, the close flag is
# unrecognized and the driver fails; from 22 onward it is accepted and re-locks experimental
# access for subsequent args.
_EXPERIMENTAL_CLOSE_MIN_MAJOR = 22

def parse_gvm_major_version(version_string):
    """Return the leading integer from a GraalVM version string, or `None` if unknown.

    Accepted inputs and outputs:
      - `"25.0.2"`            → 25
      - `"25.0.2-custom"`     → 25
      - `"25.1.0-dev+10.1"`   → 25
      - `"23.0.1"`            → 23
      - `""` / `"latest"`     → None (version is not concretely known)

    Args:
      version_string: Version string to parse.

    Returns:
      The leading integer, or `None`.
    """
    if not version_string or version_string == "latest":
        return None
    head = version_string.split(".", 1)[0]
    digits = ""
    for i in range(len(head)):
        c = head[i]
        if c >= "0" and c <= "9":
            digits += c
        else:
            break
    if not digits:
        return None
    return int(digits)

def gvm_supports_experimental_close(version_string):
    """Return True if this GraalVM version accepts `-H:-UnlockExperimentalVMOptions`.

    Falls to False for unknown versions so that we never emit a flag an older driver would
    reject. Older drivers only accept the one-shot open form.

    Args:
      version_string: Version string to check.

    Returns:
      True if close is supported, else False.
    """
    major = parse_gvm_major_version(version_string)
    if major == None:
        return False
    return major >= _EXPERIMENTAL_CLOSE_MIN_MAJOR

def _toolchain_version(gvm_toolchain):
    """Extract the version string from a toolchain, handling None and missing field."""
    if gvm_toolchain == None:
        return ""
    return getattr(gvm_toolchain, "version", "") or ""

def experimental_args(args, added_args, gvm_toolchain = None):
    """Gate a suite of experimental arguments with `-H:+/-UnlockExperimentalVMOptions`.

    The leading `-H:+UnlockExperimentalVMOptions` is always emitted so the experimental args
    are accepted by the driver. The trailing `-H:-UnlockExperimentalVMOptions` (the "close" /
    re-lock form) is emitted only when the GraalVM version is known to support it (22+). On
    older drivers the close is not recognized and aborts the build, so we omit it and leave
    experimental mode "open" for the remainder of the command line — which is functionally
    equivalent and warning-free on those versions.

    Args:
        args: An Args object to which the arguments should be added.
        added_args: A list of arguments to add, which will be gated by the experimental flag.
        gvm_toolchain: Optional resolved GraalVM toolchain struct; its `version` field decides
            whether the close flag is emitted. Pass `None` when the toolchain isn't in scope
            (e.g. legacy / classic rules); the close flag is then skipped, which is safe on
            all driver versions.
    """
    hosted_setting(args, "UnlockExperimentalVMOptions", True)
    for arg in added_args:
        args.add(arg)
    if gvm_supports_experimental_close(_toolchain_version(gvm_toolchain)):
        hosted_setting(args, "UnlockExperimentalVMOptions", False)

def hosted_setting(args, setting, activate):
    """Emit a hosted VM setting.

    Args:
        args: An Args object to which the arguments should be added.
        setting: Name of the setting.
        activate: Whether to activate the setting.
    """
    state = "+" if activate else "-"
    args.add("-H:{}{}".format(state, setting))

def runtime_setting(args, setting, activate):
    """Emit a runtime VM setting.

    Args:
        args: An Args object to which the arguments should be added.
        setting: Name of the setting.
        activate: Whether to activate the setting.
    """
    state = "+" if activate else "-"
    args.add("-R:{}{}".format(state, setting))
