#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }" ; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# Required params
[ -z "$1" ] && die "Need 1st argument: CONTAINER_ID"
CONTAINER_ID=${1}

echo -n "Waiting for docker-selenium to be ready..."
while ! docker exec ${CONTAINER_ID} \
    grep 'Container docker internal IP' /var/log/cont/xterm-stdout.log \
    > /dev/null 2>&1; do
  echo -n '.'
  sleep 0.2;
done
