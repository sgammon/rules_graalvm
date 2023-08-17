## Targets for binaries in GraalVM

For convenience, the GraalVM repository rule will create targets and aliases for major binaries which ship with GraalVM. You can use these out of the box.

**Binaries which are typically aliased, based on installed components:**

| Binary         | Target                        | Alias                     | Example                                |
| -------------- | ----------------------------- | ------------------------- | -------------------------------------- |
| `java`         | `@graalvm//:bin/java`         | `@graalvm`                | `bazel run -- @graalvm`                |
| `javac`        | `@graalvm//:bin/javac`        | `@graalvm//:javac`        | `bazel run -- @graalvm//:javac`        |
| `jar`          | `@graalvm//:bin/jar`          | `@graalvm//:jar`          | `bazel run -- @graalvm//:jar`          |
| `native-image` | `@graalvm//:bin/native-image` | `@graalvm//:native-image` | `bazel run -- @graalvm//:native-image` |
| `polyglot`     | `@graalvm//:bin/polyglot`     | `@graalvm//:polyglot`     | `bazel run -- @graalvm//:polyglot`     |
| `js`           | `@graalvm//:bin/js`           | `@graalvm//:js`           | `bazel run -- @graalvm//:js`           |
| `wasm`         | `@graalvm//:bin/wasm`         | `@graalvm//:wasm`         | `bazel run -- @graalvm//:wasm`         |
| `python`       | `@graalvm//:bin/python`       | `@graalvm//:python`       | `bazel run -- @graalvm//:python`       |
| `ruby`         | `@graalvm//:bin/ruby`         | `@graalvm//:ruby`         | `bazel run -- @graalvm//:ruby`         |
| `lli`          | `@graalvm//:bin/lli`          | `@graalvm//:lli`          | `bazel run -- @graalvm//:lli`          |

**Example:**

```
$ > b run -- @graalvm --version
# ...
java 20.0.2 2023-07-18
Java(TM) SE Runtime Environment Oracle GraalVM 20.0.2+9.1 (build 20.0.2+9-jvmci-23.0-b14)
Java HotSpot(TM) 64-Bit Server VM Oracle GraalVM 20.0.2+9.1 (build 20.0.2+9-jvmci-23.0-b14, mixed mode, sharing)
```
