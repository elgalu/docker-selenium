#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Waiting for Selenium to be ready..."
while ! curl -s "http://localhost:${SELENIUM_PORT}/wd/hub/status" \
         | jq '.state' | grep "success"; do
  echo -n '.'
  sleep 0.1
done

echo "Done wait-selenium.sh"
