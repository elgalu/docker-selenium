#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
timeout --foreground ${WAIT_TIMEOUT} wait-xmanager.sh
timeout --foreground ${WAIT_TIMEOUT} wait-selenium-hub.sh

JAVA_OPTS="$(java-dynamic-memory-opts.sh) ${JAVA_OPTS}"
echo "INFO: JAVA_OPTS are '${JAVA_OPTS}'"

# See standalone params docs at https://code.google.com/p/selenium/wiki/Grid2
java ${JAVA_OPTS} \
  -jar ${SEL_HOME}/selenium-server-standalone.jar \
  -port ${SELENIUM_NODE_CH_PORT} \
  -host ${SELENIUM_NODE_HOST} \
  -role node \
  -hub "${SELENIUM_HUB_PROTO}://${SELENIUM_HUB_HOST}:${SELENIUM_HUB_PORT}/grid/register" \
  -browser "${CHROME_BROWSER_CAPS}" \
  -trustAllSSLCertificates \
  -maxSession ${MAX_SESSIONS} \
  -timeout ${SEL_RELEASE_TIMEOUT_SECS} \
  -browserTimeout ${SEL_BROWSER_TIMEOUT_SECS} \
  -cleanUpCycle ${SEL_CLEANUPCYCLE_MS} \
  -nodePolling ${SEL_NODEPOLLING_MS} \
  -Dwebdriver.chrome.driver="${SEL_HOME}/chromedriver" \
  ${SELENIUM_NODE_PARAMS}

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee $SELENIUM_LOG
# But is no longer required because individual logs are maintained by
# supervisord right now.
