## GraalVM + Bazel Examples

This codebase embeds some examples which are used for integration testing. You can find these at:

```
example/integration_tests
```

The following table explains each example. These can be used as starters for various Bazel versions with the latest copy
of GraalVM CE.

### Available examples

All examples are continuously tested in CI.

| Path                      | Bazel version(s)        | Rule type   | OS support            | Notes                                                                   |
| ------------------------- | ----------------------- | ----------- | --------------------- | ----------------------------------------------------------------------- |
| [`bzlmod`][3]             | Bazel 5+ with Bzlmod    | [Modern][1] | Linux, macOS, Windows | Example Native Image build via Bzlmod                                   |
| [`workspace`][4]          | Bazel 4+ with WORKSPACE | [Modern][1] | Linux, macOS, Windows | Example Native Image build via Workspace                                |
| [`bazel4`][5]             | Bazel 4                 | [Legacy][2] | Linux, macOS          | Bazel 4 example project                                                 |
| [`bazel5`][6]             | Bazel 5                 | [Legacy][2] | Linux, macOS          | Bazel 5 example project                                                 |
| [`bazel6`][7]             | Bazel 6                 | [Modern][1] | Linux, macOS, Windows | Bazel 6 example project                                                 |
| [`graalvm-ce-17`][8]      | Bazel 7                 | [Modern][1] | Linux, macOS, Windows | Bazel 7 with GraalVM CE 17                                              |
| [`graalvm-ce-20`][9]      | Bazel 7                 | [Modern][1] | Linux, macOS, Windows | Bazel 7 with GraalVM CE 20                                              |
| [`graalvm-oracle-17`][10] | Bazel 7                 | [Modern][1] | Linux, macOS, Windows | Bazel 7 with Oracle GraalVM 17                                          |
| [`graalvm-oracle-20`][11] | Bazel 7                 | [Modern][1] | Linux, macOS, Windows | Bazel 7 with Oracle GraalVM 20                                          |
| [`legacy-gvm`][12]        | Bazel 7 with WORKSPACE  | [Modern][1] | Linux, macOS, Windows | Example **modern rules** with older GraalVM version (`22.1.0`, Java 11) |
| [`legacy-rules`][13]      | Bazel 4+ with WORKSPACE | [Legacy][2] | Linux, macOS          | Example **legacy rules** with older GraalVM version (`22.1.0`, Java 11) |

### Specific version notes

See below for use notes with specific versions of bazel.

#### Bazel 4

Bazel 4 only supports a maximum of `rules_java` at version `4.0.0`. See the `bazel4` example for a working starter. You'll need to add this to your `WORKSPACE.bazel`:

```python
http_archive(
    name = "rules_java",
    sha256 = "34b41ec683e67253043ab1a3d1e8b7c61e4e8edefbcad485381328c934d072fe",
    url = "https://github.com/bazelbuild/rules_java/releases/download/4.0.0/rules_java-4.0.0.tar.gz",
)
```

This either needs to come _before_ the `rules_graalvm_repositories` call (so that the repo is already defined and therefore overrides), or you need to pass `omit_rules_java` like so:

```python
load("@rules_graalvm//graalvm:workspace.bzl", "rules_graalvm_repositories")

rules_graalvm_repositories(omit_rules_java = True)
```

#### Bazel 5

Bazel 5 seems to have issues with the stricter build environment configurations offered by these rules. If you see issues with `DEVELOPER_DIR` on macOS, or issues resolving Visual Studio on Windows, you should try the [legacy rules](./legacy-bazel.md).

[1]: ./modern-bazel.md
[2]: ./legacy-bazel.md
[3]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bzlmod
[4]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/workspace
[5]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bazel4
[6]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bazel5
[7]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bazel6
[8]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/graalvm-ce-17
[9]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/graalvm-ce-20
[10]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/graalvm-oracle-17
[11]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/graalvm-oracle-20
[12]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/legacy-gvm
[13]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/legacy-rules
