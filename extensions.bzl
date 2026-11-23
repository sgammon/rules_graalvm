"Defines extensions for use with Bzlmod."

load("@bazel_features//:features.bzl", "bazel_features")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load(
    "//graalvm:repositories.bzl",
    "graalvm_repository",
)

def _gvm_impl(mctx):
    """Implementation of the GraalVM module extension."""

    all_tags = []
    all_components = []
    for mod in mctx.modules:
        # gather gvm toolchain info
        for gvm in mod.tags.graalvm:
            if not mod.is_root:
                fail("graalvm tag is only allowed in the root module, use component tag instead")
            all_tags.append(gvm)
            if len(gvm.components) > 0:
                all_components += [i for i in gvm.components if not i in all_components]

        # gather components
        for extra_component in mod.tags.component:
            if extra_component.name not in all_components:
                all_components.append(extra_component.name)

    for selected in all_tags:
        kwargs = {
            "name": selected.name,
            "version": selected.version,
            "java_version": selected.java_version,
            "distribution": selected.distribution,
            "toolchain_prefix": selected.toolchain_prefix,
            "components": all_components,
            "setup_actions": selected.setup_actions,
            "platforms": list(selected.platforms),
        }

        # Forward the custom-URL attrs only when set. They are mutually exclusive with map-based
        # resolution; passing empty strings through would trigger the custom-URL branch in the
        # underlying rule.
        if selected.url:
            kwargs["url"] = selected.url
        if selected.urls:
            kwargs["urls"] = list(selected.urls)
        if selected.strip_prefix:
            kwargs["strip_prefix"] = selected.strip_prefix
        if selected.sha256:
            kwargs["sha256"] = selected.sha256
        if selected.url_per_platform:
            kwargs["url_per_platform"] = dict(selected.url_per_platform)
        if selected.sha256_per_platform:
            kwargs["sha256_per_platform"] = dict(selected.sha256_per_platform)
        if selected.strip_prefix_per_platform:
            kwargs["strip_prefix_per_platform"] = dict(selected.strip_prefix_per_platform)
        if selected.maven_resource_bundle:
            kwargs["maven_resource_bundle"] = selected.maven_resource_bundle
        if selected.maven_resource_bundle_sha256:
            kwargs["maven_resource_bundle_sha256"] = selected.maven_resource_bundle_sha256

        graalvm_repository(**kwargs)

_graalvm = tag_class(attrs = {
    "name": attr.string(mandatory = True),
    "version": attr.string(mandatory = True),
    "java_version": attr.string(mandatory = True),
    "distribution": attr.string(mandatory = False),
    "toolchain_prefix": attr.string(mandatory = False),
    "components": attr.string_list(mandatory = False),
    "setup_actions": attr.string_list(mandatory = False),
    "platforms": attr.string_list(
        mandatory = False,
        doc = """Which platforms to generate and register GraalVM toolchains for.

Unset (the default), `[]`, or `["all"]` registers toolchains for every supported platform
(`linux-x64`, `linux-aarch64`, `macos-x64`, `macos-aarch64`, `windows-x64`) so that both
host builds and remote build execution (RBE) work out of the box. Bazel fetches only the
SDK for the platform a toolchain is actually selected on, so registering all platforms is
free for host-only builds.

Use `["host"]` to generate only the host-platform toolchain, or an explicit subset such as
`["linux-x64", "linux-aarch64"]` for a narrow / pure-RBE setup. The `"host"` and `"all"`
sentinels may not be combined with explicit platform keys.""",
    ),
    "url": attr.string(
        mandatory = False,
        doc = "Custom download URL for an Early Adopter / nightly / dev build. Bypasses the bindist map.",
    ),
    "urls": attr.string_list(
        mandatory = False,
        doc = "Mirror URLs; alternate form of `url`.",
    ),
    "strip_prefix": attr.string(
        mandatory = False,
        doc = "Archive-internal prefix to strip. Required when `url` / `urls` is set.",
    ),
    "sha256": attr.string(
        mandatory = False,
        doc = "SHA-256 fingerprint of the archive. Recommended when `url` / `urls` is set.",
    ),
    "url_per_platform": attr.string_dict(
        mandatory = False,
        doc = "Per-host-platform URLs keyed by platform tag (`linux-x64`, `linux-aarch64`, `macos-x64`, `macos-aarch64`, `windows-x64`). Use for cross-platform declarations.",
    ),
    "sha256_per_platform": attr.string_dict(
        mandatory = False,
        doc = "Per-platform SHA-256 hashes, same keys as `url_per_platform`.",
    ),
    "strip_prefix_per_platform": attr.string_dict(
        mandatory = False,
        doc = "Per-platform strip prefixes, same keys as `url_per_platform`.",
    ),
    "maven_resource_bundle": attr.string(
        mandatory = False,
        doc = "Optional URL of a GraalVM Maven resource bundle. Only valid with `url` / `urls` / `url_per_platform`. Downloaded + extracted under `maven-bundle/` and exposed as the `maven_resource_bundle` filegroup.",
    ),
    "maven_resource_bundle_sha256": attr.string(
        mandatory = False,
        doc = "SHA-256 of the `maven_resource_bundle` archive. Only valid with `maven_resource_bundle`; makes the bundle download hermetic + hash-locked.",
    ),
})

