#!/usr/bin/env bash

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
[ -z "${TAIL_LOG_LINES}" ] && die "Required TAIL_LOG_LINES"

# Exit all child processes properly
function shutdown {
  echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord gracefully..."
  # First stop video recording because it needs some time to flush it
  supervisorctl -c /etc/supervisor/supervisord.conf stop video-rec || true
  supervisorctl -c /etc/supervisor/supervisord.conf stop all
  # kill -SIGTERM $(cat ${SUPERVISOR_PIDFILE})
  kill -SIGTERM ${SUPERVISOR_PID}
  wait
  # sleep ${SLEEP_SECS_AFTER_KILLING_SUPERVISORD}
  # sudo kill -9 ${SUPERVISOR_PID} || true

  # when DISABLE_ROLLBACK=true it will:
  #  - output logs
  #  - exec bash to permit troubleshooting
  if [ "$(cat ${DOCKER_SELENIUM_STATUS})" = "failed" ]; then
    tail --lines=${TAIL_LOG_LINES} /var/log/sele/*
    echo "" && echo "" && echo "==> errors <=="
    selenium-grep.sh

    if [ "${DISABLE_ROLLBACK}" = "true" ]; then
      echo ""
      echo "DEBUGGING: to find out what happened please analyze logs or run"
      echo "  selenium-grep.sh"
      echo ""

      exec bash
    else
      exit 3
    fi
  else
    exit 0
  fi
}

supervisord -c /etc/supervisor/supervisord.conf &
SUPERVISOR_PID=$!

# Run function shutdown() when this process a killer signal
trap shutdown SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait
