#!/usr/bin/env bash

SEL_STATUS_URL="http://localhost:${SELENIUM_HUB_PORT}/wd/hub/status"

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ "${GRID}" != "true" ]; then
  echo "Won't start selenium grid due to GRID env var false"
  exit 0
fi

echo "Waiting for Selenium Hub to be ready..."
# This is annoying but json endpoint /wd/hub/status returns different things
#  - on grid/hub .status should be 13
#  - on node .state should be "success"
while ! curl -s "${SEL_STATUS_URL}" | jq '.status' | grep "13"; do
  echo -n '.'
  sleep 0.1
done
echo "Done wait-selenium-hub.sh"
