#!/bin/bash
{
  echo "---"
  echo "version: '3'"
  echo "services:"

  for FILE in */Dockerfile */*/Dockerfile */*/*/Dockerfile; do
    BASENAME=${FILE%/Dockerfile}
    if [[ "$FILE" == */*/*/Dockerfile ]]; then
      # $1/$2/$3 -> adorsys/$1:$3-$2
      IMAGE="adorsys/$(echo "${BASENAME}" | cut -d/ -f1):$(echo "${BASENAME}" | cut -d/ -f3)-$(echo "${BASENAME}" | cut -d/ -f2)"
    else
      # $1/$2 -> adorsys/$1:$2
      IMAGE="adorsys/${BASENAME/\//:}"
    fi
    echo "  ${BASENAME//[\/-]/_}:"
    echo "    image: ${IMAGE}"
    echo "    build:"
    echo "      context: ${BASENAME}"
  done
} > docker-compose.yml
