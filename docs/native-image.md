## Building GraalVM native images with Bazel

After you [install the rules](./modern-bazel.md) and setup your GraalVM repository, you can easily use it to build a native image using the `native-image` tool, from a standard Bazel `java_library` or `java_binary` target.

### Native image example

> **Note**
> This sample is present in the `rules_graalvm` repository at `example/native`. See [examples](./examples.md).

**In `Main.java`:**

```java
public class Main {
    public static void main(String args[]) {
        System.out.println("Hello, GraalVM Native!");
    }
}
```

**In `BUILD.bazel`:**

```starlark
load("@rules_java//java:defs.bzl", "java_library")
load("@rules_graalvm//graalvm:defs.bzl", "native_image")

java_library(
    name = "main",
    srcs = ["Main.java"],
)

native_image(
    name = "native",
    deps = [":main"],
    main_class = "Main",
)
```

Then, from your terminal:

```
bazel build //some/package:native
```

### Configuration directories

Use `configuration_file_directories` for Native Image's directory-format metadata (including
`reachability-metadata.json`). Each label must resolve to a directory TreeArtifact or files sharing
one parent directory. `native_image` declares all of those files as action inputs and derives a
deterministic execution-root-relative `-H:ConfigurationFileDirectories=` argument; labels are never
expanded through `extra_args`.

```starlark
filegroup(
    name = "native_image_configuration",
    srcs = ["native-image/reachability-metadata.json"],
)

native_image(
    name = "native",
    deps = [":main"],
    main_class = "Main",
    configuration_file_directories = [":native_image_configuration"],
)
```
