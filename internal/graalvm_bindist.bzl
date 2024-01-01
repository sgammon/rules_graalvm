"Describes binary distribution coordinates for GraalVM releases."

load(
    "@bazel_skylib//lib:new_sets.bzl",
    "sets",
)
load(
    "@bazel_skylib//lib:paths.bzl",
    "paths",
)
load(
    "@bazel_skylib//lib:versions.bzl",
    "versions",
)
load(
    "//internal:graalvm_bindist_legacy.bzl",
    _graal_archive_internal_prefixes = "graal_archive_internal_prefixes",
    _graal_native_image_version_configs = "graal_native_image_version_configs",
    _graal_version_configs = "graal_version_configs",
)
load(
    "//internal:graalvm_bindist_map.bzl",
    "ComponentDependencies",
    "VmReleaseVersions",
    "VmReleaseVersionsOracle",
    "resolve_distribution_artifact",
    Component = "DistributionComponent",
    Distribution = "DistributionType",
)
load(
    "//internal:jdk_build_file.bzl",
    _JDK_BUILD_TEMPLATE = "JDK_BUILD_TEMPLATE",
    _JDK_BUILD_TEMPLATE_BAZEL5 = "JDK_BUILD_TEMPLATE_BAZEL5",
)

_graal_v2_archive_internal_prefixes = {
    "macos": "Contents/Home",
    "linux": "",
    "windows": "",
}

_LEGACY_X86_TAG = "amd64"
_NONLEGACY_X86_TAG = "x64"
_LEGACY_DARWIN_TAG = "darwin"
_NONLEGACY_DARWIN_TAG = "macos"

def _get_artifact_info(ctx, dist, platform, version, component = None, strict = True):
    info = resolve_distribution_artifact(dist, platform, version, component, strict)
    if info == None:
        return None
    return struct(component = component, **info)

def _get_platform_legacy(ctx, legacy):
    tag = not legacy and _NONLEGACY_X86_TAG or _LEGACY_X86_TAG

    if ctx.os.name == "linux":
        return ("linux-%s" % tag, "linux", "tar.gz")
    elif ctx.os.name == "mac os x":
        name = not legacy and _NONLEGACY_DARWIN_TAG or _LEGACY_DARWIN_TAG
        return ("%s-%s" % (name, tag), "macos", "tar.gz")
    else:
        fail("Unsupported operating system: " + ctx.os.name)

def _get_platform(ctx, newdist):
    arch_labels = {
        "x86_64": "x64",
        "amd64": "x64",
        "aarch64": "aarch64",
    }

    # fix: before bazel5, the `arch` property did not exist on `repository_os`, so we need
    # to do without it and simply assume `amd64`.
    if not newdist or not versions.is_at_least("5", versions.get()):
        return _get_platform_legacy(ctx, not newdist)
    elif ctx.os.name == "linux":
        return ("linux-%s" % (arch_labels[ctx.os.arch] or ctx.os.arch), "linux", "tar.gz")
    elif ctx.os.name == "mac os x":
        return ("macos-%s" % (arch_labels[ctx.os.arch] or ctx.os.arch), "macos", "tar.gz")
    elif "windows" in ctx.os.name:
        return ("windows-%s" % (arch_labels[ctx.os.arch] or ctx.os.arch), "windows", "zip")
    else:
        fail("Unsupported operating system: " + ctx.os.name)

def _check_version(version, java_version, newdist):
    java_version_numeric = int(java_version)
    gvm_version_major = None

    if version != "latest":
        gvm_version_major = int(version.split(".")[0])

    if newdist:
        # rule 1: java less than 17 is not supported in the new distribution
        if java_version_numeric < 17:
            fail("Modern GraalVM distribution not available for Java version: '%s'" % java_version)

    elif gvm_version_major and gvm_version_major > 22:
        fail("Legacy GraalVM distributions not available at version '%s'" % version)

def _toolchain_config_impl(ctx):
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")\n".format(name = ctx.name))
    ctx.file("BUILD.bazel", ctx.attr.build_file)

