#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Waiting for Selenium Node Chrome to be ready..."
# This is annoying but json endpoint /wd/hub/status returns different things
#  - on grid/hub .status should be 13
#  - on node .state should be "success"
while ! curl -s "http://localhost:${SELENIUM_NODE_CH_PORT}/wd/hub/status" \
         | jq '.state' | grep "success"; do
  echo -n '.'
  sleep 0.1
done

echo "Done wait-selenium-node-chrome.sh"
