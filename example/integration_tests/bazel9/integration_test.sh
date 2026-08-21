#!/usr/bin/env bash
set -euo pipefail

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

env -u GRAALVM_HOME -u JAVA_HOME bazelisk clean --expunge
env -u GRAALVM_HOME -u JAVA_HOME \
    bazelisk build --action_env=HOME="$readonly_home" //sample

action="$(env -u GRAALVM_HOME -u JAVA_HOME \
    bazelisk aquery --action_env=HOME="$readonly_home" \
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
