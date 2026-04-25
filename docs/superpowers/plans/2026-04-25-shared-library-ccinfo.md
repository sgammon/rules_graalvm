# Native Image shared-library `CcInfo` round-trip — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `native_image(shared_library = True)` expose `CcInfo` so any `cc_*` / `rust_*` rule can `deps = [native_image_target]` directly — surfacing the produced `.so`/`.dylib`/`.dll` plus per-image headers, with canonical `graal_isolate.h` deduplicated via a hidden anchor target.

**Architecture:** Internal anchor rule `_isolate_headers_anchor` reads canonical `graal_isolate.h` / `graal_isolate_dynamic.h` from the GraalVM toolchain and exposes them via `CcInfo`. Every `native_image(shared_library=True)` target picks up the anchor via implicit attribute, declares its own per-image headers (`<image>.h`, `<image>_dynamic.h`, plus any `extra_headers`) as outputs of the existing native-image action, and merges its own `CcInfo` (compilation context with per-image headers, linking context with the dynamic library) with the anchor's. Consumers aggregate `CcInfo` normally; `File`-identity dedupes the canonical headers.

**Tech Stack:** Bazel 9 (modern bzlmod), Starlark, `cc_common` via `@rules_graalvm_cc_shim` shim (Bazel-version-aware), GraalVM Native Image 25.1, integration tests via `bazelisk` + `sh_test`.

**Spec:** `docs/superpowers/specs/2026-04-25-shared-library-ccinfo-design.md`

**Important:** This project uses `bazelisk`. Never invoke `bazel` directly.

---

## File map

**New files:**
- `internal/native_image/cc_info.bzl` — `_isolate_headers_anchor` rule + helper `build_shared_library_cc_info(ctx, binary, declared_headers)`.
- `example/integration_tests/layers/sample/api/SharedApi.java` — `@CEntryPoint` declaration for the integration test.
- `example/integration_tests/layers/sample/api/BUILD.bazel` — `java_library` for the API.
- `example/integration_tests/layers/sample/cc/consumer.c` — C consumer that calls into the shared library.
- `example/integration_tests/layers/sample/cc/run_consumer.sh` — `sh_test` runner.
- `example/integration_tests/layers/sample/cc/BUILD.bazel` — `native_image(shared_library=True)`, `cc_binary`, `sh_test`, plus dedup test.

**Modified files:**
- `internal/native_image/common.bzl` — add `extra_headers` and `_isolate_headers` attrs.
- `internal/native_image/rules.bzl` — call helper when `shared_library = True`, append `CcInfo` to providers.
- `graalvm/nativeimage/rules.bzl` — public macro forwards `extra_headers`, validates pairing with `shared_library`.
- `graalvm/nativeimage/BUILD.bazel` — instantiate the anchor target.
- `docs/shared-libraries.md` — document the new behavior.

---

## Task 1: Discover canonical isolate header path in the GraalVM install

**Files:** none modified — investigation only. Result feeds Task 4.

- [ ] **Step 1: Build a layered sample to ensure the GraalVM SDK is fetched**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build //sample:libbase
```

Expected: build succeeds (SDK was already fetched on prior runs; this just guarantees the external repo is materialized).

- [ ] **Step 2: Locate `graal_isolate.h` inside the materialized GraalVM repo**

```bash
GVM_ROOT=$(bazelisk info output_base 2>/dev/null)/external/_main~_repo_rules~graalvm
# fall back if the canonical layout differs:
[ -d "$GVM_ROOT" ] || GVM_ROOT=$(find "$(bazelisk info output_base)/external" -maxdepth 2 -type d -name "*graalvm*" -print -quit)
find "$GVM_ROOT" -name "graal_isolate.h" -print
find "$GVM_ROOT" -name "graal_isolate_dynamic.h" -print
```

Expected: prints two paths, both inside the GraalVM install, almost certainly under `lib/svm/clibraries/<arch>/include/` (or `lib/static/<arch>/.../include/`). Record the **GraalVM-relative** path (e.g. `lib/svm/clibraries/linux-amd64/include/graal_isolate.h`) — Task 4 uses this prefix to filter `gvm_files`.

- [ ] **Step 3: Confirm the headers are in the toolchain's `gvm_files` filegroup**

```bash
grep -rn "gvm_files\|graal_isolate" $(bazelisk info output_base)/external/_main~_repo_rules~graalvm/BUILD* 2>/dev/null | head -20
```

Expected: the GraalVM repo's BUILD files include a `filegroup` that globs all install files; the headers are inside. (If they're excluded by a `glob` exclusion, Task 4 needs to pull them in via a different attribute — add a follow-up note here.)

- [ ] **Step 4: Record the discovered relative path**

Note the discovered relative path (e.g. `lib/svm/clibraries/linux-amd64/include/`) for documentation purposes. The anchor rule (Task 4) filters by **basename**, not by directory prefix, so the path is informational only — but knowing it lets you confirm Task 4 Step 3's success message is plausible. Don't commit anything; this is a discovery step.

---

## Task 2: Bootstrap the integration test (failing build)

**Files:**
- Create: `example/integration_tests/layers/sample/api/SharedApi.java`
- Create: `example/integration_tests/layers/sample/api/BUILD.bazel`
- Create: `example/integration_tests/layers/sample/cc/consumer.c`
- Create: `example/integration_tests/layers/sample/cc/run_consumer.sh`
- Create: `example/integration_tests/layers/sample/cc/BUILD.bazel`

- [ ] **Step 1: Create the API Java source**

`example/integration_tests/layers/sample/api/SharedApi.java`:

```java
package api;

