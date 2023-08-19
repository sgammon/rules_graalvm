<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Target rule definitions, intended for use by rule users.

<a id="native_image"></a>

## native_image

<pre>
native_image(<a href="#native_image-name">name</a>, <a href="#native_image-c_compiler_option">c_compiler_option</a>, <a href="#native_image-check_toolchains">check_toolchains</a>, <a href="#native_image-data">data</a>, <a href="#native_image-deps">deps</a>, <a href="#native_image-extra_args">extra_args</a>, <a href="#native_image-include_resources">include_resources</a>,
             <a href="#native_image-initialize_at_build_time">initialize_at_build_time</a>, <a href="#native_image-initialize_at_run_time">initialize_at_run_time</a>, <a href="#native_image-jni_configuration">jni_configuration</a>, <a href="#native_image-main_class">main_class</a>,
             <a href="#native_image-native_features">native_features</a>, <a href="#native_image-native_image_tool">native_image_tool</a>, <a href="#native_image-reflection_configuration">reflection_configuration</a>)
</pre>

**ATTRIBUTES**

| Name                                                                       | Description                    | Type                                                                | Mandatory | Default            |
| :------------------------------------------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :----------------- |
| <a id="native_image-name"></a>name                                         | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                    |
| <a id="native_image-c_compiler_option"></a>c_compiler_option               | -                              | List of strings                                                     | optional  | <code>[]</code>    |
| <a id="native_image-check_toolchains"></a>check_toolchains                 | -                              | Boolean                                                             | optional  | <code>False</code> |
| <a id="native_image-data"></a>data                                         | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>    |
| <a id="native_image-deps"></a>deps                                         | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>    |
| <a id="native_image-extra_args"></a>extra_args                             | -                              | List of strings                                                     | optional  | <code>[]</code>    |
| <a id="native_image-include_resources"></a>include_resources               | -                              | String                                                              | optional  | <code>""</code>    |
| <a id="native_image-initialize_at_build_time"></a>initialize_at_build_time | -                              | List of strings                                                     | optional  | <code>[]</code>    |
| <a id="native_image-initialize_at_run_time"></a>initialize_at_run_time     | -                              | List of strings                                                     | optional  | <code>[]</code>    |
| <a id="native_image-jni_configuration"></a>jni_configuration               | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code>  |
| <a id="native_image-main_class"></a>main_class                             | -                              | String                                                              | optional  | <code>""</code>    |
| <a id="native_image-native_features"></a>native_features                   | -                              | List of strings                                                     | optional  | <code>[]</code>    |
| <a id="native_image-native_image_tool"></a>native_image_tool               | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code>  |
| <a id="native_image-reflection_configuration"></a>reflection_configuration | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code>  |
