#!/bin/env bash

set -eo pipefail

directory="$1";

echo "Running integration test \"$directory\"...";
cd "$directory";

function run_build() {
    bazelisk clean --expunge && bazelisk build //sample;
}

{
    run_build;
    echo "Test completed. Cleaning up...";
    bazelisk clean --expunge;
    echo "Integration test passed.";
    echo "";
    exit 0;
} || {
    echo "Test failed. See output for error.";
    bazelisk clean --expunge;
    echo "Integration test failure.";
    echo "";
    exit 1;
}
