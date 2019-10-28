#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" node --version
docker run --rm "${DOCKER_IMAGE}:${TAG}" npm --version

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami

# Test /docker-entrypoint.d/*.sh
docker run --rm -v "$(git rev-parse --show-toplevel)/.tests/test-docker-entrypoint.d.sh":/docker-entrypoint.d/test.sh "${DOCKER_IMAGE}:${TAG}" node --version | grep "TEST-ENTRYPOINT-HOOK-WORKS!"

# Test Memory autconfig
docker run -m 128M --rm "${DOCKER_IMAGE}:${TAG}" env | grep NODE_OPTIONS=--max_old_space_size=107
docker run -e NODE_MEMORY_LIMIT_PERCENT=50 -m 128MB --rm "${DOCKER_IMAGE}:${TAG}" env | grep NODE_OPTIONS=--max_old_space_size=67
