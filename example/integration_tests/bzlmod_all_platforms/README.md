# Testing GraalVM platform support #

End-to-end check that `gvm.graalvm(register_all = True)` registers both the
**GraalVM JDK** and **native-image** toolchains for every supported exec/target
platform — verified by running a `java_binary` and a `native_image` of the same
class on remote linux/amd64 and linux/arm64 executors. The `.bazelrc` pins
`--java_runtime_version=graalvm_21` so the `java_binary` resolves to GraalVM.

> **Requires a host capable of running Docker containers for a different OS and/or arch.**
> For example, an Apple Silicon (aarch64) Mac with Docker Desktop can run both
> `linux/amd64` (via QEMU emulation) and `linux/arm64` containers natively. 

## Starting a remote executor

`tools/remote/start.sh` builds a NativeLink container for the requested architecture
and exposes a gRPC endpoint on a fixed port:

```sh
# linux/amd64 on grpc://localhost:50051
./tools/remote/start.sh x86

# linux/arm64 on grpc://localhost:50052
./tools/remote/start.sh arm
```

You can run one or both. The `--config` flags below assume the matching executor is up.

## Running the tests

Two targets exercise the same `Main` class — one as a regular `java_binary`, one as a
GraalVM `native_image`:

| Target | Config | Where it runs |
| --- | --- | --- |
| `//sample:main_test` | none | host toolchain (your machine) |
| `//sample:main_test` | `--config=remote-linux-x86` | linux/amd64 remote |
| `//sample:main_test` | `--config=remote-linux-arm` | linux/arm64 remote |
| `//sample:main-native_test` | none | host toolchain (your machine) |
| `//sample:main-native_test` | `--config=remote-linux-x86` | linux/amd64 remote |
| `//sample:main-native_test` | `--config=remote-linux-arm` | linux/arm64 remote |

```sh
# host toolchain — proves the registered toolchains pick up your local platform
bazel test //sample:main_test //sample:main-native_test --test_output=all

# remote linux/amd64
bazel test --config=remote-linux-x86 //sample:main_test //sample:main-native_test --test_output=all

# remote linux/arm64
bazel test --config=remote-linux-arm //sample:main_test //sample:main-native_test --test_output=all
```

Each test prints a single line identifying the VM and platform it ran on, e.g.:

```
Hello, GraalVM Community Substrate VM (21.0.2+13) — Linux aarch64
```
