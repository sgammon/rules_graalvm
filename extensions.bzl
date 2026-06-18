"Defines extensions for use with Bzlmod."

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
        graalvm_repository(
            name = selected.name,
            version = selected.version,
            java_version = selected.java_version,
            distribution = selected.distribution,
            toolchain_prefix = selected.toolchain_prefix,
            components = all_components,
            setup_actions = selected.setup_actions,
        )

_graalvm = tag_class(attrs = {
    "name": attr.string(mandatory = True),
    "version": attr.string(mandatory = True),
    "java_version": attr.string(mandatory = True),
    "distribution": attr.string(mandatory = False),
    "toolchain_prefix": attr.string(mandatory = False),
    "components": attr.string_list(mandatory = False),
    "setup_actions": attr.string_list(mandatory = False),
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
_DEFAULT_REACHABILITY_METADATA_URL = "https://github.com/oracle/graalvm-reachability-metadata/releases/download/1.0.3/graalvm-reachability-metadata-1.0.3.zip"
_DEFAULT_REACHABILITY_METADATA_INTEGRITY = "sha256-FTxgQ+y8eUHu7qXlHBtXqoqpBvrt7bha5TomUbXL2bs="

def _reachability_metadata_impl(module_ctx):
    """Implementation of the reachability metadata module extension."""

    url = _DEFAULT_REACHABILITY_METADATA_URL
    integrity = _DEFAULT_REACHABILITY_METADATA_INTEGRITY
    for mod in module_ctx.modules:
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
    return module_ctx.extension_metadata(reproducible = True)

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
