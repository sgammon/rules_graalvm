"""Probe rule that records which GraalVM SDK files the *resolved* toolchain selects.

This is the coverage for per-target SDK file selection: under a cross / RBE platform the
recorded paths must originate from that platform's SDK repo (e.g. `graalvm_linux_x64`), not
from the host's `graalvm` repo. `ctx.actions.write` runs in-process, so building the probe
needs no executor for the selected platform — only that platform's SDK repo is fetched so its
filegroups can be analyzed.
"""

load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

def _sdk_probe_impl(ctx):
    tc = ctx.toolchains["@rules_graalvm//graalvm/toolchain"].graalvm

    paths = [f.path for f in tc.class_roots.files.to_list()]
    if tc.static_link_libs:
        for linker_input in tc.static_link_libs[CcInfo].linking_context.linker_inputs.to_list():
            for lib in linker_input.libraries:
                archive = lib.static_library or lib.pic_static_library
                if archive:
                    paths.append(archive.path)

    out = ctx.actions.declare_file(ctx.label.name + ".paths.txt")
    ctx.actions.write(out, "".join([p + "\n" for p in sorted(paths)]))
    return [DefaultInfo(files = depset([out]))]

sdk_probe = rule(
    implementation = _sdk_probe_impl,
    doc = "Writes the file paths surfaced by the resolved GraalVM toolchain (class roots + static link libs).",
    toolchains = ["@rules_graalvm//graalvm/toolchain"],
)
