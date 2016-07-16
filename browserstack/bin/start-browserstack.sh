#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }" ; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "160"
  errnum=${2-160}
  exit $errnum
}

# Required params
[ -z "${BSTACK_ACCESS_KEY}" ] && die "Required env var BSTACK_ACCESS_KEY"
[ -z "${BSTACK_TUNNEL_OPTS}" ] && die "Required env var BSTACK_TUNNEL_OPTS"
[ -z "${BSTACK_TUNNEL_ID}" ] && die "Required env var BSTACK_TUNNEL_ID"

# Wait for this process dependencies
# - none, the tunnel has no dependencies
# timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh

# Start tunnel
BrowserStackLocal \
  ${BSTACK_ACCESS_KEY} \
  ${BSTACK_TUNNEL_OPTS} \
  -localIdentifier ${BSTACK_TUNNEL_ID} &
BSTACK_TUNNEL_PID=$!

function shutdown {
  echo "Trapped SIGTERM/SIGINT so shutting down BrowserStack gracefully..."
  kill -SIGINT ${BSTACK_TUNNEL_PID}
  wait ${BSTACK_TUNNEL_PID}
  echo "BrowserStack tunnel shutdown complete."
  exit 0
}

# Now wait for the tunnel to finish starting
timeout --foreground ${BSTACK_WAIT_TIMEOUT} wait-browserstack.sh

# Run function shutdown() when this process a killer signal
trap shutdown SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait
