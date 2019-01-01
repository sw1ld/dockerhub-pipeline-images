#!/bin/sh

docker run --rm "${DOCKER_IMAGE}:${TAG}" java --version
docker run --rm "${DOCKER_IMAGE}:${TAG}" ldd /lib/libtcnative-1.so

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
