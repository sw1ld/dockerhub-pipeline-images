#!/bin/sh

# From https://docs.openshift.com/container-platform/3.9/creating_images/guidelines.html#use-uid
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# envsubst

exec "$@"