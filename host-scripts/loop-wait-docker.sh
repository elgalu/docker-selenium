#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&2;
}

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

echo -n "Waiting for docker-selenium to finish starting..."
while ! docker exec ${CONTAINER_ID} \
    grep 'all done and ready for testing' /var/log/sele/xterm-stdout.log \
    > /dev/null 2>&1; do
  echo -n '.'
  sleep 0.2;
done
