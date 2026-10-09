"""Build GraalVM Web Image's JavaScript and WebAssembly outputs as one remote action."""

load("@rules_java//java/common:java_info.bzl", "JavaInfo")

_GVM = "@rules_graalvm//graalvm/toolchain"

def _web_image_impl(ctx):
    sdk = (ctx.attr.graalvm_sdk[platform_common.ToolchainInfo].graalvm if ctx.attr.graalvm_sdk else ctx.toolchains[_GVM].graalvm)
    javascript = ctx.actions.declare_file(ctx.attr.image_name + ".js")
    wasm = ctx.actions.declare_file(ctx.attr.image_name + ".js.wasm")
    classpath = depset(transitive = [dep[JavaInfo].transitive_runtime_jars for dep in ctx.attr.deps])
    builder = depset(ctx.files.builder_jars, transitive = [dep[JavaInfo].transitive_runtime_jars for dep in ctx.attr.builder_deps])
    inputs = list(ctx.files.data)
    args = ctx.actions.args()
    args.add("--tool:svm-wasm")
    args.add("-H:+UnlockExperimentalVMOptions")
    args.add("-H:Class=" + ctx.attr.main_class)
    args.add("-H:Name=" + ctx.attr.image_name)
    args.add("-H:Path=" + javascript.dirname)
    args.add_joined("-cp", classpath, join_with = ":")
    if builder.to_list():
        # A target-owned macro exposes matched builder modules without modifying the SDK.
        macro = ctx.actions.declare_file(ctx.label.name + ".config/macros/web-image-builder/native-image.properties")
        ctx.actions.write(macro, "ImageBuilderModulePath = " + ":".join([f.path for f in builder.to_list()]) + "\n")
        inputs.append(macro)
        args.add("--configurations-path=" + macro.dirname.removesuffix("/macros/web-image-builder"))
        args.add("--macro:web-image-builder")
    for arg in ctx.attr.extra_args:
        args.add(ctx.expand_location(arg, ctx.attr.data))
    tools = [ctx.attr.wasm_as[DefaultInfo].files_to_run]
    ctx.actions.run(
        executable = sdk.native_image_bin.files_to_run,
        inputs = depset(inputs, transitive = [classpath, builder, sdk.gvm_files[DefaultInfo].files]),
        tools = tools,
        outputs = [javascript, wasm],
        arguments = [args],
        env = {"PATH": ctx.executable.wasm_as.dirname + ":/usr/bin:/bin", "LC_CTYPE": "C.UTF-8"},
        mnemonic = "WebImage",
        progress_message = "Web Image %{label}",
        toolchain = _GVM,
    )
    outputs = depset([javascript, wasm])
    return [
        DefaultInfo(files = outputs, runfiles = ctx.runfiles(transitive_files = outputs)),
        OutputGroupInfo(javascript = depset([javascript]), wasm = depset([wasm])),
    ]

web_image = rule(
    implementation = _web_image_impl,
    doc = "Compiles Java libraries to a matched .js/.js.wasm pair. The SDK, assembler, classpath and builder modules are declared inputs; no host installation or network is required by the action.",
    attrs = {
        "deps": attr.label_list(providers = [JavaInfo], mandatory = True),
        "main_class": attr.string(mandatory = True),
        "image_name": attr.string(default = "image"),
        "graalvm_sdk": attr.label(providers = [platform_common.ToolchainInfo], cfg = "exec"),
        "wasm_as": attr.label(executable = True, cfg = "exec", allow_files = True, mandatory = True),
        "builder_jars": attr.label_list(allow_files = [".jar"], cfg = "exec"),
        "builder_deps": attr.label_list(providers = [JavaInfo], cfg = "exec"),
        "data": attr.label_list(allow_files = True),
        "extra_args": attr.string_list(),
    },
    toolchains = [_GVM],
)
