## GraalVM reachability metadata

GraalVM `native-image` needs explicit metadata for everything reached reflectively (reflection,
JNI, resources, serialization, proxies). The community
[`oracle/graalvm-reachability-metadata`][1] repository is the curated source of this configuration
for popular libraries - it is what the official Gradle/Maven [`native-build-tools`][2] plugins
consume. These rules bring the same mechanism to Bazel `native_image` builds.

When enabled, the curated metadata for the Maven coordinates your image transitively depends on is
resolved at build time and placed on the image's classpath, where `native-image` auto-discovers
`META-INF/native-image/**`. Resolution is delegated to the canonical
`org.graalvm.buildtools:graalvm-reachability-metadata` library, so the matching semantics
(`tested-versions`, `default-for`, `latest`, `requires`, `override`) are identical to the
Gradle/Maven plugins.

> **Note**
> Coordinates are discovered from `maven_coordinates=group:artifact:version` tags on the jars in
> your dependency graph. Dependencies resolved via [`rules_jvm_external`][3] carry these tags
> automatically; first-party `java_library` targets do not, and are simply skipped.

> **Requirement: a JDK 17+ tool runtime.**
> The resolver runs as a build action using [the canonical GraalVM resolver library][4], which is
> compiled for JDK 17. Ensure your **tool** Java runtime is JDK 17 or newer.

### Enable it on a `native_image`

The simplest form is the `resolve_upstream_reachability_metadata` attribute:

```python
load("@rules_graalvm//graalvm:defs.bzl", "native_image")

java_library(
    name = "app",
    srcs = glob(["*.java"]),
    deps = ["@maven//:commons_logging_commons_logging"],  # carries maven_coordinates tags
)

native_image(
    name = "app-native",
    main_class = "Main",
    deps = [":app"],
    resolve_upstream_reachability_metadata = True,
)
```

This walks `deps` for `maven_coordinates` tags, resolves the curated metadata for them, and adds it
to the image's classpath. No metadata is committed to your repository.

### Or use the standalone rule

`resolve_upstream_reachability_metadata` is sugar for declaring a `reachability_metadata` target
over the same `deps` and adding it to the image. You can also declare it directly — useful when you
want to share the resolved metadata across targets, or inspect it on its own:

```python
load(
    "@rules_graalvm//graalvm:defs.bzl",
    "native_image",
    "reachability_metadata",
)

reachability_metadata(
    name = "app-reachability",
    deps = [":app"],  # the aspect walks deps/runtime_deps/exports transitively
)

native_image(
    name = "app-native",
    main_class = "Main",
    deps = [
        ":app",
        ":app-reachability",
    ],
)
```

The `reachability_metadata` rule produces a resource-only `JavaInfo`, so adding it to a
`native_image`'s `deps` is all that is required.

> **Note**
> Over-providing is safe: upstream entries are guarded by `condition: typeReached`, so metadata for
> a type that is not actually on the classpath never fires.

### The pinned snapshot

The upstream repository is fetched as a pinned, integrity-checked release archive, exposed as
`@graalvm_reachability_metadata//:repository`.

A default pin ships with the rules; you do not need to declare anything. To override it (for
example, to track a newer release that tests dependency versions you need), use the
`reachability_metadata` module extension in your `MODULE.bazel`:

```starlark
reachability = use_extension("@rules_graalvm//:extensions.bzl", "reachability_metadata")
reachability.repository(
    url = "https://github.com/oracle/graalvm-reachability-metadata/releases/download/<version>/graalvm-reachability-metadata-<version>.zip",
    integrity = "sha256-...",
)
use_repo(reachability, "graalvm_reachability_metadata")
```

> **Note**
> Releases of the upstream repository lag its `master` branch. For an untested/newer dependency
> version, resolution falls back to the module's latest tested configuration (matching the
> Gradle/Maven plugins, which do this unconditionally).

[1]: https://github.com/oracle/graalvm-reachability-metadata
[2]: https://graalvm.github.io/native-build-tools/
[3]: https://github.com/bazel-contrib/rules_jvm_external
[4]: https://github.com/graalvm/native-build-tools/tree/master/common/graalvm-reachability-metadata
