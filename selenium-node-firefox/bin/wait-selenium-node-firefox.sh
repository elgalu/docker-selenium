#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# export SELENIUM_NODE_FF_PORT=$((SELENIUM_NODE_FF_BASE_PORT-1))
# for FIREFOX_VERSION in $(echo ${FIREFOX_VERSIONS} | tr "," "\n"); do
  echo "Waiting for Selenium Node Firefox ${FIREFOX_VERSION} to be ready..."
  # This is annoying but json endpoint /wd/hub/status returns different things
  #  - on grid/hub .status should be 13
  #  - on node .state should be "success"
  while ! curl -s "http://localhost:${SELENIUM_NODE_FF_PORT}/wd/hub/status" \
           | jq '.state' | grep "success"; do
    echo -n '.'
    sleep 0.1
  done
  echo "Done wait-selenium-node-firefox-${FIREFOX_VERSION}"
# done
# echo "Done wait-selenium-node-firefox.sh"
