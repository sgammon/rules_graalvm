<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Defines Maven helpers and coordinates for GraalVM artifacts.

<a id="alias.artifact"></a>

## alias.artifact

<pre>
alias.artifact(<a href="#alias.artifact-artifact">artifact</a>, <a href="#alias.artifact-repo">repo</a>, <a href="#alias.artifact-version">version</a>)
</pre>

Helper which rewrites a target to be compatible with `rules_jvm_external`.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="alias.artifact-artifact"></a>artifact |  Enumerated artifact entry.   |  none |
| <a id="alias.artifact-repo"></a>repo |  Repository name; defaults to `@maven`.   |  `"@maven"` |
| <a id="alias.artifact-version"></a>version |  Defaults to `None`; optional.   |  `None` |

**RETURNS**

Artifact target.


<a id="alias.coordinate"></a>

## alias.coordinate

<pre>
alias.coordinate(<a href="#alias.coordinate-group">group</a>, <a href="#alias.coordinate-artifact">artifact</a>, <a href="#alias.coordinate-repo">repo</a>, <a href="#alias.coordinate-version">version</a>)
</pre>

Helper which rewrites a target to be compatible with `rules_jvm_external`.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="alias.coordinate-group"></a>group |  Group for the artifact.   |  none |
| <a id="alias.coordinate-artifact"></a>artifact |  ID for the artifact.   |  none |
| <a id="alias.coordinate-repo"></a>repo |  Repository name; defaults to `@maven`.   |  `"@maven"` |
| <a id="alias.coordinate-version"></a>version |  Defaults to `None`; optional.   |  `None` |

**RETURNS**

Artifact target.


<a id="graalvm.artifact"></a>

## graalvm.artifact

<pre>
graalvm.artifact(<a href="#graalvm.artifact-maven">maven</a>, <a href="#graalvm.artifact-artifact">artifact</a>, <a href="#graalvm.artifact-version">version</a>)
</pre>

Helper which declares a Maven artifact using `rules_jvm_external` macros for the provided inputs.

Any struct can be provided as `artifact` which has the `artifact` and `group` properties. For
convenience, well-known GraalVM artifact coordinates are available at `graalvm.catalog`.

Example of use from `WORKSPACE.bazel`:

    ```starlark
    load("@rules_jvm_external//:specs.bzl", "maven")
    load("@rules_graalvm//artifacts:maven.bzl", "graalvm")

    # ...
    graalvm.artifact(
        maven,
        artifact = graalvm.catalog.SDK,
        version = "23.0.1",
    )
    ```

Example of use from Bzlmod:

    ```starlark
    maven = use_extension("@rules_jvm_external//:extensions.bzl", "maven")
    graalvm = use_extension("@rules_graalvm//:extensions.bzl", "graalvm")

    # ...
    graalvm.artifact(
        maven,
        artifact = graalvm.catalog.SDK,
        version = "23.0.1",
    )
    ```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="graalvm.artifact-maven"></a>maven |  Maven artifact spawn struct provided by `rules_jvm_external`.   |  none |
| <a id="graalvm.artifact-artifact"></a>artifact |  Artifact to use from `MavenArtifacts`, or a `struct` with `artifact` and `group`.   |  none |
| <a id="graalvm.artifact-version"></a>version |  Version of the artifact to declare.   |  none |

**RETURNS**

Maven artifact specification.


<a id="graalvm_maven_artifact"></a>

## graalvm_maven_artifact

<pre>
graalvm_maven_artifact(<a href="#graalvm_maven_artifact-maven">maven</a>, <a href="#graalvm_maven_artifact-artifact">artifact</a>, <a href="#graalvm_maven_artifact-version">version</a>)
</pre>

Helper which declares a Maven artifact using `rules_jvm_external` macros for the provided inputs.

Any struct can be provided as `artifact` which has the `artifact` and `group` properties. For
convenience, well-known GraalVM artifact coordinates are available at `graalvm.catalog`.

Example of use from `WORKSPACE.bazel`:

    ```starlark
    load("@rules_jvm_external//:specs.bzl", "maven")
    load("@rules_graalvm//artifacts:maven.bzl", "graalvm")

    # ...
    graalvm.artifact(
        maven,
        artifact = graalvm.catalog.SDK,
        version = "23.0.1",
    )
    ```

Example of use from Bzlmod:

    ```starlark
    maven = use_extension("@rules_jvm_external//:extensions.bzl", "maven")
    graalvm = use_extension("@rules_graalvm//:extensions.bzl", "graalvm")

    # ...
    graalvm.artifact(
        maven,
        artifact = graalvm.catalog.SDK,
        version = "23.0.1",
    )
    ```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="graalvm_maven_artifact-maven"></a>maven |  Maven artifact spawn struct provided by `rules_jvm_external`.   |  none |
| <a id="graalvm_maven_artifact-artifact"></a>artifact |  Artifact to use from `MavenArtifacts`, or a `struct` with `artifact` and `group`.   |  none |
| <a id="graalvm_maven_artifact-version"></a>version |  Version of the artifact to declare.   |  none |

**RETURNS**

Maven artifact specification.


