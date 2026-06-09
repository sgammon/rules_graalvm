<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Repository rule definitions, intended for use by rule users.

<a id="graalvm_repository"></a>

## graalvm_repository

<pre>
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

graalvm_repository(<a href="#graalvm_repository-version">version</a>, <a href="#graalvm_repository-java_version">java_version</a>, <a href="#graalvm_repository-name">name</a>, <a href="#graalvm_repository-distribution">distribution</a>, <a href="#graalvm_repository-toolchain">toolchain</a>, <a href="#graalvm_repository-toolchain_prefix">toolchain_prefix</a>,
                   <a href="#graalvm_repository-target_compatible_with">target_compatible_with</a>, <a href="#graalvm_repository-components">components</a>, <a href="#graalvm_repository-setup_actions">setup_actions</a>, <a href="#graalvm_repository-platforms">platforms</a>, <a href="#graalvm_repository-register_all">register_all</a>, <a href="#graalvm_repository-url">url</a>,
                   <a href="#graalvm_repository-urls">urls</a>, <a href="#graalvm_repository-strip_prefix">strip_prefix</a>, <a href="#graalvm_repository-sha256">sha256</a>, <a href="#graalvm_repository-url_per_platform">url_per_platform</a>, <a href="#graalvm_repository-sha256_per_platform">sha256_per_platform</a>,
                   <a href="#graalvm_repository-strip_prefix_per_platform">strip_prefix_per_platform</a>, <a href="#graalvm_repository-maven_resource_bundle">maven_resource_bundle</a>, <a href="#graalvm_repository-kwargs">**kwargs</a>)
</pre>

Declare a GraalVM distribution repository, and optionally a Java toolchain to match.

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


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="graalvm_repository-version"></a>version |  Version of the GraalVM release.   |  none |
| <a id="graalvm_repository-java_version"></a>java_version |  Java version to use/declare.   |  none |
| <a id="graalvm_repository-name"></a>name |  Name of the VM repository. Defaults to `graalvm`.   |  `"graalvm"` |
| <a id="graalvm_repository-distribution"></a>distribution |  Which GVM distribution to download - `ce`, `community`, or `oracle`.   |  `None` |
| <a id="graalvm_repository-toolchain"></a>toolchain |  Whether to create a Java toolchain from this GVM installation.   |  `True` |
| <a id="graalvm_repository-toolchain_prefix"></a>toolchain_prefix |  Name prefix to use for the toolchain; defaults to `graalvm`.   |  `"graalvm"` |
| <a id="graalvm_repository-target_compatible_with"></a>target_compatible_with |  Compatibility tags to apply.   |  `[]` |
| <a id="graalvm_repository-components"></a>components |  Components to install in the target GVM installation.   |  `[]` |
| <a id="graalvm_repository-setup_actions"></a>setup_actions |  GraalVM Updater commands that should be run; pass complete command strings that start with "gu".   |  `[]` |
| <a id="graalvm_repository-platforms"></a>platforms |  Which platforms to generate and register toolchains for. `None` (the WORKSPACE default) or `["host"]` generates only the host-platform toolchain; `[]` or `["all"]` generates every supported platform (`linux-x64`, `linux-aarch64`, `macos-x64`, `macos-aarch64`, `windows-x64`); an explicit list selects a subset. The Bzlmod `gvm.graalvm` tag defaults this to all platforms. Registering all platforms is lazy — only the SDK of a selected toolchain is fetched — so it is free for host-only builds and makes RBE work out of the box.   |  `None` |
| <a id="graalvm_repository-register_all"></a>register_all |  Deprecated alias for `platforms`. `True` ≡ `platforms = []` (all platforms); `False` ≡ `platforms = ["host"]`. Cannot be combined with `platforms`.   |  `None` |
| <a id="graalvm_repository-url"></a>url |  Custom download URL. When set, bypasses the bindist map. Requires `strip_prefix`; see above.   |  `None` |
| <a id="graalvm_repository-urls"></a>urls |  Mirror URLs; alternate form of `url`. If both are set, `urls` wins.   |  `None` |
| <a id="graalvm_repository-strip_prefix"></a>strip_prefix |  Archive-internal prefix to strip. Required when `url` / `urls` is set.   |  `None` |
| <a id="graalvm_repository-sha256"></a>sha256 |  SHA-256 fingerprint of the archive. Strongly recommended when `url` / `urls` is set.   |  `None` |
| <a id="graalvm_repository-url_per_platform"></a>url_per_platform |  Dict of per-host-platform URLs keyed by platform tag (`linux-x64`, `linux-aarch64`, `macos-x64`, `macos-aarch64`, `windows-x64`). Use this instead of `url` / `urls` for cross-platform declarations.   |  `None` |
| <a id="graalvm_repository-sha256_per_platform"></a>sha256_per_platform |  Dict of per-platform SHA-256 hashes, same keys as `url_per_platform`.   |  `None` |
| <a id="graalvm_repository-strip_prefix_per_platform"></a>strip_prefix_per_platform |  Dict of per-platform strip prefixes, same keys.   |  `None` |
| <a id="graalvm_repository-maven_resource_bundle"></a>maven_resource_bundle |  Optional URL of a GraalVM Maven resource bundle to associate with a custom toolchain. Only valid together with `url` / `urls` / `url_per_platform`; fails analysis if set on a map-resolved distribution. Inert today — recorded on the repo for forward compatibility with a future component-from-Maven resolution path.   |  `None` |
| <a id="graalvm_repository-kwargs"></a>kwargs |  Passed to the underlying bindist repository rule.   |  none |


