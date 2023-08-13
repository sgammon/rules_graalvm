
## Usage from modern Bazel

See instructions below for installation and use of `rules_graalvm` on Bazel 6 or newer, via Bazel Modules:

### Installation in `MODULE.bazel`

```starlark
bazel_dep(name = "rules_graalvm", version = "<version>")
```

**Toolchain registration in `WORKSPACE.bzlmod` (optional):**
```starlark
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

# graalvm_repository(name = "graalvm" ...)

register_toolchains("@graalvm//:all")
```

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

## Use as a toolchain

See the [toolchains guide](./toolchain.md) for more information.
