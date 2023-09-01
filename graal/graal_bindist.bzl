"Legacy repository rule alias."

load(
    "//internal:graalvm_bindist.bzl",
    _graalvm_repository = "graalvm_repository",
)

## Exports
def graal_bindist_repository(
        name,
        java_version,
        version,
        **kwargs):
    """Legacy alias to declare a GraalVM repository target from a `WORKSPACE` file.

    If `distribution` is set to `oracle`, an Oracle GraalVM installation is downloaded. This variant of
    GraalVM may be subject to different license obligations; please consult Oracle's docs for more info.

    Oracle GraalVM distributions are downloaded directly from Oracle, which provides a `latest` download
    endpoint. Set `version` to `latest` (the default value) to download the latest available version of
    GraalVM matching the provided `java_version`.

    Args:
        name: Name of the VM repository.
        java_version: Java version to use/declare, like "20". Mandatory.
        version: Version of the GraalVM release, like "23.1.0" or "20.0.2". Mandatory.
        **kwargs: Passed to the underlying bindist repository rule.
    """

    _graalvm_repository(
        name = name,
        java_version = java_version,
        version = version,
        **kwargs
    )
