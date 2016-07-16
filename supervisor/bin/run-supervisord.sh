#!/usr/bin/env bash

echoerr() { awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }" ; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# Required params
[ -z "${TAIL_LOG_LINES}" ] && die "Required TAIL_LOG_LINES"

# Exit all child processes properly
shutdown () {
  echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord gracefully..."
  stop
  wait

  # when DISABLE_ROLLBACK=true it will:
  #  - output logs
  #  - exec bash to permit troubleshooting
  if [ "$(cat ${DOCKER_SELENIUM_STATUS})" = "failed" ]; then
    tail --lines=${TAIL_LOG_LINES} /var/log/cont/*
    echo "" && echo "" && echo "==> errors <=="
    errors

    if [ "${DISABLE_ROLLBACK}" = "true" ]; then
      echo ""
      echo "DEBUGGING: to find out what happened please analyze logs or run"
      echo "  errors"
      echo ""

      exec bash
    else
      exit 3
    fi
  else
    exit 0
  fi
}

# Run function shutdown() when this process a killer signal
trap shutdown SIGHUP SIGTERM SIGINT

echo -n "supervisord --version=" && supervisord --version

supervisord -c /etc/supervisor/supervisord.conf --user ${USER} &
SUPERVISOR_PID=$!

# tells bash to wait until child processes have exited
wait "${SUPERVISOR_PID}"