import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;
import org.graalvm.nativeimage.c.type.CCharPointer;
import org.graalvm.nativeimage.c.type.CTypeConversion;

public final class SharedApi {

    private SharedApi() {}

    @CEntryPoint(name = "shared_api_meaning")
    public static int meaning(IsolateThread thread) {
        return 42;
    }

    @CEntryPoint(name = "shared_api_greet")
    public static int greet(IsolateThread thread, CCharPointer outBuf, int outBufLen) {
        String greeting = "hello from native-image";
        byte[] bytes = greeting.getBytes();
        int n = Math.min(bytes.length, Math.max(0, outBufLen - 1));
        for (int i = 0; i < n; i++) {
            outBuf.write(i, bytes[i]);
        }
        outBuf.write(n, (byte) 0);
        return n;
    }
}
```

- [ ] **Step 2: Create the API BUILD file**

`example/integration_tests/layers/sample/api/BUILD.bazel`:

```python
load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "api",
    srcs = ["SharedApi.java"],
    visibility = ["//visibility:public"],
)
```

- [ ] **Step 3: Create the C consumer source**

`example/integration_tests/layers/sample/cc/consumer.c`:

```c
#include <stdio.h>
#include <stdlib.h>

#include "graal_isolate.h"
#include "sharedapi.h"

int main(void) {
    graal_isolate_t *isolate = NULL;
    graal_isolatethread_t *thread = NULL;

    if (graal_create_isolate(NULL, &isolate, &thread) != 0) {
        fprintf(stderr, "graal_create_isolate failed\n");
        return 1;
    }

    int meaning = shared_api_meaning(thread);
    if (meaning != 42) {
        fprintf(stderr, "shared_api_meaning returned %d, expected 42\n", meaning);
        graal_tear_down_isolate(thread);
        return 2;
    }

    char buf[64];
    int n = shared_api_greet(thread, buf, (int)sizeof(buf));
    if (n <= 0) {
        fprintf(stderr, "shared_api_greet returned %d\n", n);
        graal_tear_down_isolate(thread);
        return 3;
    }

    printf("%s\n", buf);

    if (graal_tear_down_isolate(thread) != 0) {
        fprintf(stderr, "graal_tear_down_isolate failed\n");
        return 4;
    }
    return 0;
}
```

- [ ] **Step 4: Create the shell test runner**

`example/integration_tests/layers/sample/cc/run_consumer.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
"$@" | tee /tmp/shared_consumer.out
grep -q "hello from native-image" /tmp/shared_consumer.out
```

Then make it executable:

```bash
chmod +x example/integration_tests/layers/sample/cc/run_consumer.sh
```

- [ ] **Step 5: Create the BUILD file with native_image, cc_binary, sh_test**

`example/integration_tests/layers/sample/cc/BUILD.bazel`:

```python
load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@rules_graalvm//graalvm:defs.bzl", "native_image")

native_image(
    name = "libsharedapi",
    shared_library = True,
    deps = ["//sample/api"],
)

cc_binary(
    name = "shared_consumer",
    srcs = ["consumer.c"],
    deps = [":libsharedapi"],
)

sh_test(
    name = "shared_roundtrip_test",
    srcs = ["run_consumer.sh"],
    args = ["$(rootpath :shared_consumer)"],
    data = [":shared_consumer"],
)
```

- [ ] **Step 6: Run the build and verify it fails as expected**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build //sample/cc:shared_consumer 2>&1 | tail -30
```

Expected: build fails. The `cc_binary` cannot resolve `#include "graal_isolate.h"` / `#include "sharedapi.h"` because `:libsharedapi` is a `native_image` target that does not yet expose `CcInfo`. The error should be a missing header or "no such target attribute / provider" type message.

- [ ] **Step 7: Commit the bootstrap test files**

```bash
cd /home/sam/workspace/rules_graalvm
git add example/integration_tests/layers/sample/api/ example/integration_tests/layers/sample/cc/
git commit -m "test: bootstrap shared-library CcInfo round-trip integration test"
```

---

## Task 3: Add `extra_headers` attribute and macro guard

**Files:**
- Modify: `internal/native_image/common.bzl` (add to `_NATIVE_IMAGE_ATTRS`)
- Modify: `graalvm/nativeimage/rules.bzl` (add macro arg, forward, validate)

