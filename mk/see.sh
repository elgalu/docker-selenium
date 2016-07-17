#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
# set -u: treat unset variables as an error and exit immediately
set -e
set -u

echoerr() { awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }" ; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# ID=$(docker inspect --format="{{.Id}}" ${COMPOSE_PROJ_NAME}_hub_1)
# MASK=$(docker network inspect ${COMPOSE_PROJ_NAME}_default --format "{{ .Containers.${ID}.IPv4Address }}")
# IP=$(echo ${MASK} | sed -e 's/\/.*//')
# IP=`docker inspect -f='{{.NetworkSettings.IPAddress}}' ${COMPOSE_PROJ_NAME}_hub_1`

PORT=$(docker exec ${COMPOSE_PROJ_NAME}_${browser}_${node} cat VNC_PORT)
if [ "$(uname)" = 'Darwin' ]; then
  IP="localhost"
else
  # We need a fixed port range to expose VNC
  # due to a bug in Docker for Mac beta (1.12)
  # https://forums.docker.com/t/docker-for-mac-beta-not-forwarding-ports/8658/6
  IP=$(docker network inspect ${COMPOSE_PROJ_NAME}_default --format "{{ .Containers }}" | grep -oE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
fi

if [ "$(uname)" != 'Darwin' ]; then
  OPTS="-GrabKeyboard=0"
else
  OPTS=""
fi

# set -x: print each command right before it is executed
set -x

"${VNC_CLIENT}" -WarnUnencrypted=0 -SendKeyEvents=0 SendPointerEvents=0 -Scaling ${SIZE} ${OPTS} ${IP}:${PORT}
