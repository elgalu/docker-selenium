#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Waiting for Xvfb to be ready..."
while ! xdpyinfo -display ${DISPLAY}; do
  echo -n ''
  sleep 0.1
done

echo "Done wait-xvfb.sh"
