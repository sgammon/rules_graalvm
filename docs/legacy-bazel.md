## Usage from older Bazel

See instructions below for installation and use of `rules_graalvm` on Bazel 4 or older, via the `WORKSPACE` file:

### Installation in `WORKSPACE.bazel`

If you don't want to use Bzlmod, you can install in a `WORKSPACE` manually:

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    # ... paste this part from the github releases page ... #
)

load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

graalvm_repository(
    name = "graalvm",         # anything you want
    version = "20.0.1",       # exact version of a GraalVM CE or Oracle GVM release
    distribution = "oracle",  # required for newer GVM releases (`oracle`, `ce`, or `community`)
    java_version = "20",      # java language version to use/declare
)
```

## Building native images

When building a native image on Bazel 4, **make sure to import the legacy rule:**

```starlark
load(
    "@rules_graalvm//graal:graal.bzl",
    "native_image",
)
```

**Note the import from `graal:graal.bzl`** instead of from `graalvm/native_image:rules.bzl`. This
version of the rule is designed to work with older versions of Bazel, and this import exactly matches
the [import provided by the `rules_graal` package](https://github.com/andyscott/rules_graal).

Continuing the example:

```starlark
java_library(
    name = "java",
    srcs = ["Main.java"],
)

java_binary(
    name = "main",
    main_class = "Main",
    runtime_deps = [
        ":java",
    ],
)

native_image(
    name = "main-native",
    main_class = "Main",
    deps = [":java"],
)

alias(
    name = "sample",
    actual = "main-native",
)
```

### No support for toolchains

Because older versions of Bazel don't support optional toolchains, there is no support for using
GraalVM Native Image through that mechanism. You can still customize the Native Image tool used to
build your binary:

```starlark
native_image(
    name = "main-native",
    main_class = "Main",
    deps = [":java"],
    native_image_tool = "@some_other_graalvm_repository//:native-image",
)
```

### Hard-coded repository name default

Note that the `native_image_tool` default value uses the `@graalvm` repository name for accessing
the `native-image` tool. If you don't want it to do this, you must provide your own value. Non-legacy
versions of this rule support toolchains; see [usage from modern Bazel](./modern-bazel.md).
