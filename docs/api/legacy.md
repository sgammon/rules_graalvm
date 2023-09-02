<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules for building native binaries using the GraalVM `native-image` tool on Bazel 5 and older.

<a id="graal_binary"></a>

## graal_binary

<pre>
graal_binary(<a href="#graal_binary-name">name</a>, <a href="#graal_binary-deps">deps</a>, <a href="#graal_binary-main_class">main_class</a>, <a href="#graal_binary-include_resources">include_resources</a>, <a href="#graal_binary-reflection_configuration">reflection_configuration</a>, <a href="#graal_binary-jni_configuration">jni_configuration</a>,
             <a href="#graal_binary-initialize_at_build_time">initialize_at_build_time</a>, <a href="#graal_binary-initialize_at_run_time">initialize_at_run_time</a>, <a href="#graal_binary-native_features">native_features</a>, <a href="#graal_binary-data">data</a>, <a href="#graal_binary-extra_args">extra_args</a>,
             <a href="#graal_binary-check_toolchains">check_toolchains</a>, <a href="#graal_binary-c_compiler_option">c_compiler_option</a>, <a href="#graal_binary-static_zlib">static_zlib</a>, <a href="#graal_binary-executable_name">executable_name</a>, <a href="#graal_binary-native_image_tool">native_image_tool</a>,
             <a href="#graal_binary-kwargs">kwargs</a>)
</pre>

Alias for the renamed `native_image` rule. Identical.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="graal_binary-name"></a>name |  Name of the target; required.   |  none |
| <a id="graal_binary-deps"></a>deps |  Dependency `java_library` targets to assemble the classpath from. Mandatory.   |  none |
| <a id="graal_binary-main_class"></a>main_class |  Entrypoint main class to build from; mandatory.   |  none |
| <a id="graal_binary-include_resources"></a>include_resources |  Glob to pass to `IncludeResources`. No default; optional.   |  `None` |
| <a id="graal_binary-reflection_configuration"></a>reflection_configuration |  Reflection configuration file. No default; optional.   |  `None` |
| <a id="graal_binary-jni_configuration"></a>jni_configuration |  JNI configuration file. No default; optional.   |  `None` |
| <a id="graal_binary-initialize_at_build_time"></a>initialize_at_build_time |  Classes or patterns to pass to `--initialize-at-build-time`. No default; optional.   |  `[]` |
| <a id="graal_binary-initialize_at_run_time"></a>initialize_at_run_time |  Classes or patterns to pass to `--initialize-at-run-time`. No default; optional.   |  `[]` |
| <a id="graal_binary-native_features"></a>native_features |  GraalVM `Feature` classes to include and apply. No default; optional.   |  `[]` |
| <a id="graal_binary-data"></a>data |  Data files to make available during the compilation. No default; optional.   |  `[]` |
| <a id="graal_binary-extra_args"></a>extra_args |  Extra `native-image` args to pass. Last wins. No default; optional.   |  `[]` |
| <a id="graal_binary-check_toolchains"></a>check_toolchains |  Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.   |  `select({"@bazel_tools//src/conditions:windows": True, "//conditions:default": False})` |
| <a id="graal_binary-c_compiler_option"></a>c_compiler_option |  Extra C compiler options to pass through `native-image`. No default; optional.   |  `[]` |
| <a id="graal_binary-static_zlib"></a>static_zlib |  A cc_library or cc_import target that provides zlib as a static library. On Linux, this is used when Graal statically links zlib into the binary, e.g. with `-H:+StaticExecutableWithDynamicLibC`.   |  `None` |
| <a id="graal_binary-executable_name"></a>executable_name |  Set the name of the output binary; defaults to `%target%-bin`, or `%target%-bin.exe` on Windows. The special string `%target%`, if present, is replaced with `name`.   |  `select({"@bazel_tools//src/conditions:windows": "%target%-bin.exe", "//conditions:default": "%target%-bin"})` |
| <a id="graal_binary-native_image_tool"></a>native_image_tool |  Specific `native-image` executable target to use.   |  `Label("@graalvm//:native-image")` |
| <a id="graal_binary-kwargs"></a>kwargs |  Extra keyword arguments are passed to the underlying `native_image` rule.   |  none |


