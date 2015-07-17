#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
timeout --foreground ${WAIT_TIMEOUT} wait-xmanager.sh
timeout --foreground ${WAIT_TIMEOUT} wait-selenium-hub.sh

JAVA_OPTS="$(java-dynamic-memory-opts.sh) ${JAVA_OPTS}"
echo "INFO: JAVA_OPTS are '${JAVA_OPTS}'"

# TODO: how to set default firefox to latest?
# export SELENIUM_NODE_FF_PORT=$((SELENIUM_NODE_FF_BASE_PORT-1))
# for FIREFOX_VERSION in $(echo ${FIREFOX_VERSIONS} | tr "," "\n"); do
  # export FIREFOX_DEST_BIN="${SEL_HOME}/firefox-${FIREFOX_VERSION}/firefox/firefox"
  export FIREFOX_BROWSER_CAPS="browserName=firefox,${COMMON_CAPS},version=${FIREFOX_VERSION},firefox_binary=${FIREFOX_DEST_BIN}"
  # export SELENIUM_NODE_FF_PORT=$((SELENIUM_NODE_FF_PORT+1))
  # See standalone params docs at
  #  https://code.google.com/p/selenium/wiki/Grid2
  java ${JAVA_OPTS} \
    -jar ${SEL_HOME}/selenium-server-standalone.jar \
    -port ${SELENIUM_NODE_FF_PORT} \
    -host ${SELENIUM_NODE_HOST} \
    -role node \
    -hub http://${SELENIUM_HUB_HOST}:${SELENIUM_HUB_PORT}/grid/register \
    -browser "${FIREFOX_BROWSER_CAPS}" \
    -trustAllSSLCertificates \
    -maxSession ${MAX_SESSIONS} \
    -timeout ${SEL_RELEASE_TIMEOUT_SECS} \
    -browserTimeout ${SEL_BROWSER_TIMEOUT_SECS} \
    -cleanUpCycle ${SEL_CLEANUPCYCLE_MS} \
    -nodePolling ${SEL_NODEPOLLING_MS} \
    ${SELENIUM_NODE_PARAMS}
# done

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee $SELENIUM_LOG
# But is no longer required because individual logs are maintained by
# supervisord right now.