def _graal_updater_path(os):
    cmd = paths.join("bin", "gu")
    if "windows" in os:
        cmd = paths.join("bin", "gu.cmd")
    return cmd

def _graal_postinstall_actions(ctx, os):
    cmd = _graal_updater_path(os)
    if ctx.attr.setup_actions and len(ctx.attr.setup_actions) > 0:
        for action in ctx.attr.setup_actions:
            if not action.startswith("gu "):
                fail("GraalVM setup action did not start with 'gu'. Please only run GraalVM updater commands.")

            action_cmd = action.replace("gu ", "").split(" ")
            exec_result = ctx.execute([cmd] + action_cmd, quiet = False)
            if exec_result.return_code != 0:
                fail("Unable to run GraalVM setup action '{cmd}':\n{stdout}\n{stderr}".format(
                    cmd = action,
                    stdout = exec_result.stdout,
                    stderr = exec_result.stderr,
                ))

def _relative_binpath(tail, name, tail_override = None, prefix = "bin"):
    tail_fmt = ""
    if len(tail) > 0 or (tail_override != None and len(tail_override) > 0):
        tail_fmt = ".%s" % (tail_override or tail)
    return paths.join(prefix, "%s%s" % (name, tail_fmt))

def _render_alias(name, actual):
    return """
alias(
    name = "{name}",
    actual = "{actual}",
)
""".format(
        name = name,
        actual = actual,
    )

def _render_bin_alias(name, actual):
    return _render_alias(name, ":bin-%s" % actual)

def _render_bin_target(name, path, deps):
    fmt_deps = "[]"
    if len(deps) > 0:
        fmt_deps = "[\n%s\n]" % "\n".join(["        \"%s\"," % d for d in deps])

    return """
alias(
    name = "bin-{name}",
    actual = ":{path}",
)
filegroup(
    name = "bin-{name}-filegroup",
    srcs = [
        ":{path}",
    ],
    data = {deps},
)
""".format(
        name = name,
        path = path,
        deps = fmt_deps,
    )

def _build_component_graph(components):
    """Resolve dependencies for all components, returning each set first in a list which is eventually flattened.

    If there are no dependencies, the component itself is returned as the only list member."""

    effective_components = []
    unique_components = sets.make(components)
    for component in components:
        deps = ComponentDependencies.get(component, None)
        if deps != None:
            stanza = [i for i in deps if not sets.contains(unique_components, i)]
            for item in stanza:
                sets.insert(unique_components, item)

            # component itself + unique deps, with component last (reverse-topological)
            effective_components += (stanza + [component])
            sets.insert(unique_components, component)
        else:
            effective_components.append(component)
    return effective_components

def _detect_older_gvm_version(version):
    """Checks if a version should be treated as an "older" GraalVM version, before release alignment."""
    return version != None and _graal_version_configs.get(version) != None

