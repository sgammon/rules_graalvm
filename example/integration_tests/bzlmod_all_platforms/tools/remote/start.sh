#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="nativelink-ubuntu:local"

usage() {
    echo "Usage: $0 [x86|arm]"
    echo ""
    echo "Starts a NativeLink remote executor in Docker for the given architecture."
    echo "  x86  -> linux/amd64 on port 50051"
    echo "  arm  -> linux/arm64 on port 50052"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    x86)
        PLATFORM="linux/amd64"
        PORT=50051
        CONTAINER="graalvm-remote-x86"
        ;;
    arm)
        PLATFORM="linux/arm64"
        PORT=50052
        CONTAINER="graalvm-remote-arm"
        ;;
    *)
        usage
        ;;
esac

if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "${CONTAINER} is already running on port ${PORT}"
    exit 0
fi

docker rm -f "${CONTAINER}" 2>/dev/null || true

echo "Building executor image..."
docker build --platform "${PLATFORM}" -t "${IMAGE}" "${SCRIPT_DIR}" 2>&1 | tail -3

echo "Starting ${CONTAINER} (${PLATFORM}) on port ${PORT}..."
docker run -d \
    --name "${CONTAINER}" \
    --platform "${PLATFORM}" \
    -p "${PORT}:50051" \
    -v "${SCRIPT_DIR}/nativelink.json:/config.json:ro" \
    "${IMAGE}" \
    /config.json

echo "Waiting for gRPC endpoint..."
for i in $(seq 1 10); do
    if docker logs "${CONTAINER}" 2>&1 | grep -q "Ready"; then
        break
    fi
    sleep 1
done

echo ""
echo "Remote executor ready:"
echo "  Container:  ${CONTAINER}"
echo "  Platform:   ${PLATFORM}"
echo "  Endpoint:   grpc://localhost:${PORT}"
echo ""
echo "Usage: bazel build --config=remote-linux-$([ "$1" = "x86" ] && echo "x86" || echo "arm") //..."
