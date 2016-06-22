#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ "${VNC_START}" != "true" ]; then
  echo "Won't start VNC service due to VNC_START env var false"
  exit 0
fi

# Note this active wait provokes below error, so ignore it
#  "webSocketsHandshake: unknown connection error"

if [ -z "${XE_DISP_NUM}" ]; then
  echo "Waiting for VNC to be ready..."
  while ! nc -z localhost ${VNC_PORT}; do
    echo -n '.'
    sleep 0.1
  done
else
  echo "Will not wait for VNC because env var XE_DISP_NUM is set."
fi

echo "Done wait-vnc.sh"