def _graal_bindist_repository_impl(ctx):
    """Implements the GraalVM repository rule (`graalvm_repository`)."""

    if ctx.attr.distribution == None or _detect_older_gvm_version(ctx.attr.version):
        platform, os, archive = _get_platform(ctx, False)
        version = ctx.attr.version
        java_version = ctx.attr.java_version
        format_args = {
            "version": version,
            "platform": platform,
            "java_version": java_version,
            "archive": archive,
        }

        _check_version(version, java_version, False)

        # download graal
        config = _graal_version_configs[version]
        sha = config["sha256"][java_version][platform]
        urls = [url.format(**format_args) for url in config["urls"]]
        archive_internal_prefix = _graal_archive_internal_prefixes[platform].format(**format_args)

        ctx.download_and_extract(
            url = urls,
            sha256 = sha,
            stripPrefix = archive_internal_prefix,
        )

        # download native image
        native_image_config = _graal_native_image_version_configs[version]
        native_image_sha = native_image_config["sha256"][java_version][platform]
        native_image_urls = [url.format(**format_args) for url in native_image_config["urls"]]

        ctx.download(
            url = native_image_urls,
            sha256 = native_image_sha,
            output = "native-image-installer.jar",
        )

        cmd = _graal_updater_path(os)
        bin_tail = ""
        shell_tail = ""
        if "windows" in os:
            bin_tail = "exe"
            shell_tail = "cmd"

        _bin_paths = [
            ("gu", cmd, []),
            ("java", _relative_binpath(bin_tail, "java"), []),
            ("javac", _relative_binpath(bin_tail, "javac"), []),
            ("polyglot", _relative_binpath(bin_tail, "polyglot"), []),
            (Component.NATIVE_IMAGE, _relative_binpath(shell_tail, "native-image"), []),
        ]

        exec_result = ctx.execute([cmd, "install", "--local-file", "native-image-installer.jar"], quiet = False)
        if exec_result.return_code != 0:
            fail("Unable to install native image:\n{stdout}\n{stderr}".format(stdout = exec_result.stdout, stderr = exec_result.stderr))

        ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
        ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))
        _graal_postinstall_actions(ctx, os)

    else:
        platform, os, archive = _get_platform(ctx, True)
        version = ctx.attr.version
        distribution = ctx.attr.distribution or Distribution.COMMUNITY
        java_version = ctx.attr.java_version

        # new gvm distribution check
        _check_version(version, java_version, True)
        ctx.report_progress("Downloading GraalVM")

        dist_names = {
            "ce": "ce",
            "community": "ce",
            "oracle": "oracle",
            "gvm": "oracle",
        }
        dist_name = dist_names[distribution]
        if not dist_name:
            fail("Cannot find distribution name for GraalVM: " + ctx.attr.distribution)

        # resolve & download vm
        dist_tag = "{dist}-{version}".format(dist = dist_name, version = ctx.attr.version)
        version = ctx.attr.version
        java_version = ctx.attr.java_version
        format_args = {
            "version": version,
            "platform": platform,
            "java_version": java_version,
            "archive": archive,
        }

        # download graal
        config = _graal_version_configs.get(dist_tag) or resolve_distribution_artifact(
            dist_name,
            platform,
            version,
            strict = False,
        )
        if config == None:
            fail("Unable to locate GraalVM distribution '%s' at version '%s' for platform '%s'" % (
                dist_name,
                version,
                platform,
            ))

        sha = None
        prefix = None
        urls = []
        if "compatible_with" in config:
            # new-style config is completely flat
            sha = config["sha256"]

            # map other properties
            urls = [config["url"]]

            if version in VmReleaseVersions:
                if dist_name == Distribution.ORACLE:
                    prefix_version = VmReleaseVersionsOracle[version]
                    prefix = "graalvm-jdk-%s" % (prefix_version)
                else:
                    prefix_version = VmReleaseVersions[version]
                    prefix = "graalvm-community-openjdk-%s" % (prefix_version)
            else:
                fail("Unable to determine prefix value for archive '%s' at version '%s'" % (
                    dist_tag,
                    version,
                ))

        else:
            # old-style config
            if platform not in config["sha256"]:
                fail("Platform %s not supported at GraalVM version '%s' (distribution '%s'). Available: %s." % (
                    platform,
                    version,
                    distribution,
                    ", ".join(config["sha256"].keys()),
                ))
            if platform in config["sha256"]:
                sha = config["sha256"][platform]
            elif ctx.attr.sha256:
                sha = ctx.attr.sha256

            prefix = config["prefix"][os]
            urls = [url.format(**format_args) for url in config["urls"]]

        archive_internal_prefix = _graal_v2_archive_internal_prefixes[os].format(**format_args)
        effective_prefix = "%s/%s" % (prefix, archive_internal_prefix)
        dist_label = "GraalVM CE"
        if dist_name == "oracle":
            dist_label = "Oracle GraalVM"
        ctx.report_progress("Downloading %s %s" % (dist_label, version))

        ctx.download_and_extract(
            url = urls,
            sha256 = sha or ctx.attr.sha256,
            stripPrefix = effective_prefix,
        )
        bin_tail = ""
        shell_tail = ""
        if "windows" in os:
            bin_tail = "exe"
            shell_tail = "cmd"

        # pluck `gu` because we need to use it
        gu_cmd = _relative_binpath(bin_tail, "gu", shell_tail)

        _bin_paths = [
            ("gu", gu_cmd, []),
            ("java", _relative_binpath(bin_tail, "java"), []),
            ("javac", _relative_binpath(bin_tail, "javac"), []),
            ("polyglot", _relative_binpath(bin_tail, "polyglot"), []),
            (Component.NATIVE_IMAGE, _relative_binpath(shell_tail, "native-image"), []),
        ]

        _conditional_paths = [
            (Component.WASM, "wasm", _relative_binpath(bin_tail, "wasm"), []),
            (Component.PYTHON, "python", _relative_binpath(bin_tail, "python"), []),
            (Component.RUBY, "ruby", _relative_binpath(bin_tail, "ruby"), []),
            (Component.LLVM, "lli", _relative_binpath(bin_tail, "lli"), []),
            (Component.JS, "js", _relative_binpath(bin_tail, "js"), [
                _relative_binpath(bin_tail, paths.join("languages", "js", "bin", "js")),
            ]),
        ]

        all_components = []
        if ctx.attr.components and len(ctx.attr.components) > 0:
            ctx.report_progress("Downloading %s GraalVM components" % len(ctx.attr.components))

            # address dependencies
            resolved_components = _build_component_graph(ctx.attr.components)

            all_url_hash_pairs = [
                (c, _get_artifact_info(ctx, distribution, platform, version, component = c, strict = False))
                for c in resolved_components
            ]
            downloads = []
            manual = []
            for (component, info) in all_url_hash_pairs:
                if info == None:
                    manual.append(component)
                    continue

                # assemble file name
                file = info.url.split("/")[-1]
                downloads.append((info, file))

                # download component
                ctx.download(
                    url = [info.url],
                    sha256 = info.sha256,
                    output = file,
                )

            for (info, file) in downloads:
                ctx.report_progress("Installing GraalVM %s component" % info.component)

                exec_result = ctx.execute([gu_cmd, "install", "--local-file", file], quiet = True)
                if exec_result.return_code != 0:
                    fail("Unable to install component '{component}':\n{stdout}\n{stderr}".format(
                        component = info.component,
                        stdout = exec_result.stdout,
                        stderr = exec_result.stderr,
                    ))

            if len(manual) > 0:
                for manual_component in manual:
                    ctx.report_progress("Installing GraalVM %s component via gu" % manual_component)
                    exec_result = ctx.execute([gu_cmd, "install", manual_component], quiet = True)
                    if exec_result.return_code != 0:
                        fail("Unable to install component '{component}':\n{stdout}\n{stderr}".format(
                            info.component,
                            stdout = exec_result.stdout,
                            stderr = exec_result.stderr,
                        ))

            all_components.extend(resolved_components)
            _bin_paths.extend(
                [(n, v, d) for (k, n, v, d) in _conditional_paths if k in all_components],
            )

    if ctx.name in ["native-image", "toolchain_native_image", "toolchain_gvm", "entry", "bootstrap_runtime_toolchain", "toolchain", "jdk", "jre", "jre-lib"]:
        fail("Cannot use name '%s' for repository name: It will clash with other targets" % ctx.name)

    ctx_alias = ctx.name
    if ctx.name == "graalvm":
        ctx_alias = "gvm_entry"

    ## render bin targets and aliases
    rendered_bin_targets = "\n".join([_render_bin_target(n, p, d) for (n, p, d) in _bin_paths])
    rendered_bin_aliases = "\n".join([_render_bin_alias(n, n) for (n, p, d) in _bin_paths])

    _bin_paths_map = {}
    _bin_paths_map.update([(k, v) for (k, v, d) in _bin_paths])
    rendered_bin_paths = struct(**_bin_paths_map)

    bootstrap_toolchain_alias = """
alias(
    name = "bootstrap_runtime_toolchain",
    actual = "@{repo}//:bootstrap_runtime_toolchain",
    visibility = ["//visibility:public"],
)
""".format(
        repo = ctx.attr.toolchain_config,
    )

    # if we're running on Bazel before 7, we need to omit the bootstrap toolchain, because
    # it doesn't yet exist in Bazel's internals.
    if not versions.is_at_least("7", versions.get()):
        bootstrap_toolchain_alias = ""

    # bazel 6+ has support for the `version` attribute on the `java_runtime` rule. earlier
    # versions do not, so we omit it.
    toolchain_template = _JDK_BUILD_TEMPLATE
    if not versions.is_at_least("6", versions.get()):
        toolchain_template = _JDK_BUILD_TEMPLATE_BAZEL5

    toolchain_aliases_template = """
# Entry Aliases
alias(
    name = "entry",
    actual = ":{bin_java_path}",
)
alias(
    name = "graalvm",
    actual = ":entry",
)
alias(
    name = "{name}",
    actual = ":entry",
)

# Toolchains
alias(
    name = "jvm",
    actual = "toolchain",
)
alias(
    name = "toolchain",
    actual = "@{repo}//:toolchain",
    visibility = ["//visibility:public"],
)
{bootstrap_toolchain_alias}

load(
    "@rules_graalvm//internal:toolchain.bzl",
    "graalvm_sdk",
    "graalvm_engine",
)
graalvm_sdk(
    name = "gvm",
    native_image_bin = ":native-image",
    gvm_files = ":files",
)
alias(
    name = "sdk",
    actual = "toolchain_gvm",
)
alias(
    name = "toolchain_gvm",
    actual = "@{repo}//:toolchain_gvm",
)

# Tool Aliases
{rendered_bin_aliases}
        """.format(
        name = ctx_alias,
        repo = ctx.attr.toolchain_config,
        bootstrap_toolchain_alias = bootstrap_toolchain_alias,
        rendered_bin_aliases = rendered_bin_aliases,
        bin_java_path = rendered_bin_paths.java,
        gvm_toolchain_tags_exec = "",
        gvm_toolchain_tags_target = "",
    )

    ctx.file(
        "BUILD.bazel",
        """
exports_files(glob(["**/*"]))

filegroup(
    name = "files",
    srcs = glob(["**/*"]),
)

# Tool Targets
{rendered_bin_targets}

# Toolchain
{toolchain}

# Aliases
{aliases}
""".format(
            toolchain = toolchain_template.format(RUNTIME_VERSION = java_version),
            aliases = ctx.attr.enable_toolchain and toolchain_aliases_template or "",
            rendered_bin_targets = rendered_bin_targets,
        ),
    )

    ctx.file("WORKSPACE.bazel", """
workspace(name = \"{name}\")
""".format(name = ctx.name))

    _graal_postinstall_actions(ctx, os)
    # Done.

