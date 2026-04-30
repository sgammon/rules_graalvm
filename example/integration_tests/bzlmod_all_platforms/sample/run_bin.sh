#!/usr/bin/env bash
set -euo pipefail

BINARY="${1:?missing binary path}"
OUTPUT="$("$BINARY")"
echo "$OUTPUT"

case "$OUTPUT" in
    "Hello, "*) ;;
    *)
        echo "FAIL: expected output to start with 'Hello, ', got: $OUTPUT" >&2
        exit 1
        ;;
esac