<a id="native_image"></a>

## native_image

<pre>
native_image(<a href="#native_image-name">name</a>, <a href="#native_image-deps">deps</a>, <a href="#native_image-main_class">main_class</a>, <a href="#native_image-include_resources">include_resources</a>, <a href="#native_image-reflection_configuration">reflection_configuration</a>, <a href="#native_image-jni_configuration">jni_configuration</a>,
             <a href="#native_image-initialize_at_build_time">initialize_at_build_time</a>, <a href="#native_image-initialize_at_run_time">initialize_at_run_time</a>, <a href="#native_image-native_features">native_features</a>, <a href="#native_image-data">data</a>, <a href="#native_image-extra_args">extra_args</a>,
             <a href="#native_image-check_toolchains">check_toolchains</a>, <a href="#native_image-c_compiler_option">c_compiler_option</a>, <a href="#native_image-static_zlib">static_zlib</a>, <a href="#native_image-executable_name">executable_name</a>, <a href="#native_image-native_image_tool">native_image_tool</a>,
             <a href="#native_image-kwargs">kwargs</a>)
</pre>

Generates and compiles a GraalVM native image from a Java library target.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="native_image-name"></a>name |  Name of the target; required.   |  none |
| <a id="native_image-deps"></a>deps |  Dependency `java_library` targets to assemble the classpath from. Mandatory.   |  none |
| <a id="native_image-main_class"></a>main_class |  Entrypoint main class to build from; mandatory.   |  none |
| <a id="native_image-include_resources"></a>include_resources |  Glob to pass to `IncludeResources`. No default; optional.   |  `None` |
| <a id="native_image-reflection_configuration"></a>reflection_configuration |  Reflection configuration file. No default; optional.   |  `None` |
| <a id="native_image-jni_configuration"></a>jni_configuration |  JNI configuration file. No default; optional.   |  `None` |
| <a id="native_image-initialize_at_build_time"></a>initialize_at_build_time |  Classes or patterns to pass to `--initialize-at-build-time`. No default; optional.   |  `[]` |
| <a id="native_image-initialize_at_run_time"></a>initialize_at_run_time |  Classes or patterns to pass to `--initialize-at-run-time`. No default; optional.   |  `[]` |
| <a id="native_image-native_features"></a>native_features |  GraalVM `Feature` classes to include and apply. No default; optional.   |  `[]` |
| <a id="native_image-data"></a>data |  Data files to make available during the compilation. No default; optional.   |  `[]` |
| <a id="native_image-extra_args"></a>extra_args |  Extra `native-image` args to pass. Last wins. No default; optional.   |  `[]` |
| <a id="native_image-check_toolchains"></a>check_toolchains |  Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.   |  `select({"@bazel_tools//src/conditions:windows": True, "//conditions:default": False})` |
| <a id="native_image-c_compiler_option"></a>c_compiler_option |  Extra C compiler options to pass through `native-image`. No default; optional.   |  `[]` |
| <a id="native_image-static_zlib"></a>static_zlib |  A cc_library or cc_import target that provides zlib as a static library. On Linux, this is used when Graal statically links zlib into the binary, e.g. with `-H:+StaticExecutableWithDynamicLibC`.   |  `None` |
| <a id="native_image-executable_name"></a>executable_name |  Set the name of the output binary; defaults to `%target%-bin`, or `%target%-bin.exe` on Windows. The special string `%target%`, if present, is replaced with `name`.   |  `select({"@bazel_tools//src/conditions:windows": "%target%-bin.exe", "//conditions:default": "%target%-bin"})` |
| <a id="native_image-native_image_tool"></a>native_image_tool |  Specific `native-image` executable target to use.   |  `Label("@graalvm//:native-image")` |
| <a id="native_image-kwargs"></a>kwargs |  Extra keyword arguments are passed to the underlying `native_image` rule.   |  none |


