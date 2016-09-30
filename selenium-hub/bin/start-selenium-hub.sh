#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
timeout --foreground ${WAIT_TIMEOUT} wait-xmanager.sh

JAVA_OPTS="$(java-dynamic-memory-opts.sh) ${JAVA_OPTS}"
echo "INFO: JAVA_OPTS are '${JAVA_OPTS}'"

# See standalone params docs at
#  https://code.google.com/p/selenium/wiki/Grid2
#  https://github.com/pilwon/selenium-webdriver/blob/master/java/server/src/org/openqa/grid/common/defaults/GridParameters.properties
# See hub defaults at
#  https://github.com/pilwon/selenium-webdriver/blob/master/java/server/src/org/openqa/grid/common/defaults/DefaultNode.json
# Had to increase -cleanUpCycle and -nodePolling to avoid
#  UnknownError: Session [.*] was terminated due to TIMEOUT
java ${JAVA_OPTS} \
  -jar ${SELENIUM_JAR_PATH} \
  -port ${SELENIUM_HUB_PORT} \
  -role hub \
  -maxSession ${MAX_SESSIONS} \
  -timeout ${SEL_RELEASE_TIMEOUT_SECS} \
  -browserTimeout ${SEL_BROWSER_TIMEOUT_SECS} \
  -cleanUpCycle ${SEL_CLEANUPCYCLE_MS} \
  ${SELENIUM_HUB_PARAMS}

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee ${SELENIUM_LOG}
# But is no longer required because individual logs are maintained by
# supervisord right now.
