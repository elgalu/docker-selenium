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

[ -z "${COMPOSE_FILE}" ] && die "Need env var COMPOSE_FILE"
[ -z "${proj}" ] && die "Need env var proj"
[ -z "${browser}" ] && die "Need env var browser"
[ -z "${node}" ] && die "Need env var node"
[ -z "${tot_nodes}" ] && die "Need env var tot_nodes"

# Gather actual container name as hard-coding it is unreliable
CONT_NAME=$(docker ps --filter status=running --filter "name=${proj}_${browser}_${node}" --format "{{.Names}}" -q)

# set -x: print each command right before it is executed
set -x

mkdir -p ./videos

for node in $(seq -s ' ' 1 ${tot_nodes}); do
  docker-compose -f ${COMPOSE_FILE} -p ${proj} exec --index=${node} ${browser} stop-video \
    >./mk/stop_video_${browser}_${node}.log || true
  docker cp "${CONT_NAME}:/videos/." videos
  docker-compose -f ${COMPOSE_FILE} -p ${proj} exec --index=${node} ${browser} rm_videos || true
  docker-compose -f ${COMPOSE_FILE} -p ${proj} exec --index=${node} ${browser} start-video
done

ls -la ./videos/
