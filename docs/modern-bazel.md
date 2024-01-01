## Usage from modern Bazel

See instructions below for installation and use of `rules_graalvm` on Bazel 6 or newer, via Bazel Modules.
Also, you can consult the **Version support matrix** at the bottom of this page to determine the bese way to use GraalVM
with your Bazel project.

### Installation in `MODULE.bazel`

```starlark
bazel_dep(name = "rules_graalvm", version = "<version>")
```

**Toolchain registration in `WORKSPACE.bzlmod` (optional):**

```starlark
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

# graalvm_repository(name = "graalvm" ...)

register_toolchains("@graalvm//:jvm")
register_toolchains("@graalvm//:sdk")
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

## Use as a Java toolchain

See the [toolchains guide](./toolchain.md) for more information.

## Version support matrix

> **Note**
> This version table doesn't make sense at first glance. **That's because GraalVM underwent a version scheme change**
> after the `22.3.2` release; at this point, releases began following OpenJDK releases, so `17.0.7` and `20.0.1` are
> _actually newer_ than `22.3.2`. `17.0.7` is a JDK17 release, while `20.0.1` is a JDK20 release (in this example). The
> GraalVM Rules for Bazel support both schemes.

| GraalVM version     | Bazel version | `rules_graalvm`   | Native Image | Components | Windows | Java Toolchains | Hermetic | Notes                                 |
| ------------------- | ------------- | ----------------- | ------------ | ---------- | ------- | --------------- | -------- | ------------------------------------- |
| `17.0.7+`/`21+`     | Bazel 7 LTS   | `0.11.0+`         | ✅           | ✅         | ✅      | ✅              | ✅       | Use this doc                          |
| `17.0.7+`/`20.0.1+` | Bazel 7+      | `0.10.0+`         | ✅           | ✅         | ✅      | ✅              | ✅       | Use this doc                          |
| `17.0.7+`/`20.0.1+` | Bazel 7+      | `0.9.0`           | ✅           | ⚠️         | ⚠️      | ✅              | ✅       | Use this doc                          |
| `17.0.7+`/`20.0.1+` | Bazel 6.x     | `0.10.0+`         | ✅           | ✅         | ✅      | ✅              | ✅       | Use this doc                          |
| `17.0.7+`/`20.0.1+` | Bazel 5.x     | `0.10.0+`         | ✅           | ✅         | ✖️      | ✅              | ✖️       | See [legacy Bazel](./legacy-bazel.md) |
| `17.0.7+`/`20.0.1+` | Bazel 4.x     | `0.10.0+`         | ✅           | ✅         | ✖️      | ✅              | ✖️       | See [legacy Bazel](./legacy-bazel.md) |
| `19.0.0`-`22.3.2`   | Bazel 4+      | `0.10.0`          | ✅           | ✅         | ✖️      | ✅              | ✖️       | See [legacy Bazel](./legacy-bazel.md) |
| `19.0.0`-`22.3.2`   | Bazel 3.x     | [Legacy rules][1] | ✅           | ✖️         | ✖️      | ✖️              | ✖️       | Use [`rules_graal`][1]                |

## Java Rules Compatibility

When using `rules_graalvm`, your `rules_java` version must be modern enough for your selected version of Bazel. If you experience
errors related to `rules_java`, or Java toolchains, it's worth trying a version from the table below.

| GraalVM version     | Bazel version | `rules_graalvm`   | `rules_java` | Notes                                                                         |
| ------------------- | ------------- | ----------------- | ------------ | ----------------------------------------------------------------------------- |
| `17.0.7+`/`21+`     | Bazel 7 LTS   | `0.11.0+`         | `7.1.0+`     | Supports JVM21, **no support** for JVM20 (use JVM17 until JVM21 is supported) |
| `17.0.7+`/`20.0.1+` | Bazel 7+      | `0.9.0+`          | `6.4.0`      |                                                                               |
| `17.0.7+`/`20.0.1+` | Bazel 6.x     | `0.10.0+`         | `^6.0.0`     |                                                                               |
| `17.0.7+`/`20.0.1+` | Bazel 5.x     | `0.10.0+`         | `^5.0.0`     |                                                                               |
| `17.0.7+`/`20.0.1+` | Bazel 4.x     | `0.10.0+`         | `^4.0.0`     |                                                                               |
| `19.0.0`-`22.3.2`   | Bazel 3.x     | [Legacy rules][1] | ?            |                                                                               |

If you still can't get things working, file an issue and we can help.

[1]: https://github.com/andyscott/rules_graal
