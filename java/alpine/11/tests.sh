#!/bin/sh

docker run --rm ${DOCKER_IMAGE}:${TAG} java --version
docker run --rm ${DOCKER_IMAGE}:${TAG} ldd /lib/libtcnative-1.so
