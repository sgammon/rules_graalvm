#!/usr/bin/env bash
set -euo pipefail
"$@" | tee /tmp/shared_consumer.out
grep -q "hello from native-image" /tmp/shared_consumer.out
