#!/usr/bin/env bash
set -euo pipefail

bazel_command="${RULES_GRAALVM_BAZEL_COMMAND:-bazelisk}"

readonly_home="$(mktemp -d)"
cleanup() {
    chmod u+w "$readonly_home" 2>/dev/null || true
    rmdir "$readonly_home" 2>/dev/null || true
}
trap cleanup EXIT

# Graal's builder must not need a writable home: relocate_polyglot_cache routes the only
# known Truffle builder cache to the declared intermediate TreeArtifact. Git Bash on Windows
# does not provide POSIX directory permissions, so retain a normal temporary HOME there while
# still verifying the action contract below.
if [[ "$(uname -s)" != MINGW* ]]; then
    chmod u-w "$readonly_home"
fi

env -u GRAALVM_HOME -u JAVA_HOME "$bazel_command" clean --expunge
env -u GRAALVM_HOME -u JAVA_HOME \
    "$bazel_command" build --action_env=HOME="$readonly_home" //sample

action="$(env -u GRAALVM_HOME -u JAVA_HOME \
    "$bazel_command" aquery --action_env=HOME="$readonly_home" \
        'mnemonic("NativeImage", //sample:main-native)' --output=text)"

require() {
    if ! grep -Fq -- "$1" <<<"$action"; then
        echo "Expected NativeImage aquery output to contain: $1" >&2
        exit 1
    fi
}

reject() {
    if grep -Fq -- "$1" <<<"$action"; then
        echo "NativeImage aquery output unexpectedly contains: $1" >&2
        exit 1
    fi
}

require "sample/configuration/reflect-config.json"
require "-H:ConfigurationFileDirectories=sample/configuration"
require "main-native.ni_tmp/polyglot-resources"
require "main-native_cc_deps/libnative_support.a"
require "external/rules_graalvm++graalvm"
require "cc_wrapper.sh"
require "HOME=$readonly_home"
reject "GRAALVM_HOME"
reject "ConfigurationFileDirectories=/"
reject "ConfigurationFileDirectories=../"
reject ".cache/org.graalvm.polyglot"

# Test-only seam used by the repository check below: prove CI's runner does not merely build the
# image and skip the aquery contract.
if [[ "${RULES_GRAALVM_ASSERT_AQUERY_REGRESSION:-}" == "1" ]]; then
    require "__intentionally_missing_native_image_aquery_input__"
fi