_graalvm_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(
            mandatory = True,
            doc = """
GraalVM engine version, like `23.0.1`. Note that this version aligns with
OpenJDK release versions only for newer releases; in some cases, the
`java_version` and `version` differ, and in others they align.

This version is required in order to properly resolve artifacts for a given
GraalVM engine version.
            """,
        ),
        "java_version": attr.string(
            mandatory = True,
            doc = """
Specific (`17.0.8`) or major (`17`) Java version provided by the desired
GraalVM SDK release. This value is mandatory so that components and SDK
artifacts can properly be resolved; GraalVM releases each provide support
for multiple Java versions.

Early versions of GraalVM provide Java 8 and 11. This window slides as the
GraalVM release approaches current; at the time of this writing, Java 17
and Java 20 are provided, with Java 17 and Java 21 being the next release.
            """,
        ),
        "distribution": attr.string(
            mandatory = False,
            doc = """
Specifies the type of distribution to download, install, and use. GraalVM
is distributed as Community Edition (also known as "CE"), and Oracle GraalVM,
which carries a different license and offers commercial support.

For these reasons, the default distribution is Community, and you can opt-in
to using the Oracle GVM distribution with the value `oracle`.

Before the Java 17/20 release (known internally as `23.0.1`), Oracle GraalVM
was known as GraalVM Enterprise Edition, or "GraalVM EE." To use an EE
distribution of GraalVM, use the `artifacts` attribute with a custom artifact
coordinate definition.
            """,
        ),
        "toolchain_prefix": attr.string(
            mandatory = False,
            doc = """
String prefix to use for the Java toolchain; if no value is provided, the
default value is `graalvm`, resulting in `graalvm_<java_major_version>` as the
name of the registered Java toolchain.

For example, if you install a GraalVM SDK with `java_version` set to `20`, the
toolchain will be named `graalvm_20`, and you can use it in a `.bazelrc` file
or on the command line with:

```
# run with your graalvm
build --java_runtime_version=graalvm_20

# build with your graalvm
build --tool_java_runtime_version=graalvm_20
```

Both flags are optional, and each are required for the related use case.
            """,
        ),
        "components": attr.string_list(
            mandatory = False,
            doc = """
Specifies the set of component names which should be installed or resolved for
this GraalVM SDK installation.

GraalVM "components" are language or engine modules, typically implemented via
the Truffle API. For example, GraalJs, GraalPy, and TruffleRuby are all made
available via this mechanism.

The GraalVM Rules know about component dependencies for components which ship
as part of GraalVM. For example, specifying `js` will install requisite component
dependencies (`regex` and `icu4j`).

If you want to define your own components or use third-party components which
are not shipped with GraalVM, see the `artifacts` attribute.
            """,
        ),
        "setup_actions": attr.string_list(
            mandatory = False,
            doc = """
Set of shell actions to run with the Graal Updater (`gu`) tool after SDK and
component installation is complete.

Some components need after-installation actions, like Espresso, which requires the
user to run `gu rebuild-images`. These commands can be defined and performed using
this attribute.
""",
        ),
        "enable_toolchain": attr.bool(
            mandatory = False,
            doc = """
Whether to define Java and GraalVM toolchain targets. These toolchain targets are
used by the modern version of the Native Image rules, and optionally by Baazel as
a Java Toolchain.
""",
        ),
        "toolchain_config": attr.string(
            mandatory = True,
            doc = """
Name to use for the toolchain configuration repository which is installed and set
up with GraalVM and Java toolchains. This repository is used as the actual host for
these toolchain configurations, with aliases from the main GraalVM repository.

Normally this name is generated and the user does not have to provide it.
""",
        ),
        "sha256": attr.string(
            mandatory = False,
            doc = """
SHA-256 fingerprint for a custom toolchain. Optional. If unspecified, use of custom
toolchains may yield hermeticity warnings.
"""
        )
    },
    implementation = _graal_bindist_repository_impl,
)

