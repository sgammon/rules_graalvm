<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Toolchain types and rules for GraalVM.

<a id="register_graalvm_toolchains"></a>

## register_graalvm_toolchains

<pre>
load("@rules_graalvm//graalvm:toolchain.bzl", "register_graalvm_toolchains")

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


