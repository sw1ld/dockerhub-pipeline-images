#!/bin/bash

set -xeuo pipefail

echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USER}" --password-stdin
echo "push to ${DOCKER_IMAGE}:${TAG}"
travis_retry docker push "${DOCKER_IMAGE}:${TAG}"

if [ -n "${ALIASES+x}" ]; then
  echo "Pushing tag aliases ${ALIASES}"
  docker tag "${DOCKER_IMAGE}:${TAG}" "${DOCKER_IMAGE}:${ALIASES}"
  travis_retry docker push "${DOCKER_IMAGE}:${ALIASES}"
fi

if [ -n "${SNAPSHOT+x}" ] && [ "$(date +%d)" -eq "1" ]; then
  echo "Pushing snapshot tag $(date +%Y%m)"
  docker tag "${DOCKER_IMAGE}:${TAG}" "${DOCKER_IMAGE}:$(date +%Y%m)"
  travis_retry docker push "${DOCKER_IMAGE}:$(date +%Y%m)"
fi
