"Defines extensions for use with Bzlmod."

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
        doc = "Optional URL of a GraalVM Maven resource bundle. Only valid with `url` / `urls` / `url_per_platform`. Currently inert; recorded for future wiring.",
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
