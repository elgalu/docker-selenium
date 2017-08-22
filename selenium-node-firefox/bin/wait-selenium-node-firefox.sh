#!/usr/bin/env bash

SEL_STATUS_URL="http://localhost:${SELENIUM_NODE_FF_PORT}/wd/hub/status"

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ "${FIREFOX}" != "true" ]; then
  echo "Won't start selenium node firefox due to FIREFOX env var false"
  exit 0
fi

echo "Waiting for Selenium Node Firefox ${FIREFOX_VERSION} to be ready..."
# Selenium >= 3.5.0 then: while ! curl -s "${SEL_STATUS_URL}" | jq .value.ready | grep "true"; do
# Selenium <= 3.3.1 then: while ! curl -s "${SEL_STATUS_URL}" | jq '.state' | grep "success"; do
SUCESS_CMD="jq .state | grep success"
# SUCESS_CMD="jq .value.ready | grep true"
while ! curl -s "${SEL_STATUS_URL}" | sh -c "${SUCESS_CMD}"; do
  echo -n '.'
  sleep 0.1
done
echo "Done wait-selenium-node-firefox-${FIREFOX_VERSION}"
