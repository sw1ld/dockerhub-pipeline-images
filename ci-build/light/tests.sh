#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash --version

docker run --rm "${DOCKER_IMAGE}:${TAG}" docker --version
docker run --rm "${DOCKER_IMAGE}:${TAG}" java -version
docker run --rm "${DOCKER_IMAGE}:${TAG}" mvn --version

# Default should be java 8
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'java -version 2>&1 | grep -q "build 1\.8"'

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'jabba use system@1.8 && java -version 2>&1 | grep -q "build 1\.8"'
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'jabba use system@1.11 && java -version 2>&1 | grep -q "build 11"'

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 10 node --version | grep -q "node v10"'
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 12 node --version | grep -q "node v12"'

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 10 node --version'
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 12 node --version'

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 10 npm --version'
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 12 npm --version'

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 10 yarn --version'
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'nvm exec 12 yarn --version'


chmod -R 777 "$PWD/../../java/.tests/"
docker run --rm -v "$PWD/../../java/.tests/":/opt/app-root/src "${DOCKER_IMAGE}:${TAG}" mvn -q --batch-mode clean package
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'npm install iconv'
