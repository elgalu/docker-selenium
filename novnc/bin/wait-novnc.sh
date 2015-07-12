#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -z "${XE_DISP_NUM}" ]; then
  echo "Waiting for noVNC to be ready..."
  while ! curl -s "http://localhost:${NOVNC_PORT}/vnc.html" \
            | grep "noVNC_screen"; do
    echo -n '.'
    sleep 0.1
  done
else
  echo "Will not wait for noVNC because env var XE_DISP_NUM is set."
fi

echo "Done wait-novnc.sh"
