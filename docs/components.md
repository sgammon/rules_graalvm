
## Installing and using GraalVM components

Some GraalVM distributions make available _components_, which include language implementations, tooling, and other utilities. Your project may need one or more GraalVM components installed in order to build or run correctly.

Using these rules, you can declare your required components in the `graalvm_repository` rule, and they will be installed using the GraalVM Updater tool (`gu`).

By default, no components are installed beyond what is present in a given distribution. Newer versions of GraalVM distribute the `native-image` tool and `js` runtime in the base distribution.

### Installing components

**In your `WORKSPACE.bazel`:**
```starlark
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

# ...

graalvm_repository(
    name = "graalvm",
    version = "20.0.1",
    distribution = "oracle",
    java_version = "20",

    # This is how you install components
    components = [
        "wasm",
        "js",
    ],
)
```

This snippet assumes you've [set up the rules](../README.md).

> [!IMPORTANT]  
> If you declare `components`, make sure to declare the full set you need, including any that may be installed in the base distribution.


### After-install actions

With certain GraalVM components or project configurations, you may need to run post-installation actions with the GraalVM Updater tool (`gu`):

**In your `WORKSPACE.bazel`:**
```starlark
load("@rules_graalvm//graalvm:repositories.bzl", "graalvm_repository")

# ...

graalvm_repository(
    name = "graalvm",
    version = "20.0.1",
    distribution = "oracle",
    java_version = "20",

    components = [
        "espresso",
    ],
    setup_actions = [
        "gu rebuild-images libpolyglot -cp ${JAVA_HOME}/lib/graalvm/lib-javavm.jar",
    ],
)
```
