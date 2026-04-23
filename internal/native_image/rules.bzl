"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "@build_bazel_apple_support//lib:apple_support.bzl",
    "apple_support",
)
load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")
load(
    "//internal/native_image:action_utils.bzl",
    _wrap_actions_for_graal = "wrap_actions_for_graal",
)
load(
    "//internal/native_image:common.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _DEBUG_CONDITION = "DEBUG_CONDITION",
    _DEFAULT_GVM_REPO = "DEFAULT_GVM_REPO",
    _GVM_TOOLCHAIN_TYPE = "GVM_TOOLCHAIN_TYPE",
    _NATIVE_IMAGE_ATTRS = "NATIVE_IMAGE_ATTRS",
    _OPTIMIZATION_MODE_CONDITION = "OPTIMIZATION_MODE_CONDITION",
    _RULES_REPO = "RULES_REPO",
    _prepare_native_image_rule_context = "prepare_native_image_rule_context",
)
load(
    "//internal/native_image:layer_builder.bzl",
    _collect_parent_layer_infos = "collect_parent_layer_infos",
    _merge_propagated_args = "merge_propagated_args",
)
load(
    "//internal/native_image:toolchain.bzl",
    _resolve_cc_toolchain = "resolve_cc_toolchain",
)

_BIN_POSTFIX_DYLIB = ".dylib"
_BIN_POSTFIX_EXE = ".exe"
_BIN_POSTFIX_DLL = ".dll"
_BIN_POSTFIX_SO = ".so"

# When True, parent-layer list-attrs (initialize_at_*, native_features, extra_args) are
# propagated additively into the child image build. Classpath propagation and `--layer-use` are
# independent and always on — SVM's compatibility check requires them.
_LAYER_AUTO_PROPAGATE = True

def _build_action_message(ctx):
    _mode_label = {
        "b": "fastbuild",
        "s": "size",
        "1": "opt",
        "2": "opt",
        "default": ctx.attr.debug and "debug" or "default",
    }
    return (_mode_label[ctx.attr.optimization_mode or "default"])

