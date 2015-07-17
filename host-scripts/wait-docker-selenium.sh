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

# if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "7s"
WAIT_TIMEOUT=${2-7s}

# Full directory name of the script no matter where it is being called from
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOOP_SCRIPT_PATH="${DIR}/loop-wait-docker.sh"

if [ ! -f "${LOOP_SCRIPT_PATH}" ]; then
  die "Need '${LOOP_SCRIPT_PATH}' to exist!"
fi

# Avoid waiting forever using the `timeout` command
timeout --foreground ${WAIT_TIMEOUT} \
  ${LOOP_SCRIPT_PATH} ${CONTAINER_ID} || die \
  "
   Your docker-selenium didn't start properly.
   Start it next time with -e DISABLE_ROLLBACK=true"

echo ""
docker exec ${CONTAINER_ID} grep 'IP:' /var/log/sele/xterm-stdout.log
docker exec ${CONTAINER_ID} grep 'password' /var/log/sele/vnc-stdout.log
