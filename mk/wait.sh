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
# set -x

echo "Waiting for the Hub and all Nodes to be ready..."

if ! docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} \
        exec --index 1 hub wait_all_done ${WAIT_ALL_DONE} >/dev/null; then
  docker logs ${COMPOSE_PROJ_NAME}_hub_1
  docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} \
      exec --index 1 hub errors || true
  die "Failed to start the Hub (a.k.a. Grid) 1"
fi

for i in $(seq 1 ${chrome}); do
  if ! docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} \
        exec --index ${i} chrome wait_all_done ${WAIT_ALL_DONE} >/dev/null; then
    docker logs ${COMPOSE_PROJ_NAME}_chrome_${i}
    docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} \
        exec --index ${i} chrome errors || true
    die "Failed to start Node chrome ${i}"
  fi
done

for i in $(seq 1 ${firefox}); do
  if ! docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} \
        exec --index ${i} firefox wait_all_done ${WAIT_ALL_DONE} >/dev/null; then
    docker logs ${COMPOSE_PROJ_NAME}_firefox_${i}
    docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} \
        exec --index ${i} firefox errors || true
    die "Failed to start Node firefox ${i}"
  fi
done

echo "------------------------------------------------"
echo "-------- SUCCESS: Hub and Nodes ready ----------"
echo "------------------------------------------------"