_component = tag_class(attrs = {
    "name": attr.string(mandatory = True),
})

graalvm = module_extension(
    implementation = _gvm_impl,
    tag_classes = {
        "graalvm": _graalvm,
        "component": _component,
    },
)

##
## Reachability metadata
##

# Default pinned snapshot of `oracle/graalvm-reachability-metadata`. Release zips hold the metadata
# tree (the group directories) at the archive root. Override via the `repository` tag in the root
# module. Bump when a release that tests newer dependency versions ships.
_DEFAULT_REACHABILITY_METADATA_URL = "https://github.com/oracle/graalvm-reachability-metadata/releases/download/1.0.23/graalvm-reachability-metadata-1.0.23.zip"
_DEFAULT_REACHABILITY_METADATA_INTEGRITY = "sha256-Xm4sEzQiTKFYDR0fZ15gCmHdMDXRmcJfhTWU1uww+ws="

def _reachability_metadata_impl(module_ctx):
    """Implementation of the reachability metadata module extension."""

    url = _DEFAULT_REACHABILITY_METADATA_URL
    integrity = _DEFAULT_REACHABILITY_METADATA_INTEGRITY

    # only the root module may override the snapshot; a library module overriding it would
    # silently change the metadata every other module in the build sees.
    for mod in module_ctx.modules:
        if not mod.is_root:
            continue
        for tag in mod.tags.repository:
            if tag.url:
                url = tag.url
            if tag.integrity:
                integrity = tag.integrity

    http_file(
        name = "graalvm_reachability_metadata",
        url = url,
        integrity = integrity,
        downloaded_file_path = "repository.zip",
    )

    # `reproducible` needs Bazel 7.1+; this module supports 7.0.
    if bazel_features.external_deps.extension_metadata_has_reproducible:
        return module_ctx.extension_metadata(reproducible = True)
    return None

_reachability_repository = tag_class(attrs = {
    "url": attr.string(mandatory = False, doc = "Archive URL of the metadata snapshot; defaults to the pinned release."),
    "integrity": attr.string(mandatory = False, doc = "Subresource integrity of the archive; defaults to the pinned release."),
})

reachability_metadata = module_extension(
    implementation = _reachability_metadata_impl,
    tag_classes = {
        "repository": _reachability_repository,
    },
    doc = "Fetches a pinned snapshot of `oracle/graalvm-reachability-metadata` as `@graalvm_reachability_metadata//file`.",
)
