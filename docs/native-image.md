## Building GraalVM native images with Bazel

After you [install the rules](./modern-bazel.md) and setup your GraalVM repository, you can easily use it to build a native image using the `native-image` tool, from a standard Bazel `java_library` or `java_binary` target.

### Native image example

> [!NOTE]  
> This sample is present in the `rules_graalvm` repository at `example/native`.

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
