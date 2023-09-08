
## Using GraalVM artifacts from Maven

Several important GraalVM artifacts are distributed via Maven, including the GraalVM SDK, Truffle API, and others.

These rules have some macros which make use of this libraries a bit easier, particularly via [`rules_jvm_external`][1].


### Installing a Maven artifact

**From a `WORKSPACE.bazel`:**
```python
# ... setup code for `rules_jvm_external` ...
# ... setup code for `rules_graalvm` ...

load("@rules_graalvm//graalvm/artifacts:maven.bzl", "graalvm")
load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@rules_jvm_external//:specs.bzl", "maven")
```python
```python
maven_install(
    artifacts = [
        graalvm.artifact(
            maven,
            artifact = graalvm.catalog.SDK,
            version = "23.0.1",
        ),
    ],
)
```

> **What this does:** The `graalvm.artifact` call will add the `graalvm.catalog.SDK` artifact via the `maven` struct provided by `rules_jvm_external`.

This is equivalent to the normal arguments expected by `maven_install`:
```python
maven_install(
    artifacts = [
        "org.graalvm.sdk:graal-sdk:23.0.1",
    ],
)
```


### Using a Maven artifact

In addition to the macro made available for use in the `WORKSPACE` file, there is also a macro which makes it easy to use these Maven artifacts in your `java_library(deps = *)`:

```python
load("@rules_graalvm//graalvm/artifacts:maven.bzl", graalvm = "alias")

java_library(
    name = "java",
    srcs = ["Main.java"],
    deps = [
        graalvm.artifact(graalvm.catalog.SDK),

        # other equivalent forms of this same dependency:
        #
        # graalvm.alias("org.graalvm.sdk", "graal-sdk"),
        # "@maven//:org_graalvm_sdk_graal_sdk",
    ],
)
```


## Available Maven dependencies


| Artifact         | Catalog symbol        | Maven coordinate                       | Notes                                         |
| ---------------- | --------------------- | -------------------------------------- | --------------------------------------------- |
| [GraalVM SDK][2] | `catalog.SDK`         | [`org.graalvm.sdk:graal-sdk`][3]       | Main GraalVM SDK package                      |
| [Truffle API][4] | `catalog.TRUFFLE`     | [`org.graalvm.truffle:truffle-api`][5] | API package for Truffle language implementors |
| [Truffle NFI][6] | `catalog.TRUFFLE.NFI` | [`org.graalvm.truffle:truffle-nfi`][7] | Native Function Interface package or Truffle  |


[1]: https://github.com/bazelbuild/rules_jvm_external
[2]: https://www.graalvm.org/sdk/javadoc/
[3]: https://search.maven.org/artifact/org.graalvm.sdk/graal-sdk 
[4]: https://www.graalvm.org/truffle/javadoc/com/oracle/truffle/api/package-summary.html
[5]: https://search.maven.org/artifact/org.graalvm.truffle/truffle-api
[6]: https://github.com/oracle/graal/blob/master/truffle/docs/NFI.md
[7]: https://search.maven.org/artifact/org.graalvm.truffle/truffle-nfi
