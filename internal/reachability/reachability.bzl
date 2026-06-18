"""Per-target GraalVM reachability metadata for `native_image`.

`reachability_metadata(deps = [...])` resolves curated upstream metadata for the Maven
coordinates its deps transitively pull in (discovered from `maven_coordinates` tags) and
exposes it as a resource-only library to add to a `native_image`'s `deps`.

    reachability_metadata(name = "reachability_metadata", deps = [":app_lib"])
    native_image(name = "app", deps = [":app_lib", ":reachability_metadata"])
"""

load("@rules_java//java:defs.bzl", "JavaInfo")

MavenCoordinatesInfo = provider(
    doc = "Transitive group:artifact:version coordinates collected from maven_coordinates tags.",
    fields = {"coordinates": "depset of 'group:artifact:version' strings"},
)

_TAG = "maven_coordinates="

def _coords_aspect_impl(_target, ctx):
    direct = [t[len(_TAG):] for t in getattr(ctx.rule.attr, "tags", []) if t.startswith(_TAG)]
    transitive = [
        dep[MavenCoordinatesInfo].coordinates
        for attr in ("deps", "runtime_deps", "exports")
        for dep in getattr(ctx.rule.attr, attr, [])
        if MavenCoordinatesInfo in dep
    ]
    return [MavenCoordinatesInfo(coordinates = depset(direct, transitive = transitive))]

maven_coordinates_aspect = aspect(
    implementation = _coords_aspect_impl,
    attr_aspects = ["deps", "runtime_deps", "exports"],
    required_providers = [[JavaInfo]],
    provides = [MavenCoordinatesInfo],
    doc = "Collects `maven_coordinates=` tags across deps/runtime_deps/exports.",
)

def _reachability_metadata_impl(ctx):
    discovered = depset(transitive = [
        dep[MavenCoordinatesInfo].coordinates
        for dep in ctx.attr.deps
        if MavenCoordinatesInfo in dep
    ])
    coordinates = {}
    for coordinate in discovered.to_list():
        parts = coordinate.split(":")
        if len(parts) >= 3:
            # maven_coordinates may carry packaging/classifier; version is always last.
            coordinates[parts[0] + ":" + parts[1] + ":" + parts[-1]] = None

    coords_file = ctx.actions.declare_file(ctx.label.name + ".coordinates")
    ctx.actions.write(coords_file, "\n".join(sorted(coordinates)) + "\n")

    out_jar = ctx.actions.declare_file(ctx.label.name + ".jar")
    args = ctx.actions.args()
    args.add("--repository", ctx.file.repository)
    args.add("--coordinates", coords_file)
    args.add("--output", out_jar)
    ctx.actions.run(
        executable = ctx.executable._resolver,
        arguments = [args],
        inputs = [ctx.file.repository, coords_file],
        outputs = [out_jar],
        mnemonic = "ReachabilityMetadata",
        progress_message = "Resolving GraalVM reachability metadata for %{label}",
    )

    return [
        DefaultInfo(files = depset([out_jar])),
        JavaInfo(output_jar = out_jar, compile_jar = out_jar),
    ]

reachability_metadata = rule(
    implementation = _reachability_metadata_impl,
    provides = [JavaInfo],
    doc = "Resolves curated upstream reachability metadata for a target's Maven dependencies.",
    attrs = {
        "deps": attr.label_list(
            aspects = [maven_coordinates_aspect],
            providers = [[JavaInfo]],
            doc = "Targets whose transitive `maven_coordinates` tags are resolved.",
        ),
        "repository": attr.label(
            allow_single_file = True,
            default = "@graalvm_reachability_metadata//file",
            doc = "Pinned `oracle/graalvm-reachability-metadata` snapshot archive.",
        ),
        "_resolver": attr.label(
            default = "//internal/reachability:resolver",
            executable = True,
            cfg = "exec",
        ),
    },
)
