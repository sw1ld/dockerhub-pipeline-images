#!/bin/bash

docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -t

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" nginx -t
