#!/bin/bash

set -euo pipefail

dgoss run \
  -u 1000090000:0 \
  -e SPRING_MAIN_BANNER-MODE=off \
  -v "$(git rev-parse --show-toplevel)/.tests/test-docker-entrypoint.d.sh":/docker-entrypoint.d/test.sh \
  -v "$(git rev-parse --show-toplevel)/.tests/java/example-app/target/dockerhub-pipeline-images-test-jar.jar":/opt/app-root/src/app.jar \
  "${DOCKER_IMAGE}:${TAG}" \
  sleep inf
