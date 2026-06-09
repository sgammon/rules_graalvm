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
        platforms = None,
        register_all = None,
        url = None,
        urls = None,
        strip_prefix = None,
        sha256 = None,
        url_per_platform = None,
        sha256_per_platform = None,
        strip_prefix_per_platform = None,
        maven_resource_bundle = None,
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

    ### Custom URL (Early Adopter / nightly / dev builds)

    When `url` or `urls` is provided, the rule bypasses the bundled bindist map and downloads directly
    from the user-supplied URL(s). This is the recommended path for Early Adopter builds, nightly
    snapshots, or private dev builds whose archives are not in `graalvm_bindist_map.bzl`.

    Constraints:
    * `strip_prefix` is required.
    * `sha256` is strongly recommended; without it, downloads are non-hermetic and a warning is printed.
    * `components` is not supported with a custom URL — EA / nightly builds rarely ship a working `gu`.
    * `version` and `java_version` remain required and are used for toolchain naming (e.g. `graalvm_25`).

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
        platforms: Which platforms to generate and register toolchains for. `None` (the WORKSPACE default)
          or `["host"]` generates only the host-platform toolchain; `[]` or `["all"]` generates every
          supported platform (`linux-x64`, `linux-aarch64`, `macos-x64`, `macos-aarch64`, `windows-x64`);
          an explicit list selects a subset. The Bzlmod `gvm.graalvm` tag defaults this to all platforms.
          Registering all platforms is lazy — only the SDK of a selected toolchain is fetched — so it is
          free for host-only builds and makes RBE work out of the box.
        register_all: Deprecated alias for `platforms`. `True` ≡ `platforms = []` (all platforms);
          `False` ≡ `platforms = ["host"]`. Cannot be combined with `platforms`.
        url: Custom download URL. When set, bypasses the bindist map. Requires `strip_prefix`; see above.
        urls: Mirror URLs; alternate form of `url`. If both are set, `urls` wins.
        strip_prefix: Archive-internal prefix to strip. Required when `url` / `urls` is set.
        sha256: SHA-256 fingerprint of the archive. Strongly recommended when `url` / `urls` is set.
        url_per_platform: Dict of per-host-platform URLs keyed by platform tag
          (`linux-x64`, `linux-aarch64`, `macos-x64`, `macos-aarch64`, `windows-x64`). Use this
          instead of `url` / `urls` for cross-platform declarations.
        sha256_per_platform: Dict of per-platform SHA-256 hashes, same keys as `url_per_platform`.
        strip_prefix_per_platform: Dict of per-platform strip prefixes, same keys.
        maven_resource_bundle: Optional URL of a GraalVM Maven resource bundle to associate with
          a custom toolchain. Only valid together with `url` / `urls` / `url_per_platform`;
          fails analysis if set on a map-resolved distribution. Inert today — recorded on the
          repo for forward compatibility with a future component-from-Maven resolution path.
        **kwargs: Passed to the underlying bindist repository rule.
    """

    forwarded = dict(kwargs)
    if url != None:
        forwarded["url"] = url
    if urls != None:
        forwarded["urls"] = urls
    if strip_prefix != None:
        forwarded["strip_prefix"] = strip_prefix
    if sha256 != None:
        forwarded["sha256"] = sha256
    if url_per_platform != None:
        forwarded["url_per_platform"] = url_per_platform
    if sha256_per_platform != None:
        forwarded["sha256_per_platform"] = sha256_per_platform
    if strip_prefix_per_platform != None:
        forwarded["strip_prefix_per_platform"] = strip_prefix_per_platform
    if maven_resource_bundle != None:
        forwarded["maven_resource_bundle"] = maven_resource_bundle

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
        platforms = platforms,
        register_all = register_all,
        **forwarded
    )
