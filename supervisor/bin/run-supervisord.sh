#!/usr/bin/env bash

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "13"
  errnum=${2-13}
  exit $errnum
}

# Required params
[ -z "${TAIL_LOG_LINES}" ] && die "Required TAIL_LOG_LINES"

ga_track_shutdown () {
  if [ "${SEND_ANONYMOUS_USAGE_INFO}" == "true" ]; then
    DisplayDataProcessingAgreement

    local args=(
        --max-time 10
        --data v=${GA_API_VERSION}
        --data aip=1
        --data t="screenview"
        --data tid="${GA_TRACKING_ID}"
        --data cid="${RANDOM_USER_GA_ID}"
        --data an="dosel"
        --data av="${DOSEL_VERSION}"
        --data cd="shutdown"
        --data sc="end"
        --data ds="docker"
    )

    curl ${GA_ENDPOINT} "${args[@]}" \
        --silent --output /dev/null >/dev/null 2>&1
  fi
}

# Exit all child processes properly
shutdown () {
  echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord gracefully..."
  ga_track_shutdown
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
      exit 122
    fi
  else
    exit 0
  fi
}

# Run function shutdown() when this process receives a killing signal
trap shutdown SIGHUP SIGTERM SIGINT

echo -n "supervisord --version=" && supervisord --version

supervisord -c /etc/supervisor/supervisord.conf --user ${USER} --nodaemon &
SUPERVISOR_PID=$!

# tells bash to wait until child processes have exited
wait "${SUPERVISOR_PID}"
