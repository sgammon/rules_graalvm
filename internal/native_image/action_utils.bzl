"Shared action-wrapping helpers used by `native_image` and `native_image_layer` rules."

def _env_arg_map_each(key_value):
    return "-E{}={}".format(key_value[0], key_value[1])

def _wrapped_run_for_graal(_original_actions, arguments = [], env = {}, **kwargs):
    env_args = _original_actions.args()
    env_args.add_all(env.items(), map_each = _env_arg_map_each)
    return _original_actions.run(
        arguments = arguments + [env_args],
        # We keep the original variables as Bazel has special handling for adding additional
        # variables (such as DEVELOPER_DIR) based on existing ones when it executes the action
        # locally.
        env = env,
        **kwargs
    )

def wrap_actions_for_graal(actions):
    """Wraps the given `ctx.actions` struct so env vars are forwarded to Graal as -E args.

    Graal's driver sanitizes its env. We forward each entry via -E<key>=<value> so Graal and the
    inner compiler see the same variables Bazel expects (e.g. DEVELOPER_DIR on macOS).

    Args:
        actions: The `ctx.actions` struct from the calling rule's implementation.

    Returns:
        A struct that mirrors `ctx.actions` but whose `run` method funnels environment variables
        through Graal's `-E<key>=<value>` argument convention.
    """
    patched_actions = {k: getattr(actions, k) for k in dir(actions)}

    def _run_target(**kwargs):
        _wrapped_run_for_graal(actions, **kwargs)

    patched_actions["run"] = _run_target
    return struct(**patched_actions)
