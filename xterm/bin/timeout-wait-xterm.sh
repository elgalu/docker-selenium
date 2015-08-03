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

# if $1 is defined AND NOT EMPTY, use $1; otherwise, set to "7s"
WAIT_TIMEOUT=${1-7s}
LOOP_SCRIPT_PATH="/bin-utils/wait-xterm.sh"

if [ ! -f "${LOOP_SCRIPT_PATH}" ]; then
  die "Need '${LOOP_SCRIPT_PATH}' to exist!"
fi

# Avoid waiting forever using the `timeout` command
if timeout --foreground ${WAIT_TIMEOUT} \
     ${LOOP_SCRIPT_PATH}; then
  echo ""
  grep 'password' /var/log/sele/vnc-stdout.log || true
  grep 'IP:' /var/log/sele/xterm-stdout.log || die "Failed to grep IP:"
else
  bash -c 'tail /var/log/sele/*' || true
  echo "" && echo "" && echo "==> errors <=="
  bash -c '/bin-utils/selenium-grep.sh' || true

  die "
   Your docker-selenium didn't start properly.
   Start it next time with -e DISABLE_ROLLBACK=true
  "
fi