def _graal_binary_implementation(ctx):
    graal_attr = ctx.executable.native_image_tool

    # Collect parent layers (0 or 1 today, per macro validation).
    parent_infos = _collect_parent_layer_infos(ctx)
    propagated = _merge_propagated_args(parent_infos, _LAYER_AUTO_PROPAGATE)

    # Classpath includes parent-layer jars first (if any) so SVM sees a superset of the parent's
    # classpath, as required by the layered-image compatibility check.
    local_cp = depset(transitive = [
        dep[cc_shim.JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
    ])
    classpath_depset = depset(transitive = [
        p.classpath_depset
        for p in parent_infos
    ] + [local_cp])

    direct_inputs = []
    transitive_inputs = [classpath_depset]

    # Parent `.nil` archives flow into the action inputs via their `transitive_layer_files`
    # depset (which includes the parent plus its own ancestors).
    for parent in parent_infos:
        transitive_inputs.append(parent.transitive_layer_files)

    # resolve via toolchains
    gvm_toolchain = ctx.toolchains[_GVM_TOOLCHAIN_TYPE].graalvm

    # if a native-image tool is explicitly provided, it should override the one
    # provided by the toolchain, but not the rest of the files it provides
    graal = graal_attr or gvm_toolchain.native_image_bin.files_to_run

    # add toolchain files to transitive inputs
    transitive_inputs.append(gvm_toolchain.gvm_files[DefaultInfo].files)

    if not graal:
        # cannot resolve via either toolchains or attributes.
        fail("""
            No `native-image` tool found. Please either define a `native_image_tool` in your target,
            or install a GraalVM `native-image` toolchain.
        """)

    is_linux = ctx.target_platform_has_constraint(
        ctx.attr._linux_constraint[platform_common.ConstraintValueInfo],
    )
    is_macos = ctx.target_platform_has_constraint(
        ctx.attr._macos_constraint[platform_common.ConstraintValueInfo],
    )
    is_windows = ctx.target_platform_has_constraint(
        ctx.attr._windows_constraint[platform_common.ConstraintValueInfo],
    )

    # resolve the native toolchain
    native_toolchain = _resolve_cc_toolchain(
        ctx,
        transitive_inputs,
        is_windows = is_windows,
    )

    # shared libraries on macos are produced with an extension of `dylib`.
    bin_postfix = None
    if is_macos and ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_DYLIB
    elif is_windows and not ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_EXE
    elif is_windows:
        bin_postfix = _BIN_POSTFIX_DLL
    elif (not is_windows and not is_macos) and ctx.attr.shared_library:
        bin_postfix = _BIN_POSTFIX_SO

    args = ctx.actions.args().use_param_file("@%s", use_always = False)
    binary = _prepare_native_image_rule_context(
        ctx,
        args,
        classpath_depset,
        direct_inputs,
        native_toolchain.c_compiler_path,
        gvm_toolchain,
        bin_postfix = bin_postfix,
        propagated = propagated,
    )

    # Emit `--layer-use=<ancestor.nil>` for every ancestor, oldest-first.
    for parent in parent_infos:
        for ancestor in parent.transitive_layer_files.to_list():
            args.add(ancestor.path, format = "--layer-use=%s")

    if ctx.files.data:
        direct_inputs.extend(ctx.files.data)

    env = native_toolchain.env

    # The native image will use the same native encoding (as determined by "sun.jnu.encoding")
    # as the build environment, so we need to force a UTF-8 locale. On other platforms, the
    # encoding is always UTF-8 (on macOS since JEP 400) or determined by the active code page
    # on Windows.
    # TODO: Match on the exec platform instead once Graal supports cross-compilation.
    if is_linux:
        env["LC_CTYPE"] = "C.UTF-8"

    # assemble final inputs
    inputs = depset(
        direct_inputs,
        transitive = transitive_inputs,
    )
    run_params = {
        "outputs": [binary],
        "executable": graal,
        "inputs": inputs,
        "mnemonic": "NativeImage",
        "env": env,
        "execution_requirements": {k: "" for k in native_toolchain.execution_requirements},
        "progress_message": "Native Image __target__ (__mode__) %{label}"
            .replace("__mode__", _build_action_message(ctx))
            .replace("__target__", ctx.attr.shared_library and "[shared lib]" or "[executable]"),
        "toolchain": Label(_GVM_TOOLCHAIN_TYPE),
    }

    graal_actions = _wrap_actions_for_graal(ctx.actions)
    if is_macos:
        xcode_args = ctx.actions.args()

        # Bazel passes DEVELOPER_DIR and SDKROOT to every locally executed action that sets the
        # environment variables passed by apple_support.run. However, Graal sanitizes the
        # environment and removes these variables if set directly. We need to convert them into
        # -E options and rely on apple_support's argument replacement to pass them through to the
        # compiler invoked by Graal.
        # https://github.com/oracle/graal/blob/77a7f6a691024d22367ae33be4da0c15ceb6a246/substratevm/src/com.oracle.svm.driver/src/com/oracle/svm/driver/NativeImage.java#L1801-L1808
        xcode_args.add(apple_support.path_placeholders.xcode(), format = "-EDEVELOPER_DIR=%s")
        xcode_args.add(apple_support.path_placeholders.sdkroot(), format = "-ESDKROOT=%s")
        xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig]

        # native-image reads the MACOSX_DEPLOYMENT_TARGET env var to determine target macos version
        run_params["env"]["MACOSX_DEPLOYMENT_TARGET"] = str(xcode_config.minimum_os_for_platform_type(apple_common.platform_type.macos))
        apple_support.run(
            actions = graal_actions,
            apple_fragment = ctx.fragments.apple,
            xcode_config = xcode_config,
            xcode_path_resolve_level = apple_support.xcode_path_resolve_level.args,
            arguments = [args, xcode_args],
            **run_params
        )

    else:
        # run our proxied env shim on all other platforms.
        graal_actions.run(
            arguments = [args],
            **run_params
        )

    return [DefaultInfo(
        executable = binary,
        files = depset([binary]),
        runfiles = ctx.runfiles(
            collect_data = True,
            collect_default = True,
            files = [],
        ),
    )]

# Exports.
RULES_REPO = _RULES_REPO
DEFAULT_GVM_REPO = _DEFAULT_GVM_REPO
BAZEL_CURRENT_CPP_TOOLCHAIN = _BAZEL_CURRENT_CPP_TOOLCHAIN
BAZEL_CPP_TOOLCHAIN_TYPE = _BAZEL_CPP_TOOLCHAIN_TYPE
NATIVE_IMAGE_ATTRS = _NATIVE_IMAGE_ATTRS
GVM_TOOLCHAIN_TYPE = _GVM_TOOLCHAIN_TYPE
DEBUG_CONDITION = _DEBUG_CONDITION
OPTIMIZATION_MODE_CONDITION = _OPTIMIZATION_MODE_CONDITION
graal_binary_implementation = _graal_binary_implementation
LAYER_AUTO_PROPAGATE = _LAYER_AUTO_PROPAGATE
