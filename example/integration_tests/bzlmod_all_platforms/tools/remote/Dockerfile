FROM ubuntu:22.04 AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/tracemachina/nativelink:v0.5.3 /bin/nativelink /usr/local/bin/nativelink

ENTRYPOINT ["nativelink"]