`extra_headers` is added to `_NATIVE_IMAGE_ATTRS` as `attr.string_list`. Because layer rules derive from `_NATIVE_IMAGE_ATTRS` minus `_LAYER_EXCLUDED_ATTRS`, also append `"extra_headers"` to that exclusion list — layers do not surface CcInfo and don't accept extras.

- [ ] **Step 1: Add `extra_headers` to `_NATIVE_IMAGE_ATTRS`**

Edit `internal/native_image/common.bzl`. After the `cc_deps_dynamic` attribute (around line 150), insert:

```python
    "extra_headers": attr.string_list(
        doc = "Additional header filenames Native Image is expected to emit alongside the " +
              "shared library when `shared_library = True`. Each entry is a basename (no " +
              "directory component); the rule declares it as an output of the native-image " +
              "action and surfaces it via `CcInfo.compilation_context.headers`. Use this for " +
              "configurations where Native Image emits more than the canonical " +
              "`<image>.h` / `<image>_dynamic.h` per-image headers — e.g. when custom " +
              "`@CEntryPoint`-bearing features inject their own headers. Meaningless when " +
              "`shared_library = False`; the public macro rejects that combination.",
        mandatory = False,
        default = [],
    ),
```

- [ ] **Step 2: Update `_LAYER_EXCLUDED_ATTRS`**

Edit `internal/native_image/common.bzl` around line 202. Append `"extra_headers"`:

```python
_LAYER_EXCLUDED_ATTRS = [
    "main_class",
    "shared_library",
    "executable_name",
    "profiles",
    "extra_headers",
]
```

- [ ] **Step 3: Add `extra_headers` to the public `native_image` macro**

Edit `graalvm/nativeimage/rules.bzl`. In the `native_image` function signature (around line 73), insert `extra_headers = []` between `cc_deps_dynamic = []` and `data = []`:

```python
        cc_deps = [],
        cc_deps_dynamic = [],
        extra_headers = [],
        data = [],
```

In the docstring (around line 130, after the `cc_deps_dynamic:` doc line), insert:

```
        extra_headers: Additional header filenames Native Image is expected to emit alongside
            the shared library. Only valid when `shared_library = True`. Each entry is a basename
            and is declared as an output of the native-image action; the rule surfaces it via
            `CcInfo.compilation_context.headers`. No default; optional.
```

In the `_native_image(...)` call (around line 167), insert `extra_headers = extra_headers,` next to `cc_deps_dynamic`:

```python
        cc_deps = cc_deps,
        cc_deps_dynamic = cc_deps_dynamic,
        extra_headers = extra_headers,
```

- [ ] **Step 4: Add the macro-layer guard for `shared_library = False` + non-empty `extra_headers`**

In `graalvm/nativeimage/rules.bzl`, just before the `_native_image(...)` call (after `_validate_layers(...)` around line 145), add:

```python
    if extra_headers and not shared_library:
        fail(
            ("`extra_headers` is only valid when `shared_library = True` " +
             "(target '%s' has shared_library=%s and extra_headers=%s).") % (
                name,
                shared_library,
                extra_headers,
            ),
        )
```

- [ ] **Step 5: Smoke-build to verify the new attribute parses**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build //sample/cc:libsharedapi 2>&1 | tail -20
```

Expected: build succeeds *or* fails for a reason other than attribute parsing. If it fails with "unexpected keyword argument 'extra_headers'", the wiring is wrong — re-check the macro/rule attribute passthrough. The `cc_binary` build will still fail (no CcInfo yet) but that's tested in Task 6.

- [ ] **Step 6: Verify the guard works**

Add a temporary test of the guard. Edit `example/integration_tests/layers/sample/cc/BUILD.bazel`, append a deliberately-broken target, build it, expect failure, then revert:

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
cat <<'EOF' >> sample/cc/BUILD.bazel
# TEMP: guard test
native_image(
    name = "guard_test",
    main_class = "exe.Main",
    extra_headers = ["foo.h"],
    deps = ["//sample/exe"],
)
EOF
bazelisk build //sample/cc:guard_test 2>&1 | tail -10
```

Expected: fails with the message `extra_headers is only valid when shared_library = True`. Then revert the temp target:

```bash
git checkout sample/cc/BUILD.bazel
```

- [ ] **Step 7: Commit**

```bash
cd /home/sam/workspace/rules_graalvm
git add internal/native_image/common.bzl graalvm/nativeimage/rules.bzl
git commit -m "feat(native_image): add extra_headers attr and shared_library pairing guard"
```

---

## Task 4: Create the isolate-headers anchor rule

**Files:**
- Create: `internal/native_image/cc_info.bzl`
- Modify: `graalvm/nativeimage/BUILD.bazel` (instantiate the anchor)

The anchor receives the GraalVM toolchain, scans `gvm_files` for `graal_isolate.h` / `graal_isolate_dynamic.h`, symlinks them into a per-target include dir, and exposes `CcInfo` with `compilation_context.headers` set and `quote_includes` pointing at the dir.

