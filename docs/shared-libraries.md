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

### How `main_class` works with shared libraries

Even when building a shared library, GraalVM typically needs a `main_class`. Instead of becoming a runnable entrypoint,
the `main_class` is used by the Native Image compiler as the starting point for points-to analysis and code gen.

Alternatively, the [`@CEntryPoint` API][2] can be used to define library entrypoints. See [here][3] for more information.

[1]: https://www.graalvm.org/latest/reference-manual/native-image/guides/build-native-shared-library/
[2]: https://www.graalvm.org/sdk/javadoc/org/graalvm/nativeimage/c/function/CEntryPoint.html
[3]: https://www.graalvm.org/latest/reference-manual/native-image/guides/build-native-shared-library/
