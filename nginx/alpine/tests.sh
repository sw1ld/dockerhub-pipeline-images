#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -V
docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -t
docker run -eNGINX_DISABLE_ACCESS_LOG=true --rm "${DOCKER_IMAGE}:${TAG}" nginx -t

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" nginx -t

# Test /docker-entrypoint.d/*.sh
docker run --rm -v "$PWD/../../.tests/test-docker-entrypoint.d.sh":/docker-entrypoint.d/test.sh "${DOCKER_IMAGE}:${TAG}" nginx -t | grep "TEST-ENTRYPOINT-HOOK-WORKS!"

