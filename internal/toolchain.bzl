"Defines toolchain registration functions for use in downstream Bazel projects."

_TARGET_JAVA_TOOLCHAIN = ":toolchain"
_TARGET_GVM_TOOLCHAIN = ":toolchain_gvm"

GraalVMToolchainInfo = provider(
    doc = "Information about the GraalVM runtime and compiler.",
    fields = {
        "native_image_bin": "The `native-image` tool for this platform (executable; exec-configured).",
        "gvm_files": "Filegroup of the full SDK installation (exec-configured). Back-compat; prefer `home`.",
        "home": "Target whose files are the SDK root for this platform (a runnable GraalVM home).",
        "jdk_runtime": "The `java_runtime` target for this platform (carries `JavaRuntimeInfo`).",
        "class_roots": "Target whose files are the JDK class roots (`lib/modules`, `lib/jrt-fs.jar`, `lib/ct.sym`).",
        "static_link_libs": "A target providing `CcInfo` (index it `target[CcInfo]`) bundling this platform's SVM + JDK static archives for a static native link, or `None`. Default libc; see `static_link_libs_musl`.",
        "static_link_libs_musl": "Like `static_link_libs` but the musl JDK static libs on Linux (identical full set on macOS/Windows). Use this for a musl link through the toolchain, since the libc flag does not survive the toolchain's exec configuration.",
        "version": "GraalVM version string associated with this toolchain (may be empty).",
    },
)

GraalVMEngineInfo = provider(
    doc = "Information about an installed GraalVM component or engine.",
    fields = [
        "language",
        "launcher",
    ],
)

def _gvm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm = GraalVMToolchainInfo(
            native_image_bin = ctx.attr.native_image_bin,
            gvm_files = ctx.attr.gvm_files,
            home = ctx.attr.home,
            jdk_runtime = ctx.attr.jdk_runtime,
            class_roots = ctx.attr.class_roots,
            static_link_libs = ctx.attr.static_link_libs,
            static_link_libs_musl = ctx.attr.static_link_libs_musl,
            version = ctx.attr.version,
        ),
    )
    return [toolchain_info]

def _gvm_engine_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm = GraalVMEngineInfo(
            component = ctx.attr.component,
            language = ctx.attr.language,
            launcher = ctx.attr.launcher,
            parent_toolchain = ctx.inputs.parent_toolchain,
        ),
    )
    return [toolchain_info]

graalvm_sdk = rule(
    implementation = _gvm_toolchain_impl,
    doc = """
GraalVM SDK definition, which implements the GVM toolchain type for Bazel. This is similar
to a custom Java runtime definition, but covers just the GraalVM-specific tools.

When building a Native Image using the modern rules, Bazel's Toolchains feature is used to
resolve access to the `native-image` binary. Effectively, such a binary is provided by an
instance of this rule.
""",
    attrs = {
        "native_image_bin": attr.label(
            mandatory = True,
            allow_files = True,
            executable = True,
            cfg = "exec",
            doc = """
Native Image tool mapping; typically, the tool is located at `bin/native-image` within a
distribution of GraalVM.

The Native Image tool is used to build native binaries or shared libraries from Java or
polyglot code.
""",
        ),
        "gvm_files": attr.label(
            mandatory = True,
            allow_files = True,
            cfg = "exec",
            doc = """
Filegroup which holds the full set of constituent files which are part of this GraalVM
SDK installation.

These files are transitive tool dependencies for any binary built with Native Image.
""",
        ),
        "home": attr.label(
            mandatory = False,
            allow_files = True,
            doc = """
Target whose files constitute the SDK root for this platform — enough to assemble a runnable
GraalVM home. Resolved per-platform via toolchain resolution, so a cross/RBE build gets the
target platform's home rather than the host's.
""",
        ),
        "jdk_runtime": attr.label(
            mandatory = False,
            doc = """
The `java_runtime` target for this platform, carrying `JavaRuntimeInfo`. Suitable as the
`java_runtime` of a `default_java_toolchain`, resolved for the target platform.
""",
        ),
        "class_roots": attr.label(
            mandatory = False,
            allow_files = True,
            doc = """
Target whose files are the JDK class roots — `lib/modules`, `lib/jrt-fs.jar`, and `lib/ct.sym`
— for this platform.
""",
        ),
        "static_link_libs": attr.label(
            mandatory = False,
            doc = """
A `cc_library` target bundling this platform's SVM and JDK static archives
(`lib/svm/clibraries/<plat>/*.a`, `lib/static/<plat>/[<libc>/]*.a`) for a fully static
native-image link. The provider carries the target; a consumer reads its `CcInfo`
(`target[CcInfo]`) and feeds it into a `cc_*` rule rather than naming individual `.a` paths.
On Linux the libc variant follows `@rules_graalvm//graalvm/config:libc` for direct references;
through the toolchain it resolves to the default (glibc) — see `static_link_libs_musl`.
""",
        ),
        "static_link_libs_musl": attr.label(
            mandatory = False,
            doc = """
The musl-libc variant of `static_link_libs` (on Linux; on macOS/Windows it is the same full
static-lib set, since those platforms have no libc split). A concrete target, so — unlike the
flag-driven `static_link_libs` — it survives the toolchain's exec configuration and can be read
straight from the provider for a musl link.
""",
        ),
        "version": attr.string(
            mandatory = False,
            default = "",
            doc = """
GraalVM version string associated with this toolchain (e.g. `25.0.2`, `23.0.1`, or a custom
tag like `25.1.0-dev+10.1` for EA builds). Optional. When present, rules may use this to
make version-aware decisions — for example, emitting `-H:-UnlockExperimentalVMOptions` only
on versions new enough to accept the gated close flag.
""",
        ),
    },
)

