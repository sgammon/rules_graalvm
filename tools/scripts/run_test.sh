#!/bin/env bash

set -eo pipefail

directory="$1";

echo "Running integration test \"$directory\"...";
cd "$directory";

function run_build() {
    bazelisk clean --expunge && bazelisk build //sample;
}

if [[ -x "./integration_test.sh" ]]; then
    if ! ./integration_test.sh; then
        echo "Test failed. See output for error.";
        bazelisk clean --expunge;
        echo "";
        exit 1;
    fi
elif ! run_build; then
    echo "Test failed. See output for error.";
    bazelisk clean --expunge;
    echo "";
    exit 1;
fi

echo "Test completed. Cleaning up...";
bazelisk clean --expunge;
echo "";
