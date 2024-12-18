<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Repository rule definitions, intended for use by rule users.

<a id="graalvm_repository"></a>

## graalvm_repository

<pre>
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

graalvm_repository(<a href="#graalvm_repository-version">version</a>, <a href="#graalvm_repository-java_version">java_version</a>, <a href="#graalvm_repository-name">name</a>, <a href="#graalvm_repository-distribution">distribution</a>, <a href="#graalvm_repository-toolchain">toolchain</a>, <a href="#graalvm_repository-toolchain_prefix">toolchain_prefix</a>,
                   <a href="#graalvm_repository-target_compatible_with">target_compatible_with</a>, <a href="#graalvm_repository-components">components</a>, <a href="#graalvm_repository-setup_actions">setup_actions</a>, <a href="#graalvm_repository-register_all">register_all</a>, <a href="#graalvm_repository-kwargs">**kwargs</a>)
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
| <a id="graalvm_repository-register_all"></a>register_all |  Register all GraalVM repositories and use `target_compatible_with` (experimental).   |  `False` |
| <a id="graalvm_repository-kwargs"></a>kwargs |  Passed to the underlying bindist repository rule.   |  none |


