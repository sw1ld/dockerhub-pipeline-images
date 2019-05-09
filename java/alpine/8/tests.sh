#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" java -version

docker run --rm -eSPRING_MAIN_BANNER-MODE=off -v "$PWD/../../.tests/target/dockerhub-pipeline-images-test-jar.jar":/opt/app-root/src/app.jar "${DOCKER_IMAGE}:${TAG}"

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
