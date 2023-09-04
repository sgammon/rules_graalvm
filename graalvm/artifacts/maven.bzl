"Defines Maven helpers and coordinates for GraalVM artifacts."

# buildifier: disable=name-conventions
_MavenArtifacts = struct(
    SDK = struct(
        artifact = "graal-sdk",
        group = "org.graalvm.sdk",
    ),
    TRUFFLE = struct(
        artifact = "truffle-api",
        group = "org.graalvm.truffle",

        NFI = struct(
            artifact = "truffle-api",
            group = "org.graalvm.truffle",
        ),
    ),
)

def _graalvm_maven_artifact(maven, artifact, version):
    """Helper which declares a Maven artifact using `rules_jvm_external` macros for the provided inputs.

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

    Args:
        maven: Maven artifact spawn struct provided by `rules_jvm_external`.
        artifact: Artifact to use from `MavenArtifacts`, or a `struct` with `artifact` and `group`.
        version: Version of the artifact to declare.

    Returns:
        Maven artifact specification.
    """

    return maven.artifact(
        artifact = artifact.artifact,
        group = artifact.group,
        version = version,
    )


# buildifier: disable=name-conventions
_MavenTools = struct(
    catalog = _MavenArtifacts,
    artifact = _graalvm_maven_artifact,
)

# Exports.

# buildifier: disable=name-conventions
graalvm = _MavenTools

# buildifier: disable=name-conventions
MavenArtifacts = _MavenArtifacts

graalvm_maven_artifact = _graalvm_maven_artifact
