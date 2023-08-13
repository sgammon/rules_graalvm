"Defines useful macros for use with GraalVM projects."

load(
    "//internal:config.bzl",
    "GRAALVM_VERSION",
)

def graalvm(artifact, repository = "@maven", version = None, group = None):
    """Return an artifact coordinate for GraalVM Maven artifact.

    Args:
        artifact: Group and name of the artifact, separated with `:`.
        repository: Name of the Maven Bazel repository to pull from; defaults to
          `@maven`.
        version: Version to use for the artifact; if `None`, a version is selected
          which matches the active GraalVM installation.
        group: Artifact group to use; if not provided, expected to be provided as
          part of the `artifact`.

    Returns:
        Desired artifact label."""

    if ":" in artifact and group:
        fail("Please provide the `group` and `artifact` separately, or together as part of `artifact`, but not both.")

    group = (group or artifact.split(":")[0]).replace(".", "_")
    name = (group and artifact or artifact.split(":")[1]).replace(".", "_")
    resolved_version = version or GRAALVM_VERSION

    if resolved_version:
        formatted_version = resolved_version.replace(".", "_")
        return Label("%s//:%s_%s_%s" % (
            repository,
            group,
            name,
            formatted_version,
        ))

    return Label("%s//:%s_%s" % (
        repository,
        group,
        name,
    ))
