"Defines Maven helpers and coordinates for GraalVM artifacts."

load("@rules_jvm_external//:specs.bzl", "maven")

# buildifier: disable=name-conventions
_MavenArtifacts = struct(
    SVM = struct(
        artifact = "svm",
        group = "org.graalvm.nativeimage",
        neverlink = True,
    ),
    SDK = struct(
        artifact = "graal-sdk",
        group = "org.graalvm.sdk",
        neverlink = True,
    ),
    POLYGLOT = struct(
        artifact = "polyglot",
        group = "org.graalvm.polyglot",
    ),
    TRUFFLE = struct(
        artifact = "truffle-api",
        group = "org.graalvm.truffle",
        NFI = struct(
            artifact = "truffle-nfi",
            group = "org.graalvm.truffle",
        ),
    ),
)

def _transform_artifact_segment(segment):
    return segment.replace("-", "_").replace(".", "_")

def _graalvm_maven_alias(group, artifact, repo = "@maven", version = None):
    """Helper which rewrites a target to be compatible with `rules_jvm_external`.

    Args:
        group: Group for the artifact.
        artifact: ID for the artifact.
        repo: Repository name; defaults to `@maven`.
        version: Defaults to `None`; optional.

    Returns:
        Artifact target.
    """

    return Label(
        "%s//:%s_%s%s" % (
            repo,
            _transform_artifact_segment(group),
            _transform_artifact_segment(artifact),
            version and _transform_artifact_segment(version) or "",
        ),
    )

def _graalvm_artifact_alias(artifact, repo = "@maven", version = None):
    """Helper which rewrites a target to be compatible with `rules_jvm_external`.

    Args:
        artifact: Enumerated artifact entry.
        repo: Repository name; defaults to `@maven`.
        version: Defaults to `None`; optional.

    Returns:
        Artifact target.
    """

    return _graalvm_maven_alias(
        artifact = artifact.artifact,
        group = artifact.group,
        version = version,
        repo = repo,
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
        neverlink = artifact.get("neverlink", False),
    )

# buildifier: disable=name-conventions
_MavenTools = struct(
    catalog = _MavenArtifacts,
    artifact = _graalvm_maven_artifact,
)

# buildifier: disable=name-conventions
MavenTools = _MavenTools

# Exports.

# buildifier: disable=name-conventions
graalvm = _MavenTools

alias = struct(
    coordinate = _graalvm_maven_alias,
    artifact = _graalvm_artifact_alias,
    catalog = _MavenArtifacts,
)

# buildifier: disable=name-conventions
MavenArtifacts = _MavenArtifacts

graalvm_maven_artifact = _graalvm_maven_artifact
