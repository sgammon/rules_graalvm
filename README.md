# GraalVM Rules for Bazel

[![CI](https://github.com/sgammon/rules_graalvm/actions/workflows/on.push.yml/badge.svg)](https://github.com/sgammon/rules_graalvm/actions/workflows/on.push.yml)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4-ff69b4.svg)](CODE_OF_CONDUCT.md)
![Bazel 7](https://img.shields.io/badge/Bazel%207-black?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyBpZD0iTGF5ZXJfMiIgZGF0YS1uYW1lPSJMYXllciAyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0My41NyA0My4zNyI%2BCiAgPGRlZnM%2BCiAgICA8c3R5bGU%2BCiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogIzAwNDMwMDsKICAgICAgfQoKICAgICAgLmNscy0yIHsKICAgICAgICBmaWxsOiAjMDA3MDFhOwogICAgICB9CgogICAgICAuY2xzLTMgewogICAgICAgIGZpbGw6ICM0M2EwNDc7CiAgICAgIH0KCiAgICAgIC5jbHMtNCB7CiAgICAgICAgZmlsbDogIzc2ZDI3NTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM%2BCiAgPGcgaWQ9IkxheWVyXzEtMiIgZGF0YS1uYW1lPSJMYXllciAxIj4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMiIgZD0ibTIxLjc4LDMyLjY4djEwLjY5bC0xMC44OS0xMC44OXYtMTAuNjlsMTAuODksMTAuODlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Im0yMS43OCwzMi42OGwxMC45LTEwLjg5djEwLjY5bC0xMC45LDEwLjg5di0xMC42OVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTEwLjg5LDIxLjc5djEwLjY5TDAsMjEuNTh2LTEwLjY5bDEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTMiIGQ9Im00My41NywxMC44OXYxMC42OWwtMTAuODksMTAuOXYtMTAuNjlsMTAuODktMTAuOVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTIxLjc4LDMyLjY4bC0xMC44OS0xMC44OSwxMC44OS0xMC45LDEwLjksMTAuOS0xMC45LDEwLjg5WiIvPgogICAgPHBhdGggY2xhc3M9ImNscy00IiBkPSJtMTAuODksMjEuNzlMMCwxMC44OSwxMC44OSwwbDEwLjg5LDEwLjg5LTEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTQiIGQ9Im0zMi42OCwyMS43OWwtMTAuOS0xMC45TDMyLjY4LDBsMTAuODksMTAuODktMTAuODksMTAuOVoiLz4KICA8L2c%2BCjwvc3ZnPg%3D%3D&logoColor=gray)
![Bzlmod](https://img.shields.io/badge/Bzlmod-black?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyBpZD0iTGF5ZXJfMiIgZGF0YS1uYW1lPSJMYXllciAyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0My41NyA0My4zNyI%2BCiAgPGRlZnM%2BCiAgICA8c3R5bGU%2BCiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogIzAwNDMwMDsKICAgICAgfQoKICAgICAgLmNscy0yIHsKICAgICAgICBmaWxsOiAjMDA3MDFhOwogICAgICB9CgogICAgICAuY2xzLTMgewogICAgICAgIGZpbGw6ICM0M2EwNDc7CiAgICAgIH0KCiAgICAgIC5jbHMtNCB7CiAgICAgICAgZmlsbDogIzc2ZDI3NTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM%2BCiAgPGcgaWQ9IkxheWVyXzEtMiIgZGF0YS1uYW1lPSJMYXllciAxIj4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMiIgZD0ibTIxLjc4LDMyLjY4djEwLjY5bC0xMC44OS0xMC44OXYtMTAuNjlsMTAuODksMTAuODlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Im0yMS43OCwzMi42OGwxMC45LTEwLjg5djEwLjY5bC0xMC45LDEwLjg5di0xMC42OVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTEwLjg5LDIxLjc5djEwLjY5TDAsMjEuNTh2LTEwLjY5bDEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTMiIGQ9Im00My41NywxMC44OXYxMC42OWwtMTAuODksMTAuOXYtMTAuNjlsMTAuODktMTAuOVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTIxLjc4LDMyLjY4bC0xMC44OS0xMC44OSwxMC44OS0xMC45LDEwLjksMTAuOS0xMC45LDEwLjg5WiIvPgogICAgPHBhdGggY2xhc3M9ImNscy00IiBkPSJtMTAuODksMjEuNzlMMCwxMC44OSwxMC44OSwwbDEwLjg5LDEwLjg5LTEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTQiIGQ9Im0zMi42OCwyMS43OWwtMTAuOS0xMC45TDMyLjY4LDBsMTAuODksMTAuODktMTAuODksMTAuOVoiLz4KICA8L2c%2BCjwvc3ZnPg%3D%3D&logoColor=gray)

---

> Latest release: `0.10.3`

> **Important**
> Currently in beta. Feedback welcome but will probably break your build.

Use [GraalVM](https://graalvm.org) from [Bazel](https://bazel.build), with support for:

- [Building native image binaries](./docs/native-image.md)
- [Installing components with `gu`](./docs/components.md)
- [Using GraalVM as a Bazel Java toolchain](./docs/toolchain.md)
- [Support for Bazel 6, Bazel 7, and Bzlmod](./docs/modern-bazel.md)
- [Support for Bazel 4 and Bazel 5, drop-in replacement for `rules_graal`](./legacy-bazel.md)
- [Run tools from GraalVM directly](./docs/binary-targets.md)
- [Build native shared libraries from Java or polyglot code](./docs/shared-libraries.md)
- [Example projects for each Bazel version](./docs/examples.md)
- [Hermetic compilation on all platforms](./docs/hermeticity.md)
- [Respects conventional Bazel build settings](./docs/build-settings.md)
- [Easily use GraalVM Maven artifacts](./docs/maven-artifacts.md)
- [Now available on BCR](https://registry.bazel.build/modules/rules_graalvm)
- Support for macOS, Linux, Windows (including Native Image!) ([support matrix](./docs/modern-bazel.md))
- Support for the latest modern GraalVM releases (Community Edition and Oracle GraalVM)

## Installation

> API docs for [`graalvm_repository`](./api/repositories.md)

**Via `WORKSPACE.bazel`:**

```starlark
http_archive(
    name = "rules_graalvm",
    sha256 = "1f4b9979e75033042df4e9405a0a949aa5dd9427e72c8aafd8891d8f674e75e4",
    strip_prefix = "rules_graalvm-0.10.3",
    urls = [
        "https://github.com/sgammon/rules_graalvm/releases/download/v0.10.3/rules_graalvm-0.10.3.zip",
    ],
)
```

```starlark
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")
```

```starlark
graalvm_repository(
    name = "graalvm",
    components = [
       # if you need components like `js` or `wasm`, add them here
    ],
    distribution = "ce",  # `oracle`, `ce`, or `community`
    java_version = "20",  # `17`, `20`, or `21`, as supported by the version provided
    version = "20.0.2",  # earlier version format like `22.x` also supported
)
```

```starlark
load("@rules_graalvm//graalvm:workspace.bzl", "register_graalvm_toolchains", "rules_graalvm_repositories")
```

```starlark
rules_graalvm_repositories()

register_graalvm_toolchains()
```

**Or, via `MODULE.bazel`:**

```starlark
bazel_dep(name = "rules_graalvm", version = "0.10.3")
```
```starlark
gvm = use_extension("@rules_graalvm//:extensions.bzl", "graalvm")

gvm.graalvm(
    name = "graalvm",
    version = "20.0.2",  # earlier version format like `22.x` also supported
    distribution = "oracle",  # `oracle`, `ce`, or `community`
    java_version = "20",  # `17`, `20`, or `21`, as supported by the version provided
    components = [
       # if you need components like `js` or `wasm`, add them here
    ],
)
use_repo(gvm, "graalvm")
register_toolchains("@graalvm//:jvm")
register_toolchains("@graalvm//:sdk")
```

## Usage: Java Toolchains

You can use the `graalvm_repository` as a Java toolchain, by registering it like below:

**Via `WORKSPACE.bazel`:**

```starlark
load("@rules_graalvm//graalvm:workspace.bzl", "register_graalvm_toolchains", "rules_graalvm_repositories")
```

```starlark
rules_graalvm_repositories()

register_graalvm_toolchains()
```

**Via Bzlmod:**

```starlark
register_toolchains("@graalvm//:jvm")
register_toolchains("@graalvm//:sdk")
```

**To _use_ the toolchain, add this to your `.bazelrc`:**

```
build --extra_toolchains=@graalvm//:toolchain
build --java_runtime_version=graalvm_20
```

> **Note**
> If you name your repository `example` and set the Java version to `21`, your `java_runtime_version` would be `example_21`.

## Build a native binary on Bazel 6+

> API docs for [`native_image`](./api/defs.md)

**In a `BUILD.bazel` file:**

```python
load("@rules_java//java:defs.bzl", "java_library")
load("@rules_graalvm//graalvm:defs.bzl", "native_image")

java_library(
    name = "main",
    srcs = glob(["Main.java"]),
)

native_image(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
    native_image_tool = "@graalvm//:native-image",
)
```

### Native image toolchains

It is supported to specify the `native-image` tool as above, using the `native_image_tool` attribute
on your target. In fact, you _must_ do this _unless_ you register the GraalVM toolchains as shown in
the installation instructions.

When using toolchains, the `native_image_tool` attribute can be omitted, which delegates to Bazel's
toolchain system to resolve the tool:

**Resolve via toolchains:**

```python
native_image(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
)
```

**Or point to a specific `native-image` tool:**

```python
native_image(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
    native_image_tool = "@graalvm//:native-image",
)
```

## Build a native binary on Bazel 4 and Bazel 5

> API docs for legacy [`native_image`](./api/legacy.md) rule

**In a `BUILD.bazel` file:**

```python
load("@rules_java//java:defs.bzl", "java_library")
load("@rules_graalvm//graal:graal.bzl", "native_image")

java_library(
    name = "main",
    srcs = glob(["Main.java"]),
)

native_image(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
)
```

**Note:** In the legacy rules, you don't have to specify `native_image_tool`, but on the other hand,
the default target `@graalvm//:native-image` is hard-coded in. If you use a different repository name
make sure to add the `native_image_tool` attribute to point to `@yourrepo//:native-image`.

## Examples

See the list of [examples](./docs/examples.md), which are used as continuous integration tests. Examples are available
for Bazel 4-7.

## Hermeticity / strictness

These rules attempt to strike as optimal a balance as possible between older Bazel support (starting at Bazel 4) and the
maximum possible strictness/hermeticity for action execution.

[Bazel Toolchains][1] are used to resolve the C++ compiler which is provided to `native-image`.
Toolchains are additionally used within the rules to provide and resolve tools from GraalVM itself.

For information about strictness tuning on each operating system, see the [hermeticity guide][2].

### GraalVM toolchain type

The GraalVM-specific toolchain type is available at:

```
@rules_graalvm//graalvm/toolchain:toolchain_type
```

If you install GraalVM at a repository named `@graalvm`, the toolchain targets are:

**Java toolchain:**

```
@graalvm//:jvm
```

**GraalVM toolchain:**

```
@graalvm//:sdk
```

The default `WORKSPACE` and Bzlmod installation instructions register both types of toolchains.
**The GraalVM toolchain is required** to perform builds with `native-image` (or you must provide a `native_image_tool`
target).

## Acknowledgements

Built on top of @andyscott's fantastic work with [rules_graal](https://github.com/andyscott/rules_graal).

[1]: https://bazel.build/extending/toolchains
[2]: ./docs/hermeticity.md