- [ ] **Step 1: Create `internal/native_image/cc_info.bzl` with the anchor rule**

```python
"""Helpers for surfacing CcInfo from `native_image(shared_library = True)` targets.

Two pieces:
  1. `isolate_headers_anchor` — toolchain-keyed rule exposing the canonical
     `graal_isolate.h` / `graal_isolate_dynamic.h` headers (which ship with every
     GraalVM SDK install) via `CcInfo`. A single instance is materialized once
     per build graph, so consumers depending on multiple `native_image` shared
     libraries see one stable `File` for each canonical header — `compilation_context`
     depsets dedupe by `File` identity automatically, no special logic required.
  2. `build_shared_library_cc_info` — helper called by the shared-library code
     path in `_graal_binary_implementation`. Builds a per-target compilation
     context (per-image headers + `<target>_includes/` quote-include dir) plus a
     linking context (the produced `.so`/`.dylib`/`.dll` as a dynamic library)
     and merges with the anchor's CcInfo.
"""

load("@rules_graalvm_cc_shim//:cc_shim.bzl", "cc_shim")

_GVM_TOOLCHAIN_TYPE = "@rules_graalvm//graalvm/toolchain"

# Header filenames are stable across GraalVM 21+. Both ship in every SDK install
# under `lib/svm/clibraries/<arch>/include/` (or a similar arch-specific path).
_CANONICAL_ISOLATE_HEADERS = ("graal_isolate.h", "graal_isolate_dynamic.h")

def _isolate_headers_anchor_impl(ctx):
    gvm = ctx.toolchains[Label(_GVM_TOOLCHAIN_TYPE)].graalvm
    gvm_files = gvm.gvm_files[DefaultInfo].files.to_list()

    matched = {}
    for f in gvm_files:
        if f.basename in _CANONICAL_ISOLATE_HEADERS and f.basename not in matched:
            matched[f.basename] = f

    missing = [h for h in _CANONICAL_ISOLATE_HEADERS if h not in matched]
    if missing:
        fail(("Could not locate canonical Native Image isolate headers in the " +
              "GraalVM toolchain: %s. Expected them under " +
              "`lib/svm/clibraries/<arch>/include/` of the GraalVM install. " +
              "If your GraalVM distribution layout differs, this anchor rule " +
              "needs adjusting (file an issue).") % missing)

    include_dir = ctx.label.name + "_includes"
    staged = []
    for basename, src in matched.items():
        out = ctx.actions.declare_file("%s/%s" % (include_dir, basename))
        ctx.actions.symlink(output = out, target_file = src)
        staged.append(out)

    # Pick any staged file's dirname to derive the quote-include path; all share the dir.
    quote_dir = staged[0].dirname

    cc_common = cc_shim.cc_common
    compilation_context = cc_common.create_compilation_context(
        headers = depset(staged),
        quote_includes = depset([quote_dir]),
    )
    cc_info = cc_shim.CcInfo(compilation_context = compilation_context)

    return [
        DefaultInfo(files = depset(staged)),
        cc_info,
    ]

isolate_headers_anchor = rule(
    implementation = _isolate_headers_anchor_impl,
    doc = "Internal: exposes canonical GraalVM isolate headers via CcInfo. " +
          "Single instance shared by all `native_image(shared_library=True)` targets.",
    toolchains = [_GVM_TOOLCHAIN_TYPE],
)
```

- [ ] **Step 2: Instantiate the anchor target**

Edit `graalvm/nativeimage/BUILD.bazel`. After the existing loads (top of file), add:

```python
load("//internal/native_image:cc_info.bzl", "isolate_headers_anchor")
```

At the bottom of the file, append:

```python
isolate_headers_anchor(
    name = "_isolate_headers",
    visibility = ["//visibility:public"],
)
```

