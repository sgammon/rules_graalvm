"Repository rule definitions, intended for use by rule users."

load(
    "//internal:graalvm_bindist.bzl",
    _graalvm_repository = "graalvm_repository",
)

## Exports
def graalvm_repository(
    version,
    java_version,
    name = "graalvm",
    distribution = None,
    toolchain = True,
    toolchain_prefix = "graalvm",
    target_compatible_with = [],
    components = [],
    setup_actions = [],
    register_all = False,
    **kwargs):
    """Declare a GraalVM distribution repository, and optionally a Java toolchain to match.

    To register and use the GraalVM distribution as a toolchain, follow the Toolchains guide in the docs
    (`docs/toolchain.md`).

    If `distribution` is set to `oracle`, an Oracle GraalVM installation is downloaded. This variant of
    GraalVM may be subject to different license obligations; please consult Oracle's docs for more info.

    Oracle GraalVM distributions are downloaded directly from Oracle, which provides a `latest` download
    endpoint. Set `version` to `latest` (the default value) to download the latest available version of
    GraalVM matching the provided `java_version`.

    When installing the `latest` version of GraalVM, it is probably ideal to provide your own `sha256`.
    In this case, the `rules_graalvm` package does not provide an SHA256 hash otherwise.

    Args:
        name: Name of the VM repository. Defaults to `graalvm`.
        java_version: Java version to use/declare.
        version: Version of the GraalVM release.
        distribution: Which GVM distribution to download - `ce`, `community`, or `oracle`.
        toolchain: Whether to create a Java toolchain from this GVM installation.
        toolchain_prefix: Name prefix to use for the toolchain; defaults to `graalvm`.
        target_compatible_with: Compatibility tags to apply.
        components: Components to install in the target GVM installation.
        setup_actions: GraalVM Updater commands that should be run; pass complete command strings that start with "gu".
        register_all: Register all GraalVM repositories and use `target_compatible_with` (experimental).
        **kwargs: Passed to the underlying bindist repository rule.
    """

    _graalvm_repository(
        name = name,
        version = version,
        java_version = java_version,
        distribution = distribution,
        toolchain = toolchain,
        toolchain_prefix = toolchain_prefix,
        target_compatible_with = target_compatible_with,
        components = components,
        setup_actions = setup_actions,
        register_all = register_all,
        **kwargs
    )
