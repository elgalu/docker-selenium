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
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "160"
  errnum=${2-160}
  exit $errnum
}

# Required params
[ -z "${SAUCE_LOCAL_SEL_PORT}" ] && die "Required SAUCE_LOCAL_SEL_PORT"
[ -z "${SAUCE_USER_NAME}" ] && die "Required env var SAUCE_USER_NAME"
[ -z "${SAUCE_API_KEY}" ] && die "Required env var SAUCE_API_KEY"
[ -z "${SAUCE_TUNNEL_READY_FILE}" ] && die "Required SAUCE_TUNNEL_READY_FILE"
[ -z "${SAUCE_TUNNEL_ID}" ] && die "Required env var SAUCE_TUNNEL_ID"

# Wait for this process dependencies
# - none, the tunnel has no dependencies
# timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh

# Start tunnel
sc --se-port ${SAUCE_LOCAL_SEL_PORT} \
   --user "${SAUCE_USER_NAME}" \
   --api-key "${SAUCE_API_KEY}" \
   --readyfile "${SAUCE_TUNNEL_READY_FILE}" \
   --tunnel-identifier "${SAUCE_TUNNEL_ID}" &
SAUCE_TUNNEL_PID=$!

function shutdown {
  echo "Trapped SIGTERM/SIGINT so shutting down Sauce Labs gracefully..."
  kill -SIGINT ${SAUCE_TUNNEL_PID}
  wait ${SAUCE_TUNNEL_PID}
  echo "Sauce Labs tunnel shutdown complete."
  exit 0
}

# Wait for the file to exists
echo "Waiting for file ${SAUCE_TUNNEL_READY_FILE} to be created..."
while ! ls -l "${SAUCE_TUNNEL_READY_FILE}" >/dev/null 2>&1; do sleep 0.1; done

# Now wait for the tunnel to finish starting
timeout --foreground ${SAUCE_WAIT_TIMEOUT} wait-saucelabs.sh

# Run function shutdown() when this process a killer signal
trap shutdown SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait
