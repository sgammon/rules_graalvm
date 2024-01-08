# GraalVM Rules for Bazel

[![CI](https://github.com/sgammon/rules_graalvm/actions/workflows/on.push.yml/badge.svg)](https://github.com/sgammon/rules_graalvm/actions/workflows/on.push.yml)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4-ff69b4.svg)](CODE_OF_CONDUCT.md)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/sgammon/rules_graalvm/badge)](https://securityscorecards.dev/viewer/?uri=github.com/sgammon/rules_graalvm)
![Bazel 7](https://img.shields.io/badge/Bazel%207-black?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyBpZD0iTGF5ZXJfMiIgZGF0YS1uYW1lPSJMYXllciAyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0My41NyA0My4zNyI%2BCiAgPGRlZnM%2BCiAgICA8c3R5bGU%2BCiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogIzAwNDMwMDsKICAgICAgfQoKICAgICAgLmNscy0yIHsKICAgICAgICBmaWxsOiAjMDA3MDFhOwogICAgICB9CgogICAgICAuY2xzLTMgewogICAgICAgIGZpbGw6ICM0M2EwNDc7CiAgICAgIH0KCiAgICAgIC5jbHMtNCB7CiAgICAgICAgZmlsbDogIzc2ZDI3NTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM%2BCiAgPGcgaWQ9IkxheWVyXzEtMiIgZGF0YS1uYW1lPSJMYXllciAxIj4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMiIgZD0ibTIxLjc4LDMyLjY4djEwLjY5bC0xMC44OS0xMC44OXYtMTAuNjlsMTAuODksMTAuODlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Im0yMS43OCwzMi42OGwxMC45LTEwLjg5djEwLjY5bC0xMC45LDEwLjg5di0xMC42OVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTEwLjg5LDIxLjc5djEwLjY5TDAsMjEuNTh2LTEwLjY5bDEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTMiIGQ9Im00My41NywxMC44OXYxMC42OWwtMTAuODksMTAuOXYtMTAuNjlsMTAuODktMTAuOVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTIxLjc4LDMyLjY4bC0xMC44OS0xMC44OSwxMC44OS0xMC45LDEwLjksMTAuOS0xMC45LDEwLjg5WiIvPgogICAgPHBhdGggY2xhc3M9ImNscy00IiBkPSJtMTAuODksMjEuNzlMMCwxMC44OSwxMC44OSwwbDEwLjg5LDEwLjg5LTEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTQiIGQ9Im0zMi42OCwyMS43OWwtMTAuOS0xMC45TDMyLjY4LDBsMTAuODksMTAuODktMTAuODksMTAuOVoiLz4KICA8L2c%2BCjwvc3ZnPg%3D%3D&logoColor=gray)
![Bzlmod](https://img.shields.io/badge/Bzlmod-black?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyBpZD0iTGF5ZXJfMiIgZGF0YS1uYW1lPSJMYXllciAyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0My41NyA0My4zNyI%2BCiAgPGRlZnM%2BCiAgICA8c3R5bGU%2BCiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogIzAwNDMwMDsKICAgICAgfQoKICAgICAgLmNscy0yIHsKICAgICAgICBmaWxsOiAjMDA3MDFhOwogICAgICB9CgogICAgICAuY2xzLTMgewogICAgICAgIGZpbGw6ICM0M2EwNDc7CiAgICAgIH0KCiAgICAgIC5jbHMtNCB7CiAgICAgICAgZmlsbDogIzc2ZDI3NTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM%2BCiAgPGcgaWQ9IkxheWVyXzEtMiIgZGF0YS1uYW1lPSJMYXllciAxIj4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMiIgZD0ibTIxLjc4LDMyLjY4djEwLjY5bC0xMC44OS0xMC44OXYtMTAuNjlsMTAuODksMTAuODlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Im0yMS43OCwzMi42OGwxMC45LTEwLjg5djEwLjY5bC0xMC45LDEwLjg5di0xMC42OVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTEwLjg5LDIxLjc5djEwLjY5TDAsMjEuNTh2LTEwLjY5bDEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTMiIGQ9Im00My41NywxMC44OXYxMC42OWwtMTAuODksMTAuOXYtMTAuNjlsMTAuODktMTAuOVoiLz4KICAgIDxwYXRoIGNsYXNzPSJjbHMtMyIgZD0ibTIxLjc4LDMyLjY4bC0xMC44OS0xMC44OSwxMC44OS0xMC45LDEwLjksMTAuOS0xMC45LDEwLjg5WiIvPgogICAgPHBhdGggY2xhc3M9ImNscy00IiBkPSJtMTAuODksMjEuNzlMMCwxMC44OSwxMC44OSwwbDEwLjg5LDEwLjg5LTEwLjg5LDEwLjlaIi8%2BCiAgICA8cGF0aCBjbGFzcz0iY2xzLTQiIGQ9Im0zMi42OCwyMS43OWwtMTAuOS0xMC45TDMyLjY4LDBsMTAuODksMTAuODktMTAuODksMTAuOVoiLz4KICA8L2c%2BCjwvc3ZnPg%3D%3D&logoColor=gray)

---

> Latest release: [`0.11.0`](https://registry.bazel.build/modules/rules_graalvm)

Use [GraalVM](https://graalvm.org) with [Bazel](https://bazel.build) to:

- [Build native binaries from polyglot apps](./docs/native-image.md)
- [Build native shared libraries from Java or polyglot code](./docs/shared-libraries.md)
- [Use GraalVM as a Bazel Java toolchain](./docs/toolchain.md)
- [Easily use GraalVM Maven artifacts](./docs/maven-artifacts.md)
- [Install components with `gu`](./docs/components.md)

**Additional features:**

- [Example projects for all use cases](./docs/examples.md)
- [Hermetic compilation on all platforms](./docs/hermeticity.md)
- [Run tools from GraalVM directly](./docs/binary-targets.md)
- [Support for Bazel 6, Bazel 7, and Bzlmod](./docs/modern-bazel.md)
- [Support for Bazel 4 and Bazel 5, drop-in replacement for `rules_graal`](./legacy-bazel.md)
- Support for macOS, Linux, Windows (including Native Image!) ([support matrix](./docs/modern-bazel.md))
- Support for the latest modern GraalVM releases (Community Edition and Oracle GraalVM)

## Getting Started

- [Installation](#installation)
- [Examples](#examples)
- [Usage: Java Toolchains](#usage-java-toolchains)
- [Usage: Native Image (Bazel 6+)](#usage-native-image-modern-bazel)
- [Usage: Native Image (Bazel 4-6)](#usage-native-image-legacy-bazel)
- [Hermeticity & Strictness](#hermeticity-strictness)
- [GraalVM Toolchains](#graalvm-toolchains)

## Installation

> API docs for [`graalvm_repository`](./api/repositories.md)

**Via `WORKSPACE.bazel`:**

| Artifact | SHA256 |
| ------- | ----------- |
| `rules_graalvm-0.11.0.zip` | `f907041330f7eff8a0af1c19fdf936f0c8f8bc127cb52d5a1dde444784d9df54 ` |
| `rules_graalvm-0.11.0.tgz` | `07ee6451dd4fd78625b0f0d94b9df9bf673716bf9572a0ab24675bc052928f7a ` |

```starlark
http_archive(
    name = "rules_graalvm",
    sha256 = "f907041330f7eff8a0af1c19fdf936f0c8f8bc127cb52d5a1dde444784d9df54",
    strip_prefix = "rules_graalvm-0.11.0",
    urls = [
        "https://github.com/sgammon/rules_graalvm/releases/download/v0.11.0/rules_graalvm-0.11.0.zip",
    ],
)
```

```starlark
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")
```

```starlark
graalvm_repository(
    name = "graalvm",
    distribution = "ce",  # `oracle`, `ce`, or `community`
    java_version = "21",  # `17`, `20`, or `21`, as supported by the version provided
    version = "21.0.1",  # earlier version format like `22.x` also supported
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

| Artifact | Integrity value |
| ------- | --------------- |
| `rules_graalvm-0.11.0.zip` | `sha256-+QcEEzD37/igrxwZ/fk28Mj4vBJ8tS1aHd5ER4TZ31Q=` |
| `rules_graalvm-0.11.0.tgz` | `sha256-B+5kUd1P14YlsPDZS535v2c3Fr+VcqCrJGdbwFKSj3o=` |

```starlark
bazel_dep(name = "rules_graalvm", version = "0.11.0")
```

```starlark
gvm = use_extension("@rules_graalvm//:extensions.bzl", "graalvm")

gvm.graalvm(
    name = "graalvm",
    version = "21.0.1",  # earlier version format like `22.x` also supported
    distribution = "ce",  # `oracle`, `ce`, or `community`
    java_version = "21",  # `17`, `20`, or `21`, as supported by the version provided
)
use_repo(gvm, "graalvm")
register_toolchains("@graalvm//:jvm")
register_toolchains("@graalvm//:sdk")
```

## Examples

See the list of [examples](./docs/examples.md), which are used as continuous integration tests. Examples are available
for Bazel 4-7.

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

<a id="usage-native-image-modern-bazel"></a>

## Usage: Native Image (Bazel 6+)

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

<a id="usage-native-image-legacy-bazel"></a>

## Usage: Native Image (Bazel 4 & 5)

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

> [!IMPORTANT]
> In the legacy rules, you don't have to specify `native_image_tool`, but on the other hand, the default target `@graalvm//:native-image` is hard-coded in. If you use a different repository name make sure to add the `native_image_tool` attribute to point to `@yourrepo//:native-image`.

<a id="hermeticity-strictness"></a>

## Hermeticity & Strictness

These rules attempt to strike as optimal a balance as possible between older Bazel support (starting at Bazel 4) and the
maximum possible strictness/hermeticity for action execution.

[Bazel Toolchains][1] are used to resolve the C++ compiler which is provided to `native-image`.
Toolchains are additionally used within the rules to provide and resolve tools from GraalVM itself.

For information about strictness tuning on each operating system, see the [hermeticity guide][2].

<a id="graalvm-toolchains"></a>

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

# Adoption

`rules_graalvm` is used in the following organizations and in [Bazel itself](https://github.com/bazelbuild/bazel/pull/19361), as part of the [Turbine](https://github.com/google/turbine) toolchain.

If you are using `rules_graalvm`, let us know with a PR!

<br />

<img src="./docs/images/google.svg" alt="Google logo" height=40 />

> Bazel uses `rules_graalvm` for [Native Turbine](https://github.com/bazelbuild/bazel/pull/19361).

<br />

<img src="./docs/images/netflix.png" alt="Netflix logo" height=50 />

> Netflix apparently uses it somehow.

<br />

<img src="./docs/images/elide.png" alt="Elide logo" height=40 />

> Elide uses `rules_graalvm` as part of the tooling for the [Elide Runtime](https://elide.dev), and for [Buildless](https://less.build).

<br />

[![Star History Chart](https://api.star-history.com/svg?repos=sgammon/rules_graalvm&type=Date)](https://star-history.com/#sgammon/rules_graalvm&Date)

# Acknowledgements

Built on top of @andyscott's fantastic work with [rules_graal](https://github.com/andyscott/rules_graal). Several contributors helped greatly, especially with regard to Bazel's toolchains and C++ features: @fmeum and others.

[1]: https://bazel.build/extending/toolchains
[2]: ./docs/hermeticity.md
