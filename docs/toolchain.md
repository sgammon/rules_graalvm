## Using GraalVM as a toolchain with Bazel

> [!NOTE]  
> Bazel toolchains can be hard to use. See the _Troubleshooting_ section for best-effort help.

[Bazel Toolchains](https://bazel.build/extending/toolchains) is an optional feature which helps Bazel resolve tools on different platforms and in different project contexts. Several Bazel rule sets use toolchains in order to make the underlying tooling customizable for an end-user's goals.

Java toolchains in Bazel are typically used to select a particular JDK to run against or build against. `rules_graalvm` integrates with Bazel toolchains by default; **if you want to use a downloaded GVM installation as your Java toolchain, follow the directions below.**

### Toolchain registration

> [!IMPORTANT]  
> Make sure you've [installed and setup the rules](./modern-bazel.md) first.

After you've installed `rules_graalvm` and declared a `graalvm_repository`, you can register GraalVM as a Java toolchain using the `:all` target at the repository root:

**In your `WORKSPACE.bazel`:**

```starlark
# ...

# graalvm_repository(name = "graalvm", ...)

register_toolchains("@graalvm//:toolchain")
```

**Or, in a `bazel.rc`:**

```
build --extra_toolchains=@graalvm//:toolchain
```

### Toolchain selection

> [!IMPORTANT]  
> You need to **register** _and_ **select** a toolchain in order to actually use it. This sample assumes the `graalvm_repository` is named `graalvm`.

Bazel uses several JDKs throughout the course of a regular build; there is the embedded JDK which runs Bazel itself, then the _tooling_ JDK which is used to build your code, and, finally, there is the _runtime_ JDK which is used to execute JVM bytecode. This is referred to as Bazel's "[JVM sandwich](https://github.com/bazelbuild/bazel/issues/2614)."

You can select GraalVM as the **tooling toolchain**, the **runtime toolchain**, or **both**:

#### Assigning GraalVM as the tooling toolchain

Set **`tool_java_language_version`** to the version matching your GraalVM JDK declared in `graalvm_repository`.

**In a `bazel.rc`:**

```
build --tool_java_language_version=20
build --extra_toolchains=@graalvm//:bootstrap_runtime_toolchain
```

#### Assigning GraalVM as the runtime toolchain

Set **`java_runtime_version`** to the version matching your GraalVM JDK declared in `graalvm_repository`.

**In a `bazel.rc`:**

```
build --java_language_version=20
build --java_runtime_version=graalvm_20
```

### Compiling for newer Java versions

Bazel compiles Java with a _compiler_ toolchain, separate from the runtime toolchains above. `rules_java` only defines
compilers for the Java versions it knows about (8 to 21, plus 25 in newer releases), so setting
`--java_language_version` to any other version fails with `No matching toolchains found for types
@bazel_tools//tools/jdk:toolchain_type`.

The GraalVM repository provides a compiler for its own Java version, which runs `javac` on the GraalVM JDK. Register it
alongside the runtime toolchain:

**In your `MODULE.bazel`:**

```starlark
register_toolchains("@graalvm//:jvm")
register_toolchains("@graalvm//:java_compiler")
```

**In a `bazel.rc`:**

```
build --java_language_version=25
build --java_runtime_version=graalvm_25
build --tool_java_language_version=25
build --tool_java_runtime_version=graalvm_25
```

The compiler only matches when `--java_language_version` equals the `java_version` of the GraalVM repository, so
registering it does not affect builds that target other Java versions. See `example/integration_tests/java-toolchain-25` for a complete sample.
