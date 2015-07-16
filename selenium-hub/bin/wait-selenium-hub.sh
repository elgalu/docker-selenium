#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ "${GRID}" = "true" ]; then
  echo "Waiting for Selenium Hub to be ready..."
  # This is annoying but json endpoint /wd/hub/status returns different things
  #  - on grid/hub .status should be 13
  #  - on node .state should be "success"
  while ! curl -s "http://localhost:${SELENIUM_HUB_PORT}/wd/hub/status" \
           | jq '.status' | grep "13"; do
    echo -n '.'
    sleep 0.1
  done
  echo "Done wait-selenium-hub.sh"
else
  echo "Won't start selenium node chrome due to GRID env var false"
fi
