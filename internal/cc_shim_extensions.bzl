"""Bzlmod module extension for the `rules_graalvm_cc_shim` repository.

Kept separate from `cc_shim.bzl` because `module_extension` is not defined on
Bazel versions prior to 6; loading this file from a WORKSPACE-mode consumer on
Bazel 4 or 5 would fail at parse time.
"""

load("//internal:cc_shim.bzl", "cc_shim_repo")

def _cc_shim_extension_impl(_ctx):
    cc_shim_repo(name = "rules_graalvm_cc_shim")

cc_shim_extension = module_extension(
    implementation = _cc_shim_extension_impl,
    doc = "Generates `@rules_graalvm_cc_shim//:cc_shim.bzl` adapted to the running Bazel version.",
)
