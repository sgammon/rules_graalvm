## Hermetic GraalVM rules

Full hermeticity can be a challenge with Bazel, because the `native-image` tool uses several environment variables to
resolve tooling, based on the host platform you execute your build on. This guide can help you troubleshoot these
problems; please read on based on the platform you use.

#### Note on hermetic downloads

Most downloads performed by these rules are hermetic and fingerprinted. However, in certain cases, there is no easy way to determine these fingerprints ahead of time:

- **Components which don't ship with GraalVM:** There is no rule-side support for these yet. You may be able to get these to work with regular library dependencies or `data` attributes.

- **Oracle GraalVM components:** These are installed via `gu` directly because this tool accesses Oracle's GDS (Global Download Service) APIs.

All other downloads are performed through Bazel.

### Linux

On Linux no specific action is needed.

### macOS

Bazel on macOS uses Xcode to build native code by default. You can opt to keep this behavior, or you can use the
non-Xcode "[pure C++ toolchain][1]" by setting `BAZEL_USE_CPP_ONLY_TOOLCHAIN=1`.

**Building via Xcode:**
When building via Xcode (the default behavior), you may need to open Xcode and accept terms to complete installation.
In some cases this can be performed via the command line:

```
sudo xcodebuild -license [accept]
```

> **Note**
> Pass the `accept` parameter in headless scripts.

**Pure C++ toolchain:**

- You may need to set `BAZEL_USE_CPP_ONLY_TOOLCHAIN=1` in your Bazel repository invocation environment
- You may need to set pass `BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1` in your Bazel invocation environment

For example:

```
build --repo_env BUILD_USE_CPP_ONLY_TOOLCHAIN=1
build --action_env BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1
```

### Windows

Bazel on Windows [involves some setup][3]. You will need a recent copy of [Visual Studio][4] as documented in the
[Windows usage guide][5]. You can build binaries with `native-image` even if Bazel isn't correctly set up to use Visual
Studio, but in this case the rules fallback to using the `PATH` to resolve `cl.exe`.

**Troubleshooting Windows builds:**
These settings have been observed to help when building on Windows. These flags are included both here and in the usage
guide for Windows because `native-image` _itself_ uses these environment variables to complete a build.

```
build --action_env=INCLUDE
build --action_env=MSVC
build --action_env=LIB
```

[1]: https://github.com/bazelbuild/bazel/issues/4231#issuecomment-351095148
[2]: https://github.com/bazelbuild/sandboxfs
[3]: https://bazel.build/configure/windows
[4]: https://visualstudio.microsoft.com/downloads/
[5]: ./windows.md
