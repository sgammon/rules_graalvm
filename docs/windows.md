## Using GraalVM + Bazel on Windows

To use Bazel and GraalVM on Windows, you will need the following software and environment.

#### Software

- Bazel or [Bazelisk][1] installed, of course
- [Visual Studio 2022+][2], version `17.1.0` or later

#### Environment

As documented in the [Using Bazel on Windows][4] guide, you may need the [required environment variables for MSVC][5] to make Bazel aware of Visual Studio.

The `native-image` tool additionally uses the `INCLUDE` and `LIB` variables to resolve key system libraries.

> **Note**
> You don't actually need Bazel to work with Visual Studio to build `native-image` targets, so long as `cl.exe` and related tools are on the `PATH`. Read more in the [hermeticity guide](./hermeticity.md).

### Relevant documentation

- [GraalVM's guide for installation on Windows][3]
- [Using Bazel on Windows][4]

## Version support matrix

> **Note**
> This version table doesn't make sense at first glance. **That's because GraalVM underwent a version scheme change**
> after the `22.3.2` release; at this point, releases began following OpenJDK releases, so `17.0.7` and `20.0.1` are
> _actually newer_ than `22.3.2`. `17.0.7` is a JDK17 release, while `20.0.1` is a JDK20 release (in this example). The
> GraalVM Rules for Bazel support both schemes.

| GraalVM version     | Bazel version | `rules_graalvm` | Windows | Notes                                 |
| ------------------- | ------------- | --------------- | ------- | ------------------------------------- |
| `17.0.7+`/`20.0.1+` | Bazel 7+      | `0.10.0+`       | ✅      | See [modern Bazel][6]                 |
| `17.0.7+`/`20.0.1+` | Bazel 7+      | `0.9.0`         | ⚠️      | Known issues                          |
| `17.0.7+`/`20.0.1+` | Bazel 6.x     | `0.10.0+`       | ✅      | See [modern Bazel][6]                 |
| `17.0.7+`/`20.0.1+` | Bazel 5.x     | No support      | ✖️      | See [legacy Bazel][7]                 |
| Earlier releases    | Bazel 4+      | No support      | ✖️      | See [legacy Bazel](./legacy-bazel.md) |
| Earlier releases    | Bazel 3.x     | No support      | ✖️      | Use [`rules_graal`][1]                |

> See [use from modern Bazel][6] for the full version support matrix.

[1]: https://github.com/bazelbuild/bazelisk
[2]: https://visualstudio.microsoft.com/downloads/
[3]: https://www.graalvm.org/latest/docs/getting-started/windows/
[4]: https://bazel.build/configure/windows
[5]: https://bazel.build/configure/windows#build_cpp
[6]: ./modern-bazel.md
[7]: ./legacy-bazel.md
