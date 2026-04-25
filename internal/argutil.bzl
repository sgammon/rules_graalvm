"Helpers for working with Native Image-style arguments."

# GraalVM major version that introduced `-H:+UnlockExperimentalVMOptions` (the open flag) at
# all. On versions older than this — observed empirically against GraalVM 19.3 in our Bazel 4
# CI matrix — the driver aborts with `Could not find option 'UnlockExperimentalVMOptions'`. We
# fall back to emitting wrapped args bare on those versions. Set conservatively: any argument
# we currently wrap in `experimental_args()` that *was* experimental in 21 will surface as a
# soft warning rather than a hard failure on older drivers.
_EXPERIMENTAL_OPEN_MIN_MAJOR = 22

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

def gvm_supports_experimental_open(version_string):
    """Return True if this GraalVM version accepts `-H:+UnlockExperimentalVMOptions`.

    Older drivers (GraalVM 19/20-era) lack this flag entirely and abort with `Could not find
    option 'UnlockExperimentalVMOptions'`. Falls to False for unknown versions so we never
    emit a flag an old driver would reject — wrapped args fall back to bare emission.

    Args:
      version_string: Version string to check.

    Returns:
      True if the open flag is supported, else False.
    """
    major = parse_gvm_major_version(version_string)
    if major == None:
        return False
    return major >= _EXPERIMENTAL_OPEN_MIN_MAJOR

def gvm_supports_experimental_close(version_string):
    """Return True if this GraalVM version accepts `-H:-UnlockExperimentalVMOptions`.

    Falls to False for unknown versions so that we never emit a flag an older driver would
    reject. Older drivers either lack the unlock entirely (see `gvm_supports_experimental_open`)
    or only accept the one-shot open form.

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

    Three behaviors based on the resolved GraalVM major version:

    * **22+** — emit the gated form: `-H:+UnlockExperimentalVMOptions`, args, and
      `-H:-UnlockExperimentalVMOptions` (re-lock). This is the cleanest output and matches
      what newer drivers expect.
    * **21 / unknown / `latest`** — emit the open before the args, but skip the close. Older
      drivers in this band accept the open but not the close. Subsequent args remain in
      "unlocked" mode for the rest of the command line (equivalent and warning-free).
    * **20 and older** — emit args bare. Drivers in this band lack the unlock flag entirely
      and would abort on it (`Could not find option 'UnlockExperimentalVMOptions'`). If a
      wrapped arg is itself genuinely experimental on such a driver, it will surface its
      own error — but the unlock flag is not the cause.

    Args:
        args: An Args object to which the arguments should be added.
        added_args: A list of arguments to add, which will be gated by the experimental flag
            when supported, or emitted bare on drivers that lack the unlock entirely.
        gvm_toolchain: Optional resolved GraalVM toolchain struct; its `version` field decides
            which behavior applies. Pass `None` when the toolchain isn't in scope (e.g. legacy
            / classic rules); the bare-emission fallback is then used, which is safe on every
            driver version.
    """
    version = _toolchain_version(gvm_toolchain)
    emit_open = gvm_supports_experimental_open(version)
    emit_close = gvm_supports_experimental_close(version)
    if emit_open:
        hosted_setting(args, "UnlockExperimentalVMOptions", True)
    for arg in added_args:
        args.add(arg)
    if emit_close:
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
