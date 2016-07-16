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

# set -x: print each command right before it is executed
set -x

# ID=$(docker inspect --format="{{.Id}}" ${COMPOSE_PROJ_NAME}_hub_1)
# MASK=$(docker network inspect ${COMPOSE_PROJ_NAME}_default --format "{{ .Containers.${ID}.IPv4Address }}")
# IP=$(echo ${MASK} | sed -e 's/\/.*//')
# IP=`docker inspect -f='{{.NetworkSettings.IPAddress}}' ${COMPOSE_PROJ_NAME}_hub_1`

PORT=$(docker exec ${COMPOSE_PROJ_NAME}_${browser}_${node} cat VNC_PORT)
IP=$(docker network inspect ${COMPOSE_PROJ_NAME}_default --format "{{ .Containers }}" | grep -oE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
${VNC_CLIENT} -WarnUnencrypted=0 -SendKeyEvents=0 -GrabKeyboard=0 \
  SendPointerEvents=0 -Scaling 30% ${IP}:${PORT}