- [ ] **Step 3: Build the anchor in isolation to verify it works**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build @rules_graalvm//graalvm/nativeimage:_isolate_headers 2>&1 | tail -20
```

Expected: build succeeds. Output:

```bash
bazelisk cquery 'kind(rule, @rules_graalvm//graalvm/nativeimage:_isolate_headers)' --output=files 2>/dev/null
```

Expected: prints two paths ending in `_isolate_headers_includes/graal_isolate.h` and `_isolate_headers_includes/graal_isolate_dynamic.h`.

If the build fails with "Could not locate canonical Native Image isolate headers": the headers exist in the install but are excluded from `gvm_files`. Re-do Task 1 Step 3 to confirm the filegroup glob; if needed, the GraalVM repo's BUILD template (`internal/repository/*.tpl`) may need a wider include — flag this as a follow-up and proceed by reading the headers via a separate `attr.label_list(allow_files=True)` directly pointing at the install path.

- [ ] **Step 4: Commit**

```bash
cd /home/sam/workspace/rules_graalvm
git add internal/native_image/cc_info.bzl graalvm/nativeimage/BUILD.bazel
git commit -m "feat(native_image): add isolate-headers anchor for CcInfo dedup"
```

---

## Task 5: Wire `CcInfo` construction into the shared-library code path

**Files:**
- Modify: `internal/native_image/cc_info.bzl` (add `build_shared_library_cc_info` helper)
- Modify: `internal/native_image/common.bzl` (add `_isolate_headers` implicit attr)
- Modify: `internal/native_image/rules.bzl` (call helper, append CcInfo to providers)

- [ ] **Step 1: Add `_isolate_headers` implicit attr to `_NATIVE_IMAGE_ATTRS`**

Edit `internal/native_image/common.bzl`. Inside `_NATIVE_IMAGE_ATTRS`, alongside the other implicit `_*` attributes (around line 180, with `_cc_toolchain`, `_linux_constraint`, etc.), insert:

```python
    "_isolate_headers": attr.label(
        default = Label("@rules_graalvm//graalvm/nativeimage:_isolate_headers"),
        providers = [[cc_shim.CcInfo]],
        doc = "Implicit dep on the canonical Native Image isolate-headers anchor. " +
              "Provides `graal_isolate.h` / `graal_isolate_dynamic.h` via CcInfo so " +
              "all `shared_library = True` targets share the same File objects, " +
              "letting depset dedup do the work.",
    ),
```

(Layer rules inherit the `_*` attrs through `_NATIVE_IMAGE_LAYER_ATTRS`. That's fine — they don't reference the attribute, but having it present is harmless and avoids a special-case removal.)

- [ ] **Step 2: Strip `lib` prefix and platform suffix to derive `<image_basename>`**

Add a helper at the top of `internal/native_image/cc_info.bzl` (after the `_CANONICAL_ISOLATE_HEADERS` constant, before `_isolate_headers_anchor_impl`):

```python
_SHARED_LIB_SUFFIXES = (".so", ".dylib", ".dll")

def _image_basename_from_binary(binary_basename):
    """Strip platform `lib` prefix and `.so`/`.dylib`/`.dll` suffix.

    Native Image emits `<image_basename>.h` and `<image_basename>_dynamic.h` next
    to the shared library; the basename matches what NI uses internally, which
    matches the binary file's basename minus the platform-specific decoration.
    """
    base = binary_basename
    for suffix in _SHARED_LIB_SUFFIXES:
        if base.endswith(suffix):
            base = base[:-len(suffix)]
            break
    if base.startswith("lib"):
        base = base[len("lib"):]
    return base
```

- [ ] **Step 3: Add the `build_shared_library_cc_info` helper**

Append to `internal/native_image/cc_info.bzl`:

```python
def declare_shared_library_headers(ctx, binary):
    """Declare per-image header outputs for a `shared_library = True` build.

    Returns a list of `File` outputs for `<image>.h`, `<image>_dynamic.h`, and any
    entries in `ctx.attr.extra_headers`. Each is `declare_file()`-ed in the same
    directory as `binary` (i.e. native-image's `-H:Path` target dir) so the action
    consumes them as natural co-located outputs without extra flags.
    """
    image_basename = _image_basename_from_binary(binary.basename)
    binary_dir = binary.dirname

    canonical = ["%s.h" % image_basename, "%s_dynamic.h" % image_basename]
    all_headers = canonical + list(ctx.attr.extra_headers)

    declared = []
    for header_name in all_headers:
        # `declare_file` uses paths relative to the package; we want it in the same
        # bazel-out dir as `binary`. Bazel resolves relative paths under the package's
        # bin output dir, so passing the basename directly puts it next to `binary`.
        out = ctx.actions.declare_file(header_name, sibling = binary)
        declared.append(out)
    return declared

def build_shared_library_cc_info(ctx, binary, declared_headers):
    """Construct the merged CcInfo for a `shared_library = True` native_image.

    Stages declared per-image headers into a per-target `<target>_includes/` dir
    via symlink so the include search root is clean (free of the `.so` and any
    other build artifacts). Builds a `compilation_context` (headers + quote_includes)
    and a `linking_context` (dynamic_library = binary), then merges with the
    anchor's CcInfo so the canonical isolate headers come from the single shared
    instance.

    Returns: a tuple `(cc_info, staged_headers)`. The caller should add
    `staged_headers` to `default_files` so `bazel build` materializes the
    include dir.
    """
    cc_common = cc_shim.cc_common

    include_dir_name = ctx.label.name + "_includes"
    staged_headers = []
    for declared in declared_headers:
        staged = ctx.actions.declare_file("%s/%s" % (include_dir_name, declared.basename))
        ctx.actions.symlink(output = staged, target_file = declared)
        staged_headers.append(staged)

    quote_dir = staged_headers[0].dirname if staged_headers else None

    compilation_context = cc_common.create_compilation_context(
        headers = depset(staged_headers),
        quote_includes = depset([quote_dir]) if quote_dir else depset([]),
    )

    # Link context: surface the `.so` as a dynamic library so consumers' link
    # actions pick it up. We don't need a static archive (no `.a`); native-image
    # doesn't produce one in `--shared` mode.
    cc_toolchain = ctx.attr._cc_toolchain[cc_common.CcToolchainInfo]
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    library_to_link = cc_common.create_library_to_link(
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        dynamic_library = binary,
    )
    linker_input = cc_common.create_linker_input(
        owner = ctx.label,
        libraries = depset([library_to_link]),
    )
    linking_context = cc_common.create_linking_context(
        linker_inputs = depset([linker_input]),
    )

    own_cc_info = cc_shim.CcInfo(
        compilation_context = compilation_context,
        linking_context = linking_context,
    )
    anchor_cc_info = ctx.attr._isolate_headers[cc_shim.CcInfo]
    merged = cc_common.merge_cc_infos(
        direct_cc_infos = [anchor_cc_info, own_cc_info],
    )
    return merged, staged_headers
```

- [ ] **Step 4: Wire the helper into `_graal_binary_implementation`**

Edit `internal/native_image/rules.bzl`. At the top, add to the load block for `cc_info.bzl` (alongside the existing builder load):

```python
load(
    "//internal/native_image:cc_info.bzl",
    _build_shared_library_cc_info = "build_shared_library_cc_info",
    _declare_shared_library_headers = "declare_shared_library_headers",
)
```

In `_graal_binary_implementation`, after `binary` is computed by `_prepare_native_image_rule_context` (around line 134, before the `intermediate_dir` block), insert:

```python
    # When building a shared library, declare per-image headers as outputs of the
    # native-image action so Bazel tracks them. Native Image already emits these
    # into `-H:Path=<binary_dir>` when `--shared` is set; declaring them brings
    # them under the action's tracked outputs.
    declared_headers = []
    if ctx.attr.shared_library:
        declared_headers = _declare_shared_library_headers(ctx, binary)
```

Add `declared_headers` to the action's `outputs` list. Locate the `outputs = [binary]` line (around line 249) and update:

```python
    outputs = [binary] + declared_headers
    if intermediate_dir != None:
        outputs.append(intermediate_dir)
```

After the action runs and `staged_libs` / `runtime_libs` are computed (around line 305, after `runtime_libs = parent_staged_libs + cc_dyn_staged`), insert:

```python
    cc_info_provider = None
    cc_info_staged_headers = []
    if ctx.attr.shared_library:
        cc_info_provider, cc_info_staged_headers = _build_shared_library_cc_info(
            ctx,
            binary,
            declared_headers,
        )
```

Update `default_files` to include the staged headers:

```python
    default_files = [binary] + runtime_libs + cc_info_staged_headers
    if intermediate_dir != None:
        default_files.append(intermediate_dir)
```

In the `providers` list construction (around line 305), append `cc_info_provider` when non-None:

```python
    providers_list = [DefaultInfo(
        files = depset(default_files),
        executable = binary,
        runfiles = ctx.runfiles(
            collect_data = True,
            collect_default = True,
            files = runtime_libs,
        ),
    )]
    if cc_info_provider != None:
        providers_list.append(cc_info_provider)
    if intermediate_dir != None:
        providers_list.append(OutputGroupInfo(intermediate_dir = depset([intermediate_dir])))
    return providers_list
```

(Adjust the variable name and structure to match the existing return pattern — the existing code returns a list inline; this step splits it into a named local for cleanliness. Match existing style; don't restructure beyond what this task needs.)

- [ ] **Step 5: Build the producer in isolation**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build //sample/cc:libsharedapi 2>&1 | tail -30
```

Expected: build succeeds. The output should include the `.so`/`.dylib`/`.dll`, the four canonical-plus-per-image headers, and the symlinked include dir.

```bash
bazelisk cquery 'kind(rule, //sample/cc:libsharedapi)' --output=files 2>/dev/null
```

Expected: prints multiple files including `libsharedapi.so` (or `.dylib`), `sharedapi.h`, `sharedapi_dynamic.h`, plus staged header symlinks under a `_includes/` dir.

- [ ] **Step 6: Commit**

```bash
cd /home/sam/workspace/rules_graalvm
git add internal/native_image/cc_info.bzl internal/native_image/common.bzl internal/native_image/rules.bzl
git commit -m "feat(native_image): expose CcInfo from shared_library=True targets"
```

---

## Task 6: Verify the full round-trip integration test passes

**Files:** none modified.

- [ ] **Step 1: Build the consumer**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build //sample/cc:shared_consumer 2>&1 | tail -20
```

Expected: build succeeds. The `cc_binary` compiles `consumer.c` against the surfaced headers (`graal_isolate.h` from the anchor, `sharedapi.h` from the per-image set) and links against `libsharedapi.so` via the `CcInfo.linking_context`.

If the compile fails with "graal_isolate.h: No such file or directory": `quote_includes` propagation isn't reaching the `cc_binary`. Verify the anchor's `compilation_context.quote_includes` is non-empty and that `merge_cc_infos` includes it.

If the link fails with "undefined reference to shared_api_meaning": the linker isn't picking up the dynamic library. Verify `create_library_to_link(dynamic_library = binary)` is correctly wired and that the linker_input is in the linking_context.

- [ ] **Step 2: Run the round-trip test**

```bash
bazelisk test //sample/cc:shared_roundtrip_test --test_output=streamed 2>&1 | tail -30
```

Expected: PASSES. The test runs `shared_consumer`, which creates a Graal isolate, calls `shared_api_meaning` (returns 42, asserted), calls `shared_api_greet` (writes "hello from native-image"), and prints it. The shell script verifies the expected output is present.

- [ ] **Step 3: Run the existing layers tests to confirm no regression**

```bash
bazelisk test //... 2>&1 | tail -20
```

Expected: all existing tests still pass (most importantly `//sample:sample` and any layer-specific tests). The shared-library changes are strictly additive; if anything else breaks, it indicates the rule impl change touched layer or executable paths inadvertently.

- [ ] **Step 4: Commit (no file changes — just record the green run as a milestone)**

This is informational only; no commit needed unless any test files were tweaked during debugging. Skip if clean.

---

## Task 7: Add the dedup test (two shared libs in one consumer)

**Files:**
- Create: `example/integration_tests/layers/sample/api2/SharedApi2.java`
- Create: `example/integration_tests/layers/sample/api2/BUILD.bazel`
- Modify: `example/integration_tests/layers/sample/cc/BUILD.bazel`
- Modify: `example/integration_tests/layers/sample/cc/consumer.c` (or new dedup_consumer.c)

The dedup test verifies that two `native_image(shared_library=True)` deps in one `cc_binary` don't collide on `graal_isolate.h`. Build success is the primary assertion.

- [ ] **Step 1: Create a second API**

`example/integration_tests/layers/sample/api2/SharedApi2.java`:

```java
package api2;

import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

public final class SharedApi2 {

    private SharedApi2() {}

    @CEntryPoint(name = "shared_api2_double")
    public static int doubleIt(IsolateThread thread, int x) {
        return x * 2;
    }
}
```

`example/integration_tests/layers/sample/api2/BUILD.bazel`:

```python
load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "api2",
    srcs = ["SharedApi2.java"],
    visibility = ["//visibility:public"],
)
```

- [ ] **Step 2: Add dedup consumer C source**

`example/integration_tests/layers/sample/cc/dedup_consumer.c`:

```c
#include <stdio.h>

#include "graal_isolate.h"
#include "sharedapi.h"
#include "sharedapi2.h"

int main(void) {
    graal_isolate_t *iso1 = NULL;
    graal_isolatethread_t *t1 = NULL;
    if (graal_create_isolate(NULL, &iso1, &t1) != 0) return 1;

    int meaning = shared_api_meaning(t1);
    int doubled = shared_api2_double(t1, meaning);
    printf("dedup_ok meaning=%d doubled=%d\n", meaning, doubled);

    if (graal_tear_down_isolate(t1) != 0) return 2;
    return 0;
}
```

- [ ] **Step 3: Add the dedup runner**

`example/integration_tests/layers/sample/cc/run_dedup.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
"$@" | tee /tmp/dedup.out
grep -q "dedup_ok meaning=42 doubled=84" /tmp/dedup.out
```

```bash
chmod +x example/integration_tests/layers/sample/cc/run_dedup.sh
```

- [ ] **Step 4: Wire the dedup targets**

Append to `example/integration_tests/layers/sample/cc/BUILD.bazel`:

```python
native_image(
    name = "libsharedapi2",
    shared_library = True,
    deps = ["//sample/api2"],
)

cc_binary(
    name = "dedup_consumer",
    srcs = ["dedup_consumer.c"],
    deps = [
        ":libsharedapi",
        ":libsharedapi2",
    ],
)

sh_test(
    name = "dedup_roundtrip_test",
    srcs = ["run_dedup.sh"],
    args = ["$(rootpath :dedup_consumer)"],
    data = [":dedup_consumer"],
)
```

- [ ] **Step 5: Build and run**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk build //sample/cc:dedup_consumer 2>&1 | tail -10
bazelisk test //sample/cc:dedup_roundtrip_test --test_output=streamed 2>&1 | tail -20
```

Expected: build and test both PASS. If the build emits warnings or errors about `graal_isolate.h` redefinition or duplicate symbols, the dedup is broken — verify the anchor instance is the same `Target` for both `libsharedapi` and `libsharedapi2` (it should be: implicit attr default points at one label).

- [ ] **Step 6: Commit**

```bash
cd /home/sam/workspace/rules_graalvm
git add example/integration_tests/layers/sample/api2/ example/integration_tests/layers/sample/cc/
git commit -m "test: add dedup test for two shared-library CcInfo deps in one consumer"
```

---

## Task 7.5: Negative test — `extra_headers` with non-existent header name

**Files:** none persisted — this is an interactive verification.

The spec calls for explicit verification that declaring a non-existent header in `extra_headers` produces a clear "missing declared output" failure. We test it ad-hoc rather than persisting a permanently-failing target.

- [ ] **Step 1: Append a temporary target with a non-existent header**

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
cat <<'EOF' >> sample/cc/BUILD.bazel
# TEMP: negative test for extra_headers
native_image(
    name = "missing_header_test",
    shared_library = True,
    extra_headers = ["definitely_does_not_exist.h"],
    deps = ["//sample/api"],
)
EOF
```

- [ ] **Step 2: Build and confirm failure**

```bash
bazelisk build //sample/cc:missing_header_test 2>&1 | tail -30
```

Expected: build fails. The error message should reference `definitely_does_not_exist.h` and indicate that the action did not produce a declared output. Bazel's exact wording is "output … was not created" or similar. If the message does NOT name the missing file, that's a design hole — make a note and continue (the build still fails loudly, just less helpfully).

- [ ] **Step 3: Revert the temporary target**

```bash
git checkout sample/cc/BUILD.bazel
```

No commit for this task.

---

## Task 8: Documentation update

**Files:**
- Modify: `docs/shared-libraries.md`

- [ ] **Step 1: Replace `docs/shared-libraries.md` with the expanded version**

Replace the existing content of `docs/shared-libraries.md` with:

```markdown
## Shared libraries with GraalVM and Bazel

GraalVM can build [native shared libraries][1] from Java or polyglot code. This functionality is integrated with these
rules, via the `shared_library` target attribute on `native_image`:

```python
load("@rules_graalvm//:defs.bzl", "native_image")
```

```python
java_library(
    name = "example",
    srcs = ["..."],
)

native_image(
    name = "some_name",
    shared_library = True,
    deps = [
        ":example",
    ],
)
```

### Consuming a Native Image shared library from `cc_*` / `rust_*` targets

When `shared_library = True`, the rule exposes `CcInfo`, which means any Bazel rule that consumes the standard C/C++
provider — `cc_binary`, `cc_library`, `rust_binary`, etc. — can depend on the target directly:

```python
cc_binary(
    name = "consumer",
    srcs = ["main.c"],
    deps = [":some_name"],
)
```

The consumer's compile actions automatically receive the right `-iquote` paths, so its source files can simply:

```c
#include "graal_isolate.h"
#include "some_name.h"
```

The consumer's link action automatically picks up the produced `.so` / `.dylib` / `.dll`, and at `bazel run` time the
runfiles tree contains the shared library at the path the consumer's RPATH resolves.

### Headers exposed

Per shared-library target, the rule declares two **per-image headers** as outputs:

- `<image_basename>.h` — declares each `@CEntryPoint` for the C ABI.
- `<image_basename>_dynamic.h` — declares the function-pointer-style variants for late-bound dispatch.

The canonical **isolate headers** — `graal_isolate.h` and `graal_isolate_dynamic.h` — are surfaced once per build graph
via a hidden anchor target. This means a consumer depending on multiple `native_image(shared_library=True)` targets
sees a single `graal_isolate.h` (no header collisions, no duplicate-include warnings).

If your build produces additional headers (for example via custom `@CEntryPoint`-bearing GraalVM features), declare them
explicitly via `extra_headers`:

```python
native_image(
    name = "some_name",
    shared_library = True,
    extra_headers = ["custom_export.h"],
    deps = [":example"],
)
```

Each entry must be a basename Native Image emits alongside the shared library. If Native Image fails to produce a
listed header, the build fails with a "missing declared output" error naming the missing file.

### How `main_class` works with shared libraries

Even when building a shared library, GraalVM typically needs a `main_class`. Instead of becoming a runnable entrypoint,
the `main_class` is used by the Native Image compiler as the starting point for points-to analysis and code gen.

Alternatively, the [`@CEntryPoint` API][2] can be used to define library entrypoints. See [here][3] for more information.

[1]: https://www.graalvm.org/latest/reference-manual/native-image/guides/build-native-shared-library/
[2]: https://www.graalvm.org/sdk/javadoc/org/graalvm/nativeimage/c/function/CEntryPoint.html
[3]: https://www.graalvm.org/latest/reference-manual/native-image/guides/build-native-shared-library/
```

- [ ] **Step 2: Commit**

```bash
cd /home/sam/workspace/rules_graalvm
git add docs/shared-libraries.md
git commit -m "docs(shared-libraries): document CcInfo round-trip and extra_headers"
```

---

## Validation summary (end-to-end)

After all tasks, run:

```bash
cd /home/sam/workspace/rules_graalvm/example/integration_tests/layers
bazelisk test //... --test_output=errors 2>&1 | tail -20
```

Expected: every test passes, including the new `shared_roundtrip_test` and `dedup_roundtrip_test`. The legacy `sample` and `main_dyn` targets continue to build.

If any task fails to converge after one round of fix-forward, fall back to the spec's "Open items" section — particularly the `<image>_dynamic.h` emission risk: if Native Image declines to emit it for the test image, drop it from the canonical declared set and rely on `extra_headers` for users who need it. Update Task 5 Step 2 accordingly.
