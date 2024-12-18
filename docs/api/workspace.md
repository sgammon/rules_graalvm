<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Bazel Workspace (non-Bzlmod) definitions.

<a id="register_graalvm_toolchains"></a>

## register_graalvm_toolchains

<pre>
load("@rules_graalvm//graalvm:workspace.bzl", "register_graalvm_toolchains")

register_graalvm_toolchains(<a href="#register_graalvm_toolchains-name">name</a>, <a href="#register_graalvm_toolchains-register_java_toolchain">register_java_toolchain</a>, <a href="#register_graalvm_toolchains-register_gvm_toolchain">register_gvm_toolchain</a>)
</pre>

Register Bazel toolchains via the installed GraalVM repository.

The default repository `name` is `@graalvm`, but this should be set to whatever the target repository
is named (in the call to `graalvm_repository` or `graal_bindist_repository`).

The GraalVM toolchain registers a custom Bazel toolchain which allows resolution of tools like
`native-image`. If you opt out of installing the GraalVM toolchain, make sure you properly declare the
target tool in your `native_image` binary targets.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="register_graalvm_toolchains-name"></a>name |  Name of the target repository; defaults to `@graalvm`.   |  `"@graalvm"` |
| <a id="register_graalvm_toolchains-register_java_toolchain"></a>register_java_toolchain |  Whether to register GraalVM as a Java toolchain. Defaults to `True`.   |  `True` |
| <a id="register_graalvm_toolchains-register_gvm_toolchain"></a>register_gvm_toolchain |  Whether to register a GraalVM-typed toolchain. Defaults to `True`.   |  `True` |


<a id="rules_graalvm_repositories"></a>

## rules_graalvm_repositories

<pre>
load("@rules_graalvm//graalvm:workspace.bzl", "rules_graalvm_repositories")

rules_graalvm_repositories(<a href="#rules_graalvm_repositories-omit_rules_java">omit_rules_java</a>, <a href="#rules_graalvm_repositories-omit_bazel_skylib">omit_bazel_skylib</a>, <a href="#rules_graalvm_repositories-omit_apple_support">omit_apple_support</a>)
</pre>

Register dependency repositories for the GraalVM Rules for Bazel.

This function only needs to be called if consuming the GraalVM Rules from a non-Bzlmod environment.
The only dependencies the rules have are: (1) `rules_java`, (2) `bazel_skylib`, and
(3) `apple_support`. Any of those can be omitted with the provided arguments.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="rules_graalvm_repositories-omit_rules_java"></a>omit_rules_java |  Omit the `rules_java` dependency.   |  `False` |
| <a id="rules_graalvm_repositories-omit_bazel_skylib"></a>omit_bazel_skylib |  Omit the `bazel_skylib` dependency.   |  `False` |
| <a id="rules_graalvm_repositories-omit_apple_support"></a>omit_apple_support |  Omit the `apple_support` dependency.   |  `False` |


