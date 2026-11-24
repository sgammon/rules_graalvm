#!/usr/bin/env bash
set -euo pipefail
out="${TEST_TMPDIR:-/tmp}/shared_consumer.out"
"$@" | tee "$out"
grep -q "hello from native-image" "$out"
