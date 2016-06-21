#!/usr/bin/env bash

SEL_STATUS_URL="http://localhost:${SELENIUM_NODE_FF_PORT}/wd/hub/status"

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ "${FIREFOX}" != "true" ]; then
  echo "Won't start selenium node firefox due to FIREFOX env var false"
  exit 0
fi

echo "Waiting for Selenium Node Firefox ${FIREFOX_VERSION} to be ready..."
# This is annoying but json endpoint /wd/hub/status returns different things
#  - on grid/hub .status should be 13
#  - on node .state should be "success"
while ! curl -s "${SEL_STATUS_URL}" | jq '.state' | grep "success"; do
  echo -n '.'
  sleep 0.1
done
echo "Done wait-selenium-node-firefox-${FIREFOX_VERSION}"