_toolchain_config = repository_rule(
    local = True,
    implementation = _toolchain_config_impl,
    attrs = {
        "build_file": attr.string(),
    },
)

def graalvm_repository(
        name,
        java_version,
        version = "latest",
        distribution = None,
        toolchain = True,
        toolchain_prefix = "graalvm",
        target_compatible_with = [],
        components = [],
        setup_actions = [],
        register_all = False,
        toolchain_repo_name = None,
        **kwargs):
    """Declare a GraalVM distribution repository, and optionally a Java toolchain to match.

    To register and use the GraalVM distribution as a toolchain, follow the Toolchains guide in the docs
    (`docs/toolchain.md`).

    If `distribution` is set to `oracle`, an Oracle GraalVM installation is downloaded. This variant of
    GraalVM may be subject to different license obligations; please consult Oracle's docs for more info.

    Oracle GraalVM distributions are downloaded directly from Oracle, which provides a `latest` download
    endpoint. Set `version` to `latest` (the default value) to download the latest available version of
    GraalVM matching the provided `java_version`.

    When installing the `latest` version of GraalVM, it is probably ideal to provide your own `sha256`.
    In this case, the `rules_graalvm` package does not provide an SHA256 hash otherwise.

    Args:
        name: Name of the VM repository.
        java_version: Java version to use/declare.
        version: Version of the GraalVM release.
        distribution: Which GVM distribution to download - `ce`, `community`, or `oracle`.
        toolchain: Whether to create a Java runtime toolchain from this GVM installation.
        toolchain_prefix: Name prefix to use for the Java toolchain; defaults to `graalvm`.
        target_compatible_with: Compatibility tags to apply.
        components: Components to install in the target GVM installation.
        setup_actions: GraalVM Updater commands that should be run; pass complete command strings that start with "gu".
        register_all: Register all GraalVM repositories and use `target_compatible_with` (experimental).
        toolchain_repo_name: Explicit name to give to the toolchain config repo; if `None` (default), a sensible
          name is used in the format `<name>_toolchains`.
        **kwargs: Passed to the underlying bindist repository rule.
    """

    toolchain_repo_name = toolchain_repo_name or (name + "_toolchains")

    # if we're running on Bazel before 7, we need to omit the bootstrap toolchain, because
    # it doesn't yet exist in Bazel's internals.
    bootstrap_runtime_toolchain = ""
    if versions.is_at_least("7", versions.get()):
        bootstrap_runtime_toolchain = """
toolchain(
    name = "bootstrap_runtime_toolchain",
    # These constraints are not required for correctness, but prevent fetches of remote JDK for
    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in
    # the same configuration, this constraint will not result in toolchain resolution failures.
    exec_compatible_with = {target_compatible_with},
    target_settings = [":prefix_version_setting"],
    toolchain_type = "@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type",
    toolchain = "{toolchain}",
    visibility = ["//visibility:public"],
)
""".format(
            prefix = toolchain_prefix or "graalvm",
            version = java_version,
            target_compatible_with = target_compatible_with,
            toolchain = "@{repo}//:jdk".format(repo = name),
        )

    toolchain_config_build_file = """
alias(
    name = "toolchain_gvm",
    actual = "gvm",
    visibility = ["//visibility:public"],
)
toolchain(
    name = "gvm",
    exec_compatible_with = [
        {gvm_toolchain_tags_exec}
    ],
    target_compatible_with = [
        {gvm_toolchain_tags_target}
    ],
    toolchain = "@{name}//:gvm",
    toolchain_type = "@rules_graalvm//graalvm/toolchain",
    visibility = ["//visibility:public"],
)
""".format(
        name = name,
        gvm_toolchain_tags_exec = "",
        gvm_toolchain_tags_target = "",
    )

    if toolchain:
        toolchain_config_build_file += """
config_setting(
    name = "prefix_version_setting",
    values = {{"java_runtime_version": "{prefix}_{version}"}},
    visibility = ["//visibility:private"],
)
toolchain(
    name = "toolchain",
    target_compatible_with = {target_compatible_with},
    target_settings = [":prefix_version_setting"],
    toolchain_type = "@bazel_tools//tools/jdk:runtime_toolchain_type",
    toolchain = "{toolchain}",
    visibility = ["//visibility:public"],
)
{bootstrap_runtime_toolchain}
""".format(
            name = name,
            prefix = toolchain_prefix or "graalvm",
            version = java_version,
            target_compatible_with = target_compatible_with,
            toolchain = "@{repo}//:jdk".format(repo = name),
            bootstrap_runtime_toolchain = bootstrap_runtime_toolchain,
            gvm_toolchain_tags_exec = "",
            gvm_toolchain_tags_target = "",
        )

    _toolchain_config(
        name = toolchain_repo_name,
        build_file = toolchain_config_build_file,
    )

    if not register_all:
        # register a specific GraalVM version at the host OS/arch pair
        _graalvm_bindist_repository(
            name = name,
            version = version,
            java_version = java_version,
            distribution = distribution,
            components = components,
            setup_actions = setup_actions,
            enable_toolchain = toolchain,
            toolchain_config = toolchain_repo_name,
            **kwargs
        )
    else:
        fail("GraalVM rules `register_all` is not supported yet.")
