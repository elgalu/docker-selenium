#!/usr/bin/env bash

SEL_STATUS_URL="${SELENIUM_HUB_PROTO}://${SELENIUM_HUB_HOST}:${SELENIUM_HUB_PORT}/wd/hub/status"

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ "${GRID}" != "true" ]; then
  echo "Won't start selenium grid due to GRID env var false"
  exit 0
fi

echo "Waiting for Selenium Hub to be ready..."

# Selenium <= 3.3.1 then: while ! curl -s "${SEL_STATUS_URL}" | jq '.status' | grep "13"; do
# SUCESS_CMD="jq .status | grep 13"

# Selenium >= 3.5.0 then: while ! curl -s "${SEL_STATUS_URL}" | jq '.status' | grep "0"; do
SUCESS_CMD="jq .status | grep 0"

while ! curl -s "${SEL_STATUS_URL}" | sh -c "${SUCESS_CMD}"; do
  echo -n '.'
  sleep 0.1
done
echo "Done wait-selenium-hub.sh"
