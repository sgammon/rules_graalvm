## GraalVM Rules for Bazel: Contribution Guide

This codebase is a conventional Bazel 6 or Bazel 7 codebase, with support for [Bzlmod](https://docs.bazel.build/versions/5.0.0/bzlmod.html). To use it, you build and test from [Bazel](https://bazel.build).

### Primer: Running Bazel Builds

You will need a Bazel installation; you could install [Bazel](https://github.com/bazelbuild/bazel/releases) directly, but the best way to do this usually involves a wrapper which manages versions for you.

There are several good Bazel wrappers. In order of preference for this project (but it's up to you):

- **Aspect CLI**: [Aspect.dev](https://aspect.dev) makes a fantastic CLI and Bazel wrapper. You can install it [here][1].
- **[Bazelisk](https://github.com/bazelbuild/bazelisk):** The beloved open-source canonical wrapper for Bazel. You can download it [here][2].

Both of these clients use the `.bazelversion` file to determine what version of Bazel to run. On this project, it's a version of Bazel 7, usually. You can check the current Bazel version with:

```
➜  rules_graalvm git:(main) cat .bazelversion

7.0.0
```

Once you have Aspect, Bazelisk, or _that exact Bazel binary version_ installed and ready to go, you can proceed.

## Running builds

On this project, you can build with Bazel directly (using the wrappers, etc), or you can use the `Makefile`. They are functionally equivalent, but the `Makefile` conveniently applies various configurations for you, if you want.

### Using the `Makefile`

Run `make help` to see available tasks, as the `Makeile` is self-documenting:

```
➜  rules_graalvm git:(main) make help

GraalVM Rules for Bazel:
args                           Show current build args.
build                          Build all targets.
clean                          Clean built targets.
config                         Show current build configuration.
distclean                      Clean and expunge; drops all state and kills worker.
docs                           Build docs.
forceclean                     Clean, expunge, reset, and drop all ignored files (DANGEROUS).
help                           Show this help message.
lint-format                    Run the lint formatter.
lint                           Run the lint checker.
reset                          Clean, expunge, and perform a hard Git reset (DANGEROUS).
test                           Run all tests.
yamllint                       Run yamllint.
```

There are some top-level build variables which configure the `Makefile` (defaults listed):

```
CI ?= no          # Turns on CI build settings.
DEBUG ?= no       # Turns on `verbose_failures`, `sandbox_debug`, etc.
RELEASE ?= no     # Builds in release (optimized) mode.
VERBOSE ?= no     # Emits commands and applies `verbose_failures`.
BZLMOD ?= no      # Builds with `bzlmod` turned on.
COVERAGE ?= yes   # Whether to test with the `coverage` command instead.
TARGETS ?= //...  # Targets to build via `make build`.
TESTS ?= //...    # Tests to run via `make test`.
ARGS ?=           # Additional Bazel arguments to pass.
CONFIGS ?=        # Additional Bazel `--config=` names to pass.
```

Checking the current build configuration with the `Makefile`:

```
➜  rules_graalvm git:(main) make config

Current configuration:
CI: no
Bzlmod: yes
Debug: no
Release: no
Verbose: no
Coverage: yes
Test task: coverage
Configs: bzlmod
Targets: //...
Tests: //...
Args:
 --config=fastbuild
```

As you can see, the `Makefile` has decided to apply the `fastbuild` config based on having no other inputs (it's the default in Bazel too). Let's see what passing `RELEASE=yes` does:

```
➜  rules_graalvm git:(main) make config RELEASE=yes

Current configuration:
CI: no
Bzlmod: no
Debug: no
Release: yes
Verbose: no
Coverage: yes
Test task: coverage
Configs: bzlmod
Targets: //...
Tests: //...
Args:
 --config=release
```

Makes sense, checks out. You can pass these `Args` and `Targets` yourself directly to Bazel if you want, which is all the `Makefile` will do anyway.

### Using Bazel

To build directly using Bazel, it's pretty easy:

```
bazel build //...
```

To run tests:

```
bazel test //...
```

### Configuring Bazel with local settings

The Bazel build will look for a user configuration at `local.bazelrc` at the root of the codebase. You can use this file to apply Bazel settings within the scope of only your user.

This is the best way to configure things like [Buildless](https://less.build) and [BuildBuddy](https://buildbuddy.io), both of which we use on this project. You can use them if you want.

There is a sample configuration at `local.bazelrc.inert`. You can use it like this:

```
cp local.bazelrc.inert local.bazelrc
# now edit it lol
```

You will want to add your own API keys, of course. The default configuration is sufficient from there. If you want to, say, enable Bzlmod locally for all your builds, you can add:

```
build --config=bzlmod
```

And so on.

[1]: https://www.aspect.build/cli
[2]: https://github.com/bazelbuild/bazelisk/releases
