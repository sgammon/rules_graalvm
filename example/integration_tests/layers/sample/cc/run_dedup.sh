#!/usr/bin/env bash
set -euo pipefail
out="${TEST_TMPDIR:-/tmp}/dedup.out"
"$@" | tee "$out"
grep -q "dedup_ok meaning=42 doubled=84" "$out"
