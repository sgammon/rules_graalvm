## GraalVM + Bazel Examples

This codebase embeds some examples which are used for integration testing. You can find these at:

```
example/integration_tests
```

The following table explains each example. These can be used as starters for various Bazel versions with the latest copy
of GraalVM CE.

### Available examples

All examples are continuously tested in CI.

| Path            | Bazel version(s)        | Rule type   | OS support            | Notes                                    |
| --------------- | ----------------------- | ----------- | --------------------- | ---------------------------------------- |
| [`bzlmod`][3]   | Bazel 5+ with Bzlmod    | [Modern][1] | Linux, macOS, Windows | Example Native Image build via Bzlmod    |
| [`workspace`[4] | Bazel 4+ with WORKSPACE | [Modern][1] | Linux, macOS, Windows | Example Native Image build via Workspace |
| [`bazel4`][5]   | Bazel 4                 | [Legacy][2] | Linux, macOS          | Bazel 4 example project                  |
| [`bazel5`][6]   | Bazel 5                 | [Modern][1] | Linux, macOS, Windows | Bazel 5 example project                  |
| [`bazel6`][7]   | Bazel 6                 | [Modern][1] | Linux, macOS, Windows | Bazel 6 example project                  |

[1]: ./modern-bazel.md
[2]: ./legacy-bazel.md
[3]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bzlmod
[4]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/workspace
[5]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bazel4
[6]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bazel5
[7]: https://github.com/sgammon/rules_graalvm/tree/main/example/integration_tests/bazel6
