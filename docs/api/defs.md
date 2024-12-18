<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Target rule definitions, intended for use by rule users.

<a id="native_image"></a>

## native_image

<pre>
load("@rules_graalvm//graalvm:defs.bzl", "native_image")

native_image(<a href="#native_image-name">name</a>, <a href="#native_image-deps">deps</a>, <a href="#native_image-main_class">main_class</a>, <a href="#native_image-executable_name">executable_name</a>, <a href="#native_image-include_resources">include_resources</a>, <a href="#native_image-reflection_configuration">reflection_configuration</a>,
             <a href="#native_image-jni_configuration">jni_configuration</a>, <a href="#native_image-initialize_at_build_time">initialize_at_build_time</a>, <a href="#native_image-initialize_at_run_time">initialize_at_run_time</a>, <a href="#native_image-native_features">native_features</a>,
             <a href="#native_image-debug">debug</a>, <a href="#native_image-optimization_mode">optimization_mode</a>, <a href="#native_image-shared_library">shared_library</a>, <a href="#native_image-static_zlib">static_zlib</a>, <a href="#native_image-c_compiler_option">c_compiler_option</a>, <a href="#native_image-data">data</a>,
             <a href="#native_image-extra_args">extra_args</a>, <a href="#native_image-allow_fallback">allow_fallback</a>, <a href="#native_image-check_toolchains">check_toolchains</a>, <a href="#native_image-native_image_tool">native_image_tool</a>, <a href="#native_image-native_image_settings">native_image_settings</a>,
             <a href="#native_image-resource_configuration">resource_configuration</a>, <a href="#native_image-proxy_configuration">proxy_configuration</a>, <a href="#native_image-profiles">profiles</a>, <a href="#native_image-kwargs">**kwargs</a>)
</pre>

Generates and compiles a GraalVM native image from a Java library target.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="native_image-name"></a>name |  Name of the target; required.   |  none |
| <a id="native_image-deps"></a>deps |  Dependency `java_library` targets to assemble the classpath from. Mandatory.   |  none |
| <a id="native_image-main_class"></a>main_class |  Entrypoint main class to build from; mandatory unless building a shared library.   |  `None` |
| <a id="native_image-executable_name"></a>executable_name |  Set the name of the output binary; defaults to `%target%-bin`, or `%target%-bin.exe` on Windows. The special string `%target%`, if present, is replaced with `name`.   |  `select({"@bazel_tools//src/conditions:windows": "%target%-bin.exe", "//conditions:default": "%target%-bin"})` |
| <a id="native_image-include_resources"></a>include_resources |  Glob to pass to `IncludeResources`. No default; optional.   |  `None` |
| <a id="native_image-reflection_configuration"></a>reflection_configuration |  Reflection configuration file. No default; optional.   |  `None` |
| <a id="native_image-jni_configuration"></a>jni_configuration |  JNI configuration file. No default; optional.   |  `None` |
| <a id="native_image-initialize_at_build_time"></a>initialize_at_build_time |  Classes or patterns to pass to `--initialize-at-build-time`. No default; optional.   |  `[]` |
| <a id="native_image-initialize_at_run_time"></a>initialize_at_run_time |  Classes or patterns to pass to `--initialize-at-run-time`. No default; optional.   |  `[]` |
| <a id="native_image-native_features"></a>native_features |  GraalVM `Feature` classes to include and apply. No default; optional.   |  `[]` |
| <a id="native_image-debug"></a>debug |  Whether to include debug symbols; by default, this flag's state is managed by Bazel. Passing `--compilation_mode=dbg` is sufficient to flip this to `True`, or it can be overridden via this parameter.   |  `select({"@rules_graalvm//internal/conditions/compiler:debug": True, "//conditions:default": False})` |
| <a id="native_image-optimization_mode"></a>optimization_mode |  Behaves the same as `debug`; normally, this flag's state is managed by Bazel. Passing `--compilation_mode=fastbuild\|opt\|dbg` is sufficient to set this flag, or it can be overridden via this parameter.   |  `select({"@rules_graalvm//internal/conditions/compiler:fastbuild": "b", "@rules_graalvm//internal/conditions/compiler:optimized": "2", "//conditions:default": ""})` |
| <a id="native_image-shared_library"></a>shared_library |  Build a shared library binary instead of an executable.   |  `None` |
| <a id="native_image-static_zlib"></a>static_zlib |  A cc_library or cc_import target that provides zlib as a static library. On Linux, this is used when Graal statically links zlib into the binary, e.g. with `-H:+StaticExecutableWithDynamicLibC`.   |  `None` |
| <a id="native_image-c_compiler_option"></a>c_compiler_option |  Extra C compiler options to pass through `native-image`. No default; optional.   |  `[]` |
| <a id="native_image-data"></a>data |  Data files to make available during the compilation. No default; optional.   |  `[]` |
| <a id="native_image-extra_args"></a>extra_args |  Extra `native-image` args to pass. Last wins. No default; optional.   |  `[]` |
| <a id="native_image-allow_fallback"></a>allow_fallback |  Whether to allow fall-back to a partial native image; defaults to `False`.   |  `False` |
| <a id="native_image-check_toolchains"></a>check_toolchains |  Whether to perform toolchain checks in `native-image`; defaults to `True` on Windows, `False` otherwise.   |  `select({"@bazel_tools//src/conditions:windows": True, "//conditions:default": False})` |
| <a id="native_image-native_image_tool"></a>native_image_tool |  Specific `native-image` executable target to use.   |  `None` |
| <a id="native_image-native_image_settings"></a>native_image_settings |  Suite(s) of Native Image build settings to use.   |  `[Label("@rules_graalvm//internal/native_image:defaults")]` |
| <a id="native_image-resource_configuration"></a>resource_configuration |  Resource configuration file. No default; optional.   |  `None` |
| <a id="native_image-proxy_configuration"></a>proxy_configuration |  Proxy configuration file. No default; optional.   |  `None` |
| <a id="native_image-profiles"></a>profiles |  Profiles to use for profile-guided optimization (PGO) and obtained from a native image compiled with `--pgo-instrument`.   |  `[]` |
| <a id="native_image-kwargs"></a>kwargs |  Extra keyword arguments are passed to the underlying `native_image` rule.   |  none |


