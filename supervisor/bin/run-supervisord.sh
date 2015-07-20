#!/usr/bin/env bash

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
    tail /var/log/sele/*
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
