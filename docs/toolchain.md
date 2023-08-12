
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

#### Assigning GraalVM as the tooling toolchain

Set **`java_runtime_version`** to the version matching your GraalVM JDK declared in `graalvm_repository`.

**In a `bazel.rc`:**
```
build --java_language_version=20
build --java_runtime_version=graalvm_20
```
