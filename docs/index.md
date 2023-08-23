# GraalVM Rules for Bazel

> Latest release: `0.9.1`

These rules let you use [GraalVM](https://graalvm.org) from [Bazel](https://bazel.build), with support for:

- [Building native image binaries](./native-image.md)
- [Installing components with `gu`](./components.md)
- [Using GraalVM as a Bazel Java toolchain](./toolchain.md)
- [Support for Bazel 6, Bazel 7, and Bzlmod](./modern-bazel.md)
- [Support for Bazel 5 and Bazel 4, drop-in replacement for `rules_graal`](./legacy-bazel.md)
- [Run GraalVM binaries directly](./binary-targets.md)
- Support for macOS, Linux, Windows (including Native Image!)
- Support for the latest modern GraalVM releases (Community Edition and Oracle GraalVM)

## Installation

> API docs for [`graalvm_repository`](./api/repositories.md)

**Via `WORKSPACE.bazel`:**

```python
http_archive(
    name = "rules_graalvm",
    sha256 = "96323ac1b7a5b9db1ae1a388c5ed1fb830d4628d3ab4b7f09538558321e03111",
    strip_prefix = "rules_graalvm-0.9.0",
    urls = [
        "https://github.com/sgammon/rules_graalvm/releases/download/v0.9.1/rules_graalvm-0.9.1.tar.gz",
    ],
)
```

```python
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")
```

```python
graalvm_repository(
    name = "graalvm",
    components = [
       # if you need components like `js` or `wasm`, add them here
    ],
    distribution = "oracle",  # `oracle`, `ce`, or `community`
    java_version = "20",  # `17`, `20`, or `21`, as supported by the version provided
    version = "20.0.2",  # earlier version format like `22.x` also supported
)
```

**Or, via `MODULE.bazel`:**

> **Important**
> To use Bzlmod with `rules_graalvm`, you will need the `archive_override` below (until this package is made available on BCR).

```python
bazel_dep(name = "rules_graalvm", version = "0.9.0")
```

```python
# Until we ship to BCR:
archive_override(
    module_name = "rules_graalvm",
    urls = ["https://github.com/sgammon/rules_graalvm/releases/download/v0.9.1/rules_graalvm-0.9.1.tar.gz"],
    strip_prefix = "rules_graalvm-0.9.1",
    integrity = None,
)
```

```python
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
use_repo(
    gvm,
    "graalvm",
)
```

## Usage

These rules are [documented](https://sgammon.github.io/rules_graalvm); you can find important docs at these links:

- [`graalvm_repository`](./api/repositories.md): Declaring and consuming a GraalVM installation
- [`native_image`](./api/defs.md): Building a GraalVM `native-image` from Java code

### Java Toolchains

You can use the `graalvm_repository` as a Java toolchain, by registering it like below:

**From `WORKSPACE.bazel`:**

```python
# graalvm_repository(...)
```

```python
register_toolchains("@graalvm//:toolchain")
```

**From `.bazelrc`:**

```
build --extra_toolchains=@graalvm//:toolchain
build --java_runtime_version=graalvm_20
```

Read more in the [Toolchain Guide](./toolchain.md).

### Build a native binary on Bazel 6+

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

#### Native image toolchains

It is supported to specify the `native-image` tool as above, using the `native_image_tool` attribute
on your target. In fact, you _must_ do this _unless_ you register the GraalVM toolchains as shown in
the installation instructions.

When using toolchains, the `native_image_tool` attribute can be omitted, which delegates to Bazel's
toolchain system to resolve the tool:

```python
native_image(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
)
```

### Build a native binary on Bazel 4 and Bazel 5

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
@graalvm//:toolchain
```

**GraalVM toolchain:**

```
@graalvm//:gvm
```

The default `WORKSPACE` and Bzlmod installation instructions register both types of toolchains.
**The GraalVM toolchain is required** to perform builds with `native-image` (or you must provide a `native_image_tool`
target).

## Acknowledgements

Built on top of @andyscott's fantastic work with [rules_graal](https://github.com/andyscott/rules_graal).

[1]: https://bazel.build/extending/toolchains
[2]: ./hermeticity.md
