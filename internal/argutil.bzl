"Helpers for working with Native Image-style arguments."

def experimental_args(args, added_args):
    """Gate a suite of experimental arguments.

    Args:
        args: An Args object to which the arguments should be added.
        added_args: A list of arguments to add, which will be gated by the
            experimental flag.
    """
    hosted_setting(args, "UnlockExperimentalVMOptions", True)
    for arg in added_args:
        args.add(arg)
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
