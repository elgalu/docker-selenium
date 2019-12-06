#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
# set -u: treat unset variables as an error and exit immediately
set -e
set -u

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

[ -z "${VNC_CLIENT}" ] && die "Need env var VNC_CLIENT"
[ -z "${COMPOSE_PROJ_NAME}" ] && die "Need env var COMPOSE_PROJ_NAME"
[ -z "${browser}" ] && die "Need env var browser"
[ -z "${node}" ] && die "Need env var node"

# Gather actual container name as hard-coding it is unreliable
CONT_NAME=$(docker ps --filter status=running --filter "name=${COMPOSE_PROJ_NAME}_${browser}_${node}" --format "{{.Names}}" -q)
IP=`docker inspect -f='{{.NetworkSettings.IPAddress}}' ${CONT_NAME}`

if [ "${IP}" == "" ]; then
  IP=`docker inspect -f='{{json .NetworkSettings.Networks.grid_default}}' ${CONT_NAME} | jq .IPAddress -r`
fi

if [ "${IP}" == "" ]; then
  die "Failed to grab IP for container ${CONT_NAME}"
fi

# We need a fixed port range to expose VNC
PORT=$(docker exec ${CONT_NAME} cat VNC_PORT)
# if [ "$(uname)" = 'Darwin' ]; then
#   # due to a bug in Docker for Mac beta (1.12)
#   # https://forums.docker.com/t/docker-for-mac-beta-not-forwarding-ports/8658/6
#   IP="localhost"
# fi

if [ "$(uname)" != 'Darwin' ]; then
  OPTS="-GrabKeyboard=0"
else
  OPTS=""
fi

# set -x: print each command right before it is executed
set -x

"${VNC_CLIENT}" -WarnUnencrypted=0 -SendKeyEvents=0 SendPointerEvents=0 -Scaling=${SIZE} ${OPTS} ${IP}:${PORT}
