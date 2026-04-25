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
    name = "libexample",
    shared_library = True,
    executable_name = "libexample",  # avoid the default "%target%-bin" suffix
    deps = [":example"],
)
```

### Consuming a Native Image shared library from `cc_*` / `rust_*` targets

When `shared_library = True`, the rule exposes `CcInfo`, which means any Bazel rule that consumes the standard C/C++
provider — `cc_binary`, `cc_library`, `rust_binary`, etc. — can depend on the target directly:

```python
cc_binary(
    name = "consumer",
    srcs = ["main.c"],
    deps = [":libexample"],
)
```

The consumer's compile actions automatically receive the right include paths, so its source files can simply:

```c
#include "graal_isolate.h"
#include "libexample.h"
```

The consumer's link action automatically picks up the produced `.so` / `.dylib` / `.dll`, and at `bazel run` time the
runfiles tree contains the shared library at the path the consumer's RPATH resolves.

### Headers exposed

Per shared-library target, the rule declares four headers as outputs:

- `graal_isolate.h` and `graal_isolate_dynamic.h` — the canonical isolate-management API. Native Image emits these for
  every `--shared` build; their contents are identical across builds under one toolchain version. Surfaced via every
  shared-library target's `CcInfo`. A consumer depending on multiple `native_image(shared_library = True)` targets sees
  each target's copy via separate `-iquote` / `-I` paths; the compiler picks the first match. Content equivalence makes
  this safe in practice.
- `<image_basename>.h` — declares each `@CEntryPoint` for the C ABI. The image basename matches the produced shared
  library's basename minus the platform suffix (e.g. `libexample.so` → `libexample.h`). Native Image keeps the `lib`
  prefix on Linux, which is why `executable_name = "libexample"` (rather than just `"example"`) gives the cleanest
  header story.
- `<image_basename>_dynamic.h` — the function-pointer-style variants for late-bound dispatch.

If your build produces additional headers (for example via custom `@CEntryPoint`-bearing GraalVM features), declare
them explicitly via `extra_headers`:

```python
native_image(
    name = "libexample",
    shared_library = True,
    executable_name = "libexample",
    extra_headers = ["custom_export.h"],
    deps = [":example"],
)
```

Each entry must be a basename Native Image emits alongside the shared library. If Native Image fails to produce a
listed header, the build fails with a "missing declared output" error naming the missing file. The attribute is only
valid when `shared_library = True`; passing it with `shared_library = False` is a build error.

### Known limitation: one shared library per package

Two `native_image(shared_library = True)` targets in the same Bazel package will collide on `graal_isolate.h` (and the
other canonical headers) because the rule declares them as siblings of the produced binary, and both targets share an
output directory. Until this is plumbed through to a per-target subdirectory, place each shared library in its own
package. The integration test under `example/integration_tests/layers/sample/cc/` and `cc2/` demonstrates the pattern.

### How `main_class` works with shared libraries

Even when building a shared library, GraalVM typically needs a `main_class`. Instead of becoming a runnable entrypoint,
the `main_class` is used by the Native Image compiler as the starting point for points-to analysis and code gen.

Alternatively, the [`@CEntryPoint` API][2] can be used to define library entrypoints. See [here][3] for more
information.

[1]: https://www.graalvm.org/latest/reference-manual/native-image/guides/build-native-shared-library/
[2]: https://www.graalvm.org/sdk/javadoc/org/graalvm/nativeimage/c/function/CEntryPoint.html
[3]: https://www.graalvm.org/latest/reference-manual/native-image/guides/build-native-shared-library/
