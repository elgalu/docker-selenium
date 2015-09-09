#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ "${NOVNC}" != "true" ]; then
  echo "Won't start noVNC service due to NOVNC env var false"
  exit 0
fi

if [ ! -z "${XE_DISP_NUM}" ]; then
  echo "Will not wait for noVNC because env var XE_DISP_NUM is set."
  exit 0
fi

echo "Waiting for noVNC to be ready..."
while ! curl -s "http://localhost:${NOVNC_PORT}/vnc.html" \
          | grep "noVNC_screen"; do
  echo -n '.'
  sleep 0.1
done
echo "Done wait-novnc.sh"
