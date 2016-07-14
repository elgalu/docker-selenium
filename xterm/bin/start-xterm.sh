#!/usr/bin/env bash

# Open new file descriptors that redirects to stderr/stdout
exec 3>&1
exec 4>&2

# echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&4;
}

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "150"
  errnum=${2-150}
  exit $errnum
}

# ensures supervisord dies too
shutdown () {
  # communication: we are failing
  echo "failed" > ${DOCKER_SELENIUM_STATUS}
  # optionallly prints error message
  [ ! -z "$1" ] && echoerr "ERROR: $1"
  # First stop video recording because it needs some time to flush it
  supervisorctl -c /etc/supervisor/supervisord.conf stop video-rec || true
  supervisorctl -c /etc/supervisor/supervisord.conf stop all
  kill -SIGTERM $(cat ${SUPERVISOR_PIDFILE})
  die "Some processes failed to start so quitting."
}

# clean status file
echo "" > ${DOCKER_SELENIUM_STATUS}

# timeout runs the given command and kills it if it is still running
# after the specified time interval:
#  http://www.gnu.org/software/coreutils/manual/coreutils.html#timeout-invocation

# Wait for everyone to be done
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh || \
  shutdown "Failed while waiting for Xvfb to start!"
#TODO: wait-xmanager.sh
timeout --foreground ${WAIT_TIMEOUT} wait-vnc.sh || \
  shutdown "Failed while waiting for VNC to start!"
timeout --foreground ${WAIT_TIMEOUT} wait-novnc.sh || \
  shutdown "Failed while waiting for noVNC to start!"
#TODO: wait-sshd.sh
timeout --foreground ${WAIT_TIMEOUT} wait-selenium-hub.sh || \
  shutdown "Failed while waiting for selenium hub to start!"
timeout --foreground ${WAIT_TIMEOUT} wait-selenium-node-chrome.sh || \
  shutdown "Failed while waiting for selenium node chrome to start!"
timeout --foreground ${WAIT_TIMEOUT} wait-selenium-node-firefox.sh || \
  shutdown "Failed while waiting for selenium node firefox to start!"
timeout --foreground ${WAIT_TIMEOUT} wait-video-rec.sh || \
  shutdown "Failed while waiting for video recording to start!"
timeout --foreground ${SAUCE_WAIT_RETRY_TIMEOUT} wait-saucelabs.sh || \
  shutdown "Failed while waiting for Sauce Labs tunnel to start!"
timeout --foreground ${BSTACK_WAIT_RETRY_TIMEOUT} wait-browserstack.sh || \
  shutdown "Failed while waiting for BrowserStack tunnel to start!"

# Help at http://supervisord.org/subprocess.html#process-states
echo "Checking process-states through supervisorctl status"
if ! supervisorctl -c /etc/supervisor/supervisord.conf \
    status | grep "RUNNING"; then
  die "FATAL! supervisorctl status failed in $0"
fi

if supervisorctl -c /etc/supervisor/supervisord.conf status 2>&1 \
    | grep -v "${SUPERVISOR_NOT_REQUIRED_SRV_LIST1}" \
    | grep -v "${SUPERVISOR_NOT_REQUIRED_SRV_LIST2}" \
    | grep -E "${SUPERVISOR_REQUIRED_SRV_LIST}" \
    | grep -E "STOPPED|STOPPING|EXITED|FATAL|UNKNOWN"; then
  supervisorctl -c /etc/supervisor/supervisord.conf status 1>&2
  shutdown
else
  echo "No failed processes reported by supervisorctl status. Looking good."
fi

# Start a GUI xTerm to help debugging when VNC into the container
x-terminal-emulator -ls  \
  -geometry 120x40+10+10 \
  -title "x-terminal-emulator" \
  &

# Join them in 1 bash line to avoid supervisor split them in debug output
# this output is used to signal docker-selenium is ready for testing
echo -e "\nContainer docker internal IP: $CONTAINER_IP\n"

wait