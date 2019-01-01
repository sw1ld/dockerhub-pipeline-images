#!/bin/bash

docker run --rm "${DOCKER_IMAGE}:${TAG}" test -f /clair
docker run --rm "${DOCKER_IMAGE}:${TAG}" test -f /config/config.yaml
docker run --rm "${DOCKER_IMAGE}:${TAG}" clair-scanner -h
docker run --rm "${DOCKER_IMAGE}:${TAG}" docker --version
