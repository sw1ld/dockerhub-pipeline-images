#!/bin/bash

set -e
echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USER}" --password-stdin
echo push to "${DOCKER_IMAGE}:${TAG}"
docker push "${DOCKER_IMAGE}:${TAG}"
if [ -n ${ALIAS+x} ]; then
  echo "Pushing tag aliases '${ALIAS}'"
  for ALIAS_TAG in ${ALIAS}; do
    echo Push to "${DOCKER_IMAGE}:${ALIAS_TAG}"
    docker tag "${DOCKER_IMAGE}:${TAG}" "${DOCKER_IMAGE}:${ALIAS_TAG}"
    docker push "${DOCKER_IMAGE}:${ALIAS_TAG}"
  done
fi