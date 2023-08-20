"Defines extensions for use with Bzlmod."

load(
    "//graalvm:repositories.bzl",
    "graalvm_repository",
)

def _gvm_impl(mctx):
    """Implementation of the GraalVM module extension."""

    selected = None
    all_components = []
    for mod in mctx.modules:
        # gather gvm toolchain info
        for gvm in mod.tags.graalvm:
            selected = gvm
            if len(gvm.components) > 0:
                all_components += [i for i in gvm.components if not i in all_components]

        # gather components
        for extra_component in mod.tags.component:
            if extra_component.name not in all_components:
                all_components.append(extra_component.name)

    graalvm_repository(
        name = selected.name,
        version = selected.version,
        java_version = selected.java_version,
        distribution = selected.distribution,
        toolchain_prefix = selected.toolchain_prefix,
        components = all_components,
        setup_actions = selected.setup_actions,
        sha256 = selected.sha256,
    )

    _extension_meta = {
        "root_module_direct_dev_deps": [],
        "root_module_direct_deps": [selected.name],
    }

    return mctx.extension_metadata(
        **_extension_meta
    )

_graalvm = tag_class(attrs = {
    "name": attr.string(mandatory = True),
    "version": attr.string(mandatory = True),
    "java_version": attr.string(mandatory = True),
    "distribution": attr.string(mandatory = False),
    "toolchain_prefix": attr.string(mandatory = False),
    "components": attr.string_list(mandatory = False),
    "setup_actions": attr.string_list(mandatory = False),
    "sha256": attr.string(mandatory = False),
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