graalvm_engine = rule(
    implementation = _gvm_engine_toolchain_impl,
    doc = """
Defines a GraalVM Engine Toolchain, which maps a GraalVM `component` to language-specific
tools and dependencies. If a `launcher` is supported for this component, it is also
mapped in this target.

GraalVM Engines implement native functionality in GVM; components are provided for things
such as `regex` and `icu4j`. Additionally, language implementations are modeled as
components: those are the tools which are described by a `graalvm_engine` target.
""",
    attrs = {
        "sdk": attr.label(
            mandatory = True,
            doc = """
Main GraalVM toolchain which hosts this engine. This target is used to propagate toolchain
dependencies from the SDK installation, as GraalVM components rely on built-in libraries
which reside in the GRAALVM_HOME path.
""",
        ),
        "jvm": attr.label(
            mandatory = True,
            doc = """
Java toolchain target provided by the GraalVM repository which hosts this engine. This target
is used to resolve Java and the Java Compiler if needed.
""",
        ),
        "component": attr.string(
            mandatory = True,
            doc = """
Name of the component which this GraalVM Engine maps and implements (for example, `js`).
""",
        ),
        "language": attr.string(
            mandatory = False,
            doc = """
Language implemented by this GraalVM Engine. This value is an arbitrary display label which
may be used in mnemonics and other display values during the build. Optional. If no such
value is provided and one is needed at runtime, the `component` name is used instead.
""",
        ),
        "launcher": attr.label(
            mandatory = False,
            allow_files = True,
            executable = True,
            cfg = "target",
            doc = """
If this GraalVM Engine provides a language launcher binary, it is mapped for use in this
attribute. If a language launcher is present, target aliases are created to easily be
able to run it from the command line.
""",
        ),
    },
)

def _repo_target(repo, target):
    return "{}//{}".format(repo, target)

def register_graalvm_toolchains(
        name = "@graalvm",
        toolchain_repo_name_format = "%s_toolchains",
        register_java_toolchain = True,
        register_gvm_toolchain = True):
    """Register GraalVM toolchains for Native Image and installed language components.

    The Java Toolchain registered for use with GraalVM can be used as a runtime JVM if specified in
    Bazel's build flags. The "GVM toolchain" is a toolchain implementation specific to the GraalVM
    SDK, which enables resolution of tools like `native-image` through Bazel's Toolchains feature.

    The GVM toolchain is required to build native image targets. The Java toolchain can be optional
    in some cases: if your Java program does not use GraalVM SDK types, you may be able to build or
    run on top of a regular JVM.

    If you want to use a non-GraalVM JVM for building or running your program, and you *do* use or
    access GraalVM SDK types, you can add the `org.graalvm.sdk:graal-sdk` Maven artifact to your
    build. In this case, make sure to pass `neverlink` if you intend to *build* on a normal JVM but
    *run* on GraalVM, as these types are included within the built-in VM libraries and must align
    with the underlying GraalVM version.

    Toolchains can also be registered manually: the repository `graalvm_toolchains` is the name
    generated for the provided `name` value of `graalvm`. To register toolchains directly:

    In a `WORKSPACE.bazel` or `MODULE.bazel` file, after installation:

        `register_toolchains("@graalvm_toolchains//:jvm")`
        `register_toolchains("@graalvm_toolchains//:sdk")`

    Args:
        name: Name of the main `graalvm` repository (the `graalvm_repository`).
        register_java_toolchain: Whether to register a Java toolchain; defaults to `True`.
        register_gvm_toolchain: Whether to register a GraalVM toolchain; defaults to `True`.
        toolchain_repo_name_format: Format expected for the toolchain config repo name; '%s' is
          replaced with `name`.
    """

    if register_java_toolchain:
        native.register_toolchains(_repo_target(
            toolchain_repo_name_format % name,
            _TARGET_JAVA_TOOLCHAIN,
        ))
    if register_gvm_toolchain:
        native.register_toolchains(_repo_target(
            toolchain_repo_name_format % name,
            _TARGET_GVM_TOOLCHAIN,
        ))
