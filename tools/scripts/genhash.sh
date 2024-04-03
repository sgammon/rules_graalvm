#!/bin/bash

set -e
set -o pipefail

# Usage:
# ./tools/scripts/genhash.sh https://...

curl --fail -L --progress-bar "$@" | gsha256sum

