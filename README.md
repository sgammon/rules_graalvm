# `rules_graalvm`

> [!IMPORTANT]  
> Currently in beta. Will probably break

Use [GraalVM](https://graalvm.org) from Bazel, with support for:

- [Building native image binaries](./docs/native-image.md)
- [Installing components with `gu`](./docs/components.md)
- [Using GraalVM as a Bazel Java toolchain](./docs/toolchain.md)
- [Support for Bazel 6, Bazel 7, and Bzlmod](./docs/modern-bazel.md)
- Support for macOS, Linux, Windows
- Support for latest modern GraalVM releases (Community Edition and Oracle GraalVM)

## Installation

**Via `WORKSPACE.bazel`:**
```starlark
http_archive(
    name = "rules_graalvm",
    sha256 = "96323ac1b7a5b9db1ae1a388c5ed1fb830d4628d3ab4b7f09538558321e03111",
    strip_prefix = "rules_graalvm-0.9.0",
    urls = [
        "https://github.com/sgammon/rules_graalvm/archive/v0.9.0.tar.gz",
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
    distribution = "oracle",  # `oracle`, `ce`, or `community`
    java_version = "20",  # `17`, `20`, or `21`, as supported by the version provided
    version = "20.0.2",  # earlier version format like `22.x` also supported
)
```

**Or, via `MODULE.bazel`:**

> [!IMPORTANT]  
> To use Bzlmod with `rules_graalvm`, you will need the `archive_override` below (until this package is made available on BCR).

```starlark
bazel_dep(name = "rules_graalvm", version = "0.9.0")
```
```starlark
# Until we ship to BCR:
archive_override(
    module_name = "rules_graalvm",
    urls = ["https://github.com/sgammon/rules_graalvm/archive/v0.9.0.tar.gz"],
    strip_prefix = "rules_graalvm-0.9.0",
    integrity = "sha256-ljI6wbeludsa4aOIxe0fuDDUYo06tLfwlThVgyHgMRE=",
)
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
use_repo(
    gvm,
    "graalvm",
)
```

## Usage: Java Toolchains

You can use the `graalvm_repository` as a Java toolchain, by registering it like below:

**From `WORKSPACE.bazel`:**
```starlark
# graalvm_repository(...)
```
```starlark
register_toolchains("@graalvm//:toolchain")
```

**From `.bazelrc`:**
```
build --extra_toolchains=@graalvm//:toolchain
build --java_runtime_version=graalvm_20
```

> [!NOTE]  
> If you name your repository `example` and set the Java version to `21`, your `java_runtime_version` would be `example_21`.

## Usage: Build a native binary

This example is present in the repository at `//example/native`. You can build it in your own workspace with `bazel build @rules_graalvm//example/native`.

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
)
```

## Acknowledgements

Built on top of @andyscott's fantastic work with [rules_graal](https://github.com/andyscott/rules_graal).
