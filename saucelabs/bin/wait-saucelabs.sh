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

export DONE_MSG="Connection established."

if [ "${SAUCE_TUNNEL}" = "true" ]; then
  echo "Waiting for Sauce Labs tunnel to start..."
  # Required params
  [ -z "${SAUCE_LOG_FILE}" ] && die "Required env var SAUCE_LOG_FILE"
  while ! grep "${DONE_MSG}" ${SAUCE_LOG_FILE} >/dev/null; do
    echo -n '.'
    sleep 0.2;
  done
  echo "Sauce Labs tunnel started! (wait-saucelabs.sh)"
else
  echo "Won't start Sauce Labs tunnel due to SAUCE_TUNNEL false"
fi
