<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Toolchain types and rules for GraalVM.

<a id="graalvm_engine_toolchain"></a>

## graalvm_engine_toolchain

<pre>
graalvm_engine_toolchain(<a href="#graalvm_engine_toolchain-name">name</a>, <a href="#graalvm_engine_toolchain-component">component</a>, <a href="#graalvm_engine_toolchain-language">language</a>, <a href="#graalvm_engine_toolchain-launcher">launcher</a>)
</pre>

**ATTRIBUTES**

| Name                                                     | Description                    | Type                                                                | Mandatory | Default         |
| :------------------------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="graalvm_engine_toolchain-name"></a>name           | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="graalvm_engine_toolchain-component"></a>component | -                              | String                                                              | required  |                 |
| <a id="graalvm_engine_toolchain-language"></a>language   | -                              | String                                                              | optional  | <code>""</code> |
| <a id="graalvm_engine_toolchain-launcher"></a>launcher   | -                              | String                                                              | optional  | <code>""</code> |

<a id="graalvm_toolchain"></a>

## graalvm_toolchain

<pre>
graalvm_toolchain(<a href="#graalvm_toolchain-name">name</a>, <a href="#graalvm_toolchain-native_image_bin_path">native_image_bin_path</a>, <a href="#graalvm_toolchain-version">version</a>)
</pre>

**ATTRIBUTES**

| Name                                                                      | Description                    | Type                                                                | Mandatory | Default         |
| :------------------------------------------------------------------------ | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="graalvm_toolchain-name"></a>name                                   | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="graalvm_toolchain-native_image_bin_path"></a>native_image_bin_path | -                              | String                                                              | optional  | <code>""</code> |
| <a id="graalvm_toolchain-version"></a>version                             | -                              | String                                                              | required  |                 |

<a id="GraalVMEngineInfo"></a>

## GraalVMEngineInfo

<pre>
GraalVMEngineInfo(<a href="#GraalVMEngineInfo-language">language</a>, <a href="#GraalVMEngineInfo-launcher">launcher</a>)
</pre>

Information about an installed GraalVM component or engine.

**FIELDS**

| Name                                            | Description    |
| :---------------------------------------------- | :------------- |
| <a id="GraalVMEngineInfo-language"></a>language | (Undocumented) |
| <a id="GraalVMEngineInfo-launcher"></a>launcher | (Undocumented) |

<a id="GraalVMToolchainInfo"></a>

## GraalVMToolchainInfo

<pre>
GraalVMToolchainInfo(<a href="#GraalVMToolchainInfo-version">version</a>, <a href="#GraalVMToolchainInfo-native_image_bin_path">native_image_bin_path</a>)
</pre>

Information about the GraalVM runtime and compiler.

**FIELDS**

| Name                                                                         | Description    |
| :--------------------------------------------------------------------------- | :------------- |
| <a id="GraalVMToolchainInfo-version"></a>version                             | (Undocumented) |
| <a id="GraalVMToolchainInfo-native_image_bin_path"></a>native_image_bin_path | (Undocumented) |
