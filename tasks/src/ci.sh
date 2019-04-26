#!/usr/bin/env bash

# --- begin bash runfile prelude --
if [[ -e "${TEST_SRCDIR:-}" ]]; then
    function runfile() {
        echo "$TEST_SRCDIR/$1"
    }
elif [[ -f "$0.runfiles_manifest" ]]; then
    __runfiles_manifest_file="$0.runfiles_manifest"
    export __runfiles_manifest_file
    function runfile() {
        grep -m1 "^$1 " "$__runfiles_manifest_file" | cut -d ' ' -f 2-
    }
else
    echo "please run this script through bazel"
    exit 1
fi
export -f runfile
# --- end bash runfile prelude --

set -euox pipefail
cd "${BUILD_WORKSPACE_DIRECTORY:-$(dirname "$0")/..}"

bazel=./tools/bazel
$bazel test //...
$bazel run  //example:main-native | grep Hello