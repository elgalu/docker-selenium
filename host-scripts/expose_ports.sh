#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
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

# ensures supervisord dies too
shutdown () {
  echo "Trapped SIGTERM/SIGINT/SIGKILL so shutting down expose gracefully..."
  kill -SIGTERM $(jobs -p)
  exit 0
}

# Required params
[ -z "${1}" ] && die "Need at least 1 port number argument!"
MYAPP_PORTS=$@

[ -z "${CONTAINER_IP}" ] && die "Need environment variable \$CONTAINER_IP set!"
[ -z "${SSHD_PORT}" ] && die "Need environment variable \$SSHD_PORT set!"
[ -z "${KNOWN_HOSTS_PATH}" ] && die "Need env var \$KNOWN_HOSTS_PATH set!"
# -f  Requests ssh to go to background just before command execution
# -n  Redirects stdin from /dev/null (actually, prevents reading from stdin).
#     This must be used when ssh is run in the background
# -N  Do not execute a remote command.  This is useful for just forwarding ports
BASE_SSH_CMD="-p ${SSHD_PORT} -o StrictHostKeyChecking=no -N -n application@${CONTAINER_IP}"

## convert space separated string into a bash array
IFS=' ' read -a MYAPP_PORTS <<< "${MYAPP_PORTS}"
declare -a MYAPP_PORTS=${MYAPP_PORTS}

# to setup tunnels first kill existing tunnels if any
# then set them up in the background
for i in "${MYAPP_PORTS[@]}"; do
  (kill $(lsof -i tcp:${i} -F p | cut -b 2-) >/dev/null 2>&1) || true
  (ssh-keygen -f "${KNOWN_HOSTS_PATH}" -R [${CONTAINER_IP}]:${SSHD_PORT} >/dev/null 2>&1) || true
  ssh ${BASE_SSH_CMD} -R localhost:${i}:localhost:${i} &
done

# Run function shutdown() when this process a killer signal
trap shutdown SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait
