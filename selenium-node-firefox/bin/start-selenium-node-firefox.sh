#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "150"
  errnum=${2-110}
  exit $errnum
}

# Required params (some)
[ -z "${WAIT_TIMEOUT}" ] && die "Required env var WAIT_TIMEOUT"
[ -z "${COMMON_CAPS}" ] && die "Required env var COMMON_CAPS"
[ -z "${SELENIUM_JAR_PATH}" ] && die "Required env var SELENIUM_JAR_PATH"
[ -z "${SELENIUM_NODE_HOST}" ] && die "Required env var SELENIUM_NODE_HOST"
[ -z "${FIREFOX_VERSION}" ] && die "Required env var FIREFOX_VERSION"
[ -z "${FIREFOX_DEST_BIN}" ] && die "Required env var FIREFOX_DEST_BIN"

if [ "${ZALENIUM}" != "true" ]; then
  timeout --foreground ${WAIT_TIMEOUT} wait-selenium-hub.sh || \
    shutdown "Failed while waiting for selenium hub to start!"
fi

JAVA_OPTS="-Dwebdriver.gecko.driver=/usr/bin/geckodriver ${JAVA_OPTS}"
JAVA_OPTS="$(java-dynamic-memory-opts.sh) ${JAVA_OPTS}"
echo "INFO: JAVA_OPTS are '${JAVA_OPTS}'"

# See standalone params docs at
#  https://code.google.com/p/selenium/wiki/Grid2
#  https://github.com/pilwon/selenium-webdriver/blob/master/java/server/src/org/openqa/grid/common/defaults/GridParameters.properties
# See node defaults at
#  https://github.com/pilwon/selenium-webdriver/blob/master/java/server/src/org/openqa/grid/common/defaults/DefaultNode.json
# TODO: how to set default firefox to latest?
FIREFOX_BROWSER_CAPS="browserName=firefox,${COMMON_CAPS}"
FIREFOX_BROWSER_CAPS="${FIREFOX_BROWSER_CAPS},version=${FIREFOX_VERSION}"
FIREFOX_BROWSER_CAPS="${FIREFOX_BROWSER_CAPS},firefox_binary=${FIREFOX_DEST_BIN}"

# public static final String BROWSER_LOGFILE = "webdriver.firefox.logfile";
#   System property that defines the location of the file where Firefox log should be stored.

java \
  -Dwebdriver.firefox.logfile="${LOGS_DIR}/firefox_driver.log" \
  ${JAVA_OPTS} \
  -jar ${SELENIUM_JAR_PATH} \
  -port ${SELENIUM_NODE_FF_PORT} \
  -host ${SELENIUM_NODE_HOST} \
  -role node \
  -hub "${SELENIUM_HUB_PROTO}://${SELENIUM_HUB_HOST}:${SELENIUM_HUB_PORT}/grid/register" \
  -browser "${FIREFOX_BROWSER_CAPS}" \
  -maxSession ${MAX_SESSIONS} \
  -timeout ${SEL_RELEASE_TIMEOUT_SECS} \
  -browserTimeout ${SEL_BROWSER_TIMEOUT_SECS} \
  -cleanUpCycle ${SEL_CLEANUPCYCLE_MS} \
  -nodePolling ${SEL_NODEPOLLING_MS} \
  -unregisterIfStillDownAfter ${SEL_UNREGISTER_IF_STILL_DOWN_AFTER} \
  ${SELENIUM_NODE_PARAMS} \
  ${CUSTOM_SELENIUM_NODE_PROXY_PARAMS} \
  ${CUSTOM_SELENIUM_NODE_REGISTER_CYCLE} \
  &
NODE_PID=$!

function shutdown {
  echo "-- INFO: Shutting down Firefox NODE gracefully..."
  kill -SIGINT ${NODE_PID} || true
  kill -SIGTERM ${NODE_PID} || true
  kill -SIGKILL ${NODE_PID} || true
  wait ${NODE_PID}
  echo "-- INFO: Firefox node shutdown complete."
  # First stop video recording because it needs some time to flush it
  supervisorctl -c /etc/supervisor/supervisord.conf stop video-rec || true
  # supervisorctl -c /etc/supervisor/supervisord.conf stop xterm
  exit 0
}

function trappedFn {
  echo "-- INFO: Trapped SIGTERM/SIGINT on Firefox NODE"
  shutdown
}
# Run function shutdown() when this process receives a killing signal
trap trappedFn SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait ${NODE_PID}
echo "-- INFO: Passed after wait java Firefox node"

# Always shutdown if the node dies
shutdown

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee $SELENIUM_LOG
# But is no longer required because individual logs are maintained by
# supervisord right now.
