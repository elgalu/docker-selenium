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
[ -z "${1}" ] && die "Need at least 1 port number argument!"
MYAPP_PORTS=$@

[ -z "${SSH_HOME}" ] && die "Need environment variable \$SSH_HOME set!"
[ -z "${CONTAINER_IP}" ] && die "Need environment variable \$CONTAINER_IP set!"
[ -z "${SSHD_PORT}" ] && die "Need environment variable \$SSHD_PORT set!"
BASE_SSH_CMD="-p ${SSHD_PORT} -o StrictHostKeyChecking=no -N -fn application@${CONTAINER_IP}"

## convert space separated string into a bash array
IFS=' ' read -a MYAPP_PORTS <<< "${MYAPP_PORTS}"
declare -a MYAPP_PORTS=${MYAPP_PORTS}

# to setup tunnels first kill existing tunnels if any
# then set them up in the background
for i in "${MYAPP_PORTS[@]}"; do
  kill $(lsof -i tcp:${i} -F p | cut -b 2-) >/dev/null 2>&1 || true
  ssh-keygen -f "${SSH_HOME}/.ssh/known_hosts" -R [${CONTAINER_IP}]:${SSHD_PORT} >/dev/null 2>&1 || true
  ssh ${BASE_SSH_CMD} -R localhost:${i}:localhost:${i} &
done
