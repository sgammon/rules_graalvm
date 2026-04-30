"Minimal cc_toolchain_config that trusts the remote container's system gcc."

load("@rules_cc//cc:cc_toolchain_config_lib.bzl", "tool_path")

def _impl(ctx):
    tool_paths = [
        tool_path(name = "gcc", path = "/usr/bin/gcc"),
        tool_path(name = "ld", path = "/usr/bin/ld"),
        tool_path(name = "ar", path = "/usr/bin/ar"),
        tool_path(name = "cpp", path = "/usr/bin/cpp"),
        tool_path(name = "gcov", path = "/usr/bin/gcov"),
        tool_path(name = "nm", path = "/usr/bin/nm"),
        tool_path(name = "objdump", path = "/usr/bin/objdump"),
        tool_path(name = "strip", path = "/usr/bin/strip"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = ctx.attr.toolchain_identifier,
        host_system_name = "local",
        target_system_name = ctx.attr.target_system_name,
        target_cpu = ctx.attr.target_cpu,
        target_libc = "glibc",
        compiler = "gcc",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
        cxx_builtin_include_directories = ctx.attr.cxx_builtin_include_directories,
    )

system_cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "toolchain_identifier": attr.string(mandatory = True),
        "target_cpu": attr.string(mandatory = True),
        "target_system_name": attr.string(mandatory = True),
        "cxx_builtin_include_directories": attr.string_list(default = []),
    },
    provides = [CcToolchainConfigInfo],
)
