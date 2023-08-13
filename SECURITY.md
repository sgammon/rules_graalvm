# Security Policy

The `rules_graalvm` package has a very small surface area of possible vulnerability; while it does perform downloads (within the scope of Bazel's protections and tools), all downloaded material
is hashed, fingerprinted, and checked.

Downloaded components by GraalVM's `gu` tool cannot be checked, but GraalVM provides their own security assurances for these packages. The `rules_graalvm` package is only meant to be used at build-time
in a developer's Bazel workspace.

## Supported Versions

All versions of this package are supported as of the `v0.9.0` release.

| Version | Supported          |
| ------- | ------------------ |
| 0.9.0+  | :white_check_mark: Yep |
| `rules_graal` | :x: Deprecated |

## Reporting a Vulnerability

To report a vulnerability, use the [GitHub Issues](https://github.com/sgammon/rules_graalvm/issues) tracker. If you need to report a vulnerability privately, please send an email to the author. You can
@sgammon's contact information in commits and elsewhere.
