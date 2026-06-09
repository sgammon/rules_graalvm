#!/usr/bin/env bash
# Asserts that the SDK files surfaced by the resolved GraalVM toolchain all come from a single
# SDK repo (no host/target mix), and — when a second argument is given — that it is the expected
# platform repo. Argument 1 is the probe's `*.paths.txt`; argument 2 (optional) is the expected
# repo token, e.g. `graalvm_linux_x64` for a cross/RBE build or `graalvm` for a host build.
set -euo pipefail

paths_file="$1"
expect="${2:-}"

if [ ! -s "$paths_file" ]; then
  echo "FAIL: probe output is missing or empty: $paths_file"
  exit 1
fi

# Each SDK path lives under its repo dir, e.g. `.../+graalvm+graalvm_linux_x64/lib/...` (Bzlmod)
# or `.../graalvm_linux_x64/lib/...`. Capture the repo token immediately preceding `/lib`.
repos="$(grep -oE '(graalvm_(linux|macos|windows)_(x64|aarch64|amd64)|graalvm)/lib' "$paths_file" | sed 's#/lib$##' | sort -u)"
count="$(printf '%s\n' "$repos" | sed '/^$/d' | wc -l | tr -d ' ')"

echo "SDK repo(s) feeding the resolved toolchain: ${repos:-<none>}"

if [ "$count" != "1" ]; then
  echo "FAIL: SDK files span multiple repos — host/target file selection is inconsistent."
  exit 1
fi

if [ -n "$expect" ] && ! printf '%s\n' "$repos" | grep -qx "$expect"; then
  echo "FAIL: expected SDK repo '$expect' but the toolchain selected '$repos'."
  exit 1
fi

echo "PASS: all probed SDK files originate from a single repo${expect:+ ($expect)}."
