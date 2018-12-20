#!/bin/bash

echo "---" > docker-compose.yml
echo "version: '3'" >> docker-compose.yml
echo "services:" >> docker-compose.yml

for FILE in */Dockerfile */*/Dockerfile */*/*/Dockerfile; do
  BASENAME=${FILE%/Dockerfile}
  if [[ "$FILE" == */*/*/Dockerfile ]]; then
    # $1/$2/$3 -> adorsys/$1:$3-$2
    IMAGE="adorsys/$(echo "${BASENAME}" | cut -d/ -f1):$(echo "${BASENAME}" | cut -d/ -f3)-$(echo "${BASENAME}" | cut -d/ -f2)"
  else
    # $1/$2 -> adorsys/$1:$2
    IMAGE="adorsys/${BASENAME/\//:}"
  fi
  echo "  ${BASENAME//[\/-]/_}:" >> docker-compose.yml
  echo "    image: ${IMAGE}" >> docker-compose.yml
  echo "    build:" >> docker-compose.yml
  echo "      context: ${BASENAME}" >> docker-compose.yml
done
