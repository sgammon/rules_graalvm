## How Bazel settings integrate with Native Image

Several familiar Bazel settings are integrated into the Native Image build pipeline, so that conventional use of Bazel
features translates relatively well to Native Image option control. See the table below for more information.

### Compilation mode

> Flag: [`--compilation_mode`][1] or [`-c`][1]

| **Flag setting** | **Effective `native-image` options** | **Notes**                                  |
| ---------------- | ------------------------------------ | ------------------------------------------ |
| `dbg`            | `-g`                                 | No optimization flag set                   |
| `fastbuild`      | `-Ob`                                | Activates GraalVM [fast build][2] mode     |
| `opt`            | `-O2`                                | Builds with optimizations turned on        |
| (None set)       | (Nothing passed)                     | Default GraalVM behavior builds with `-O2` |

By default, `optimization_mode` follows `--compilation_mode` as shown above. To pick a level for one target,
set `optimization_mode` on it:

| **`optimization_mode`** | **Effective `native-image` option** | **Notes**                                    |
| ----------------------- | ----------------------------------- | -------------------------------------------- |
| `"0"`                   | `-O0`                               | No optimizations                             |
| `"b"`                   | `-Ob`                               | Quick build mode                             |
| `"s"`                   | `-Os`                               | Optimize for size                            |
| `"1"`                   | `-O1`                               | Basic optimizations                          |
| `"2"`                   | `-O2`                               | Advanced optimizations (GraalVM default)     |
| `"3"`                   | `-O3`                               | All optimizations for best performance       |
| `""`                    | (Nothing passed)                    | GraalVM default (`-O2`)                      |

See the GraalVM docs on [optimization levels][3] for details.

[1]: https://bazel.build/docs/user-manual#compilation-mode
[2]: https://www.graalvm.org/latest/reference-manual/native-image/overview/BuildOutput/#build-stages
[3]: https://www.graalvm.org/latest/reference-manual/native-image/optimizations-and-performance/#optimization-levels
