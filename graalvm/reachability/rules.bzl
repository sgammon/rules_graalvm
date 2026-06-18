"Rules for resolving curated GraalVM reachability metadata, intended for use by rule users."

load(
    "//internal/reachability:reachability.bzl",
    _MavenCoordinatesInfo = "MavenCoordinatesInfo",
    _maven_coordinates_aspect = "maven_coordinates_aspect",
    _reachability_metadata = "reachability_metadata",
)

# Exports.
reachability_metadata = _reachability_metadata
maven_coordinates_aspect = _maven_coordinates_aspect

# buildifier: disable=name-conventions
MavenCoordinatesInfo = _MavenCoordinatesInfo
