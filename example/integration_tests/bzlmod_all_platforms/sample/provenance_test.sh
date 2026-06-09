#!/usr/bin/env bash
# Checks the SDK files surfaced by the resolved GraalVM toolchain.
#
#   provenance_test.sh PATHS_FILE [EXPECTED_REPO] [REQUIRED_CSV]
#
#   PATHS_FILE     the probe's `*.paths.txt`
#   EXPECTED_REPO  (optional) the SDK repo the files must come from, e.g. `graalvm_linux_x64`
#                  for a cross/RBE build or `graalvm` for a host build. Empty to skip.
#   REQUIRED_CSV   (optional) comma-separated archive basenames that must all be present, e.g.
#                  `libjvm,liblibchelper,libffi` — guards against missing SVM link inputs, which a
#                  pure origin check would not catch.
#
# Asserts (1) all SDK files come from a single repo (no host/target mix), (2) it matches
# EXPECTED_REPO when given, and (3) every REQUIRED_CSV archive is present.
set -euo pipefail

paths_file="$1"
expect="${2:-}"
required="${3:-}"

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

if [ -n "$required" ]; then
  IFS=',' read -ra names <<< "$required"
  for name in "${names[@]}"; do
    if ! grep -q "/${name}\.a\$" "$paths_file"; then
      echo "FAIL: required static archive '${name}.a' is not in the bundled SDK files."
      exit 1
    fi
  done
  echo "present: $required"
fi

echo "PASS: single-repo${expect:+ ($expect)}${required:+, required archives present}."
