#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -V
docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -t

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" nginx -t

# Test SCL entrypoint
docker run --name nginx-scl-test -d --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" /usr/libexec/s2i/run
docker exec nginx-scl-test curl -I -sSf http://localhost:8080/404.html
docker logs nginx-scl-test
docker rm -f nginx-scl-test


# Test /docker-entrypoint.d/*.sh
docker run --rm -v "$PWD/../../../.tests/test-docker-entrypoint.d.sh":/docker-entrypoint.d/test.sh "${DOCKER_IMAGE}:${TAG}" nginx -t | grep "TEST-ENTRYPOINT-HOOK-WORKS!"
