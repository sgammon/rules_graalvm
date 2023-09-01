"Provides macros for defining custom GraalVM distribution artifacts."

load(
    "//internal:graalvm_bindist_map.bzl",
    _Component = "DistributionComponent",
    _Distribution = "DistributionType",
    _Platform = "DistributionPlatform",
)


def graalvm_sdk_dist(
    version,
    java_version,
    platform,
    distribution,
    url = None,
    urls = [],
    sha256 = None,
    compatible_with = []):
    """Prepares a specification for a GraalVM JVM artifact.

    The output of calling this macro should be passed to the `sdk` kwarg of the `graalvm_distribution`
    macro. It is used as part of a custom artifact definition for the GraalVM Rules for Bazel.

    Args:
        version: Version number to use for this SDK (GraalVM version, like `23.0.1`).
        java_version: Java version to declare for this SDK (like `17.0.8`).
        platform: Platform which this SDK supports; use the `Platform` enum, available at `.platform`.
        distribution: Type of distribution; string `ce`, `community`, `oracle`, or the `Distribution`
          enum available at `.type`.
        url: Singular URL target where this SDK artifact should be downloaded from.
        urls: Array of URL targets where this SDK can be downloaded from. Wins over `url`.
        sha256: Integrity hash for the artifact.
        compatible_with: Tags to use for Bazel Platforms.

    Returns:
        x.
    """

    return struct(
        version = version,
        java_version = java_version,
        platform = platform,
        distribution = distribution,
        url = url,
        urls = urls,
        sha256 = sha256,
        compatible_with = compatible_with,
    )


def graalvm_component_dist(
    name,
    version,
    java_version,
    url = None,
    urls = [],
    sha256 = None,
    compatible_with = [],
    dependencies = [],
    launcher = None):
    """Prepares a specification for a GraalVM component artifact.

    The output of calling this macro should be passed to the `components` kwarg of the `graalvm_distribution`
    macro. It is used as part of a custom artifact definition for the GraalVM Rules for Bazel.

    Args:
        name: Name of the component; affects the target name and what is passed to `gu`.
        version: Version number to use for this SDK (GraalVM version, like `23.0.1`).
        java_version: Java version to declare for this SDK (like `17.0.8`).
        url: Singular URL target where this component should be downloaded from.
        urls: Array of URL targets where this component can be downloaded from. Wins over `url`.
        sha256: Integrity hash for the artifact.
        compatible_with: Tags to use for Bazel Platforms.
        dependencies: Other component names which this component depends on.
        launcher: Language launcher file, within the expanded component; defaults to `None`.

    Returns:
        Structure describing the input parameters in a way that the GraalVM Rules can use them.
    """

    return struct(
        name = name,
        url = url,
        urls = urls,
        sha256 = sha256,
        compatible_with = compatible_with,
        dependencies = dependencies,
        launcher = launcher,
        version = version,
        java_version = java_version,
    )


def graalvm_distribution_artifacts(
    sdk = None,
    components = []):
    """Macro which prepares configuration for a custom GraalVM SDK distribution.

    The output of calling this macro should be passed to the `artifacts` attribute of the `graalvm_repository`
    rule. Instead of resolving artifacts using the built-in rule mappings, the user's mapping is used.

    If you need to use a GraalVM SDK or component which is not listed in the default set (for example, Oracle
    GVM EE), you should use this route to define and attach it to your GraalVM repository.

    Args:
        sdk: X.
        components: x.

    Returns:
        Structure which describes available custom artifacts.
    """

    return {
        "sdk": sdk,
        "components": components,
    }


# API structure for calling artifact definition macros.
_graalvm_distribution = struct(
    define = graalvm_distribution_artifacts,
    component = graalvm_component_dist,
    sdk = graalvm_sdk_dist,
    type = _Distribution,
    platform = _Platform,
    known_component = _Component,
)

# Exports.

# buildifier: disable=name-conventions
Component = _Component

# buildifier: disable=name-conventions
Distribution = _Distribution

# buildifier: disable=name-conventions
Platform = _Platform

graalvm = _graalvm_distribution
