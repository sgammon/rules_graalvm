# Native Image shared-library `CcInfo` round-trip — design

**Date:** 2026-04-25
**Branch:** `feat/layers`
**Scope:** Producer side only. Consumer-side polish (`cc_deps_dynamic` transitive walk, versioned SONAME handling) is deferred to a follow-up spec.

## Goal

Make `native_image(shared_library = True)` a first-class `CcInfo` producer so downstream `cc_binary`, `cc_library`, `rust_binary`, and any other Bazel rule that consumes `CcInfo` can `deps = [my_native_image]` directly — no manual `cc_import` glue, no manual `#include` path setup, no manual runfiles staging.

## Non-goals

- Layer-mode `CcInfo` (layers are consumed by Native Image's layered build mechanism, not by `cc_*`).
- Static-archive output (`.a`); Native Image has no stable mode for emitting one.
- Header-only / interface-library mode for the producer.
- Consumer-side enhancements: transitive `CcInfo` walking on `cc_deps` / `cc_deps_dynamic`, versioned-SONAME handling. Tracked separately.

## User-facing API

Strictly additive. Existing `shared_library = True` semantics are unchanged; new behavior triggers only when the flag is set.

```python
# Producer — exposes CcInfo automatically when shared_library = True
native_image(
    name = "myapi",
    shared_library = True,
    deps = ["//java/src/main:lib"],          # contains @CEntryPoint declarations
    extra_headers = ["custom_export.h"],     # optional; default []
)

# Consumer — works out of the box via standard CcInfo flow
cc_binary(
    name = "myapp",
    srcs = ["main.c"],   # may #include "graal_isolate.h" + "myapi.h"
    deps = [":myapi"],
)

rust_binary(             # any rule that consumes CcInfo works the same way
    name = "myapp_rs",
    deps = [":myapi"],
)
```

One new attribute: `extra_headers` (list of strings, default `[]`). Each entry is a filename Native Image is expected to emit alongside the `.so`. Out of bounds for executables; `fail()` in the macro layer if `shared_library = False` and the list is non-empty.

## Architecture

### Header categories

Native Image emits two classes of header when `--shared` is set:

1. **Canonical isolate headers** — `graal_isolate.h` and `graal_isolate_dynamic.h`. Identical content across every shared image; declare the isolate-management API. Risk: if every `native_image(shared_library=True)` target surfaces its own copy, two such targets in one consumer's `CcInfo` produce two distinct `File` objects with the same basename. The consumer's `-iquote` search resolves to whichever symlink wins, which is fragile.
2. **Per-image headers** — `<image_basename>.h` and `<image_basename>_dynamic.h`. Specific to each image's `@CEntryPoint` declarations. No collision risk across images.
3. **Extra headers** — anything declared in `extra_headers`. Per-image; same collision profile as category 2.

GraalVM ships canonical isolate headers in the toolchain install, so we don't need to extract them from a per-image build.

### Approach: hidden anchor for canonical headers, per-image surfacing for the rest

Two cooperating pieces:

**A. New internal rule `_isolate_headers_anchor`** (`internal/native_image/cc_info.bzl`, or similar). Toolchain-keyed. Exposes `graal_isolate.h` + `graal_isolate_dynamic.h` from the GraalVM install via `CcInfo`. Single instance per toolchain; `File` objects are stable.

**B. `native_image(shared_library=True)` — additive `CcInfo`.**

When `shared_library = True`:

1. Declare the per-image headers as outputs of the existing native-image action: `<image_basename>.h`, `<image_basename>_dynamic.h`, plus each entry in `extra_headers`. Native Image already emits these into `-H:Path=<binary_dir>` when `--shared` is set; declaring them just brings them under Bazel tracking.
2. *Don't* declare the canonical isolate headers as outputs. Native Image still emits them into the binary dir — Bazel tolerates undeclared action outputs — but they don't enter this rule's tracked outputs. We don't need them; the anchor provides them.
3. Stage the declared per-image headers into a per-target include dir (`<target>_includes/`) via `ctx.actions.symlink`. Keeps a clean include root, isolated from the `.so` and other build artifacts.
4. Pull in the anchor target via an implicit attribute: `_isolate_headers = attr.label(default = "@rules_graalvm//graalvm/nativeimage:_isolate_headers")`. The single anchor instance is materialized once per build graph; `File` identity stays stable across consumers. (A toolchain-resolved variant is possible — listed under Open items — but the implicit-attr path is what this spec commits to.)
5. Build `CcInfo`:
   - `compilation_context` from `cc_common.create_compilation_context(headers = <staged per-image headers>, quote_includes = [<target>_includes path])`.
   - `linking_context` from `cc_common.create_linking_context(linker_inputs = depset([linker_input]))` where `linker_input` is built via `cc_common.create_linker_input(libraries = depset([cc_common.create_library_to_link(dynamic_library = binary, ...)]))`. Uses the existing `cc_toolchain` already resolved by the rule.
   - **Merge with the anchor's `CcInfo`:** `cc_common.merge_cc_infos(direct_cc_infos = [anchor[CcInfo]], cc_infos = [own_cc_info])`.
6. Append the merged `CcInfo` to the rule's existing providers list. `DefaultInfo.runfiles` already includes the `.so` via `collect_default = True`; staged headers are added to `default_files` so `bazel build` materializes them.

### Why this dedupes correctly

A consumer that depends on N `native_image` shared libs aggregates N `CcInfo`s. Each one's `compilation_context.headers` depset transitively includes the *same* `File` objects from the single anchor instance. Bazel's depset semantics dedupe by `File` identity → exactly one `graal_isolate.h` reaches the consumer's `-iquote` path. No special logic in our rule.

## Files modified / added

- `internal/native_image/cc_info.bzl` (new) — `_isolate_headers_anchor` rule and a helper that builds the per-target `CcInfo` for a `shared_library = True` native_image target.
- `internal/native_image/common.bzl` — add `extra_headers` to `_NATIVE_IMAGE_ATTRS`. Add `_isolate_headers` implicit attr (label, default points at the anchor instance).
- `internal/native_image/rules.bzl` — in `_graal_binary_implementation`, when `shared_library = True`: declare per-image headers, stage include dir, build CcInfo, merge with anchor, append to providers.
- `graalvm/nativeimage/rules.bzl` — public `native_image` macro forwards `extra_headers`. Validate `extra_headers` is empty when `shared_library = False`.
- `graalvm/nativeimage/BUILD.bazel` — instantiate the anchor target so it's available at the implicit-attr default label.
- `docs/shared-libraries.md` — document the new behavior, the `extra_headers` attribute, and that consumers can `deps = [native_image_target]` directly.

## Data flow

### Build time (producer, `shared_library = True`)

1. Resolve `<image_basename>` by stripping platform `lib` prefix and `.so`/`.dylib`/`.dll` suffix from `binary.basename`.
2. Per-image header outputs declared: `<binary_dir>/<image_basename>.h`, `<binary_dir>/<image_basename>_dynamic.h`, plus each entry of `extra_headers`. Added to the action's `outputs`.
3. Native-image action runs (no flag changes; `--shared` already triggers emission). Emits `.so` + per-image headers + canonical isolate headers (the latter undeclared, tolerated).
4. Per-target include dir staged via `ctx.actions.symlink`: each declared per-image header → `<target>_includes/<basename>`.
5. `CcInfo` constructed with per-image headers + dynamic_library, then merged with anchor's `CcInfo`.

### Build time (consumer, `cc_binary` / `rust_binary` / etc.)

1. Standard `CcInfo` aggregation via the consumer rule's `deps` semantics.
2. Compile actions get `-iquote <target>_includes/` from each shared-lib dep + `-iquote <anchor's includes dir>` once. `#include "graal_isolate.h"` resolves to the anchor copy; `#include "myapi.h"` resolves to the matching shared lib's per-target dir.
3. Link action gets the dynamic libraries as linker inputs; ld emits NEEDED entries.
4. `DefaultInfo.runfiles` propagation makes `.so`s available at `bazel run` time. Consumer's RPATH wiring is handled by the standard `cc_*` rules (typically `$ORIGIN/_solib_*`); we don't override.

### Runtime (consumer)

Loader resolves the NEEDED entries via the consumer's RPATH, finds the staged `.so`, completes load. No new runtime mechanics introduced by this design.

## Error handling

- **Native Image fails to emit a declared per-image header** → Bazel "missing declared output" error names the path. Correct loud failure; no silent fallback.
- **`shared_library = False` with `extra_headers` set** → macro-layer `fail()` with a clear message. Forward-compatible relaxation if header surfacing for executables is later wanted.
- **Duplicate header name across canonical, per-image, and extras** → impossible for canonical (we never declare those as our outputs). Possible across per-image and `extra_headers`; `declare_file` collision fails the build. Acceptable; user-facing error names the file.
- **Toolchain missing canonical isolate headers** → anchor target fails at analysis with a message naming the expected toolchain path. Indicates a broken or unsupported GraalVM install.
- **Cross-compilation / Windows** → existing platform-suffix logic (`_BIN_POSTFIX_DLL`, `_BIN_POSTFIX_DYLIB`, `_BIN_POSTFIX_SO`) is reused. Headers are platform-agnostic.

## Testing

Extend `example/integration_tests/layers/sample/` with a `shared_consumer` package:

```python
java_library(
    name = "shared_api",
    srcs = ["SharedApi.java"],   # @CEntryPoint hello_world(...)
)

native_image(
    name = "libsharedapi",
    shared_library = True,
    deps = [":shared_api"],
)

cc_binary(
    name = "shared_consumer",
    srcs = ["consumer.c"],   # #include "graal_isolate.h" + "sharedapi.h"
    deps = [":libsharedapi"],
)

sh_test(
    name = "shared_roundtrip_test",
    srcs = ["run_consumer.sh"],
    data = [":shared_consumer"],
)
```

Coverage:

1. `bazel build //sample:libsharedapi` produces the `.so` plus `<image>.h` and `<image>_dynamic.h`.
2. `bazel build //sample:shared_consumer` compiles `consumer.c` against the surfaced headers and links against the `.so` — verifies CcInfo flow.
3. `bazel test //sample:shared_roundtrip_test` runs the binary, calls into `hello_world` via the produced isolate, exits zero — verifies runtime resolution.
4. **Dedup test** — a separate target with two `native_image(shared_library=True)` deps in a single `cc_binary`, exercising aggregation. Build success is the assertion; if the anchor isn't deduped, header-collision warnings or duplicate-include errors surface here.
5. **Negative test** — a `bazel build` with `extra_headers = ["does_not_exist.h"]` expected to fail with a "missing declared output" message naming the file.

`rules_rust` integration test is out of scope for this spec — `CcInfo` is the contract and standard rules_rust consumes it. If something doesn't work there, it's a follow-up.

CI: extend the existing layers integration test rather than create a new one. `bazelci` already runs that suite cross-platform; the dedup test and negative test inherit the matrix automatically. Windows runtime behavior (DLL search) is the riskiest leg — match the existing `target_compatible_with` pattern used elsewhere in the integration suite.

## Migration / compatibility

- Existing `shared_library = True` users keep their current `DefaultInfo` behavior. The change is purely additive — they gain a `CcInfo` provider and two declared header outputs (`<image>.h`, `<image>_dynamic.h`), plus any entries in `extra_headers`. No existing flag or output goes away.
- The new `extra_headers` attribute defaults to `[]`; no existing call sites need to change.
- The anchor target is internal; users do not reference it directly.

## Open items (not blocking this spec)

- Exact toolchain path to `graal_isolate.h` / `graal_isolate_dynamic.h` in the GraalVM install — to be confirmed during implementation by inspecting the bundled distribution. Anchor target's implementation slots that path in.
- Whether `<image>_dynamic.h` is emitted by every Native Image `--shared` build or whether some configurations omit it. If emission is conditional, declaring it as an output would fail those builds — fix is to either drop it from the canonical set (force users into `extra_headers` for the dynamic variant) or detect emission via a wrapper script that creates an empty stub when missing. Verify during implementation; choose remedy then.
- Whether the macro-layer guard on `extra_headers` should be a hard `fail()` or a softer warning — leaning hard fail; clearer ergonomics.
- Whether to also surface a `cc_import`-style alias target for users who want to wrap the produced shared lib with custom `cc_library` semantics. YAGNI for now.
- Whether the anchor should be implicit-attr (this spec) or toolchain-resolved. Toolchain resolution is more idiomatic for toolchain-keyed resources but adds complexity if `_GVM_TOOLCHAIN_TYPE` doesn't already carry the file references; the implicit-attr path keeps things straightforward and is trivial to migrate later.
