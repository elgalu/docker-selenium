#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
timeout --foreground ${WAIT_TIMEOUT} wait-xmanager.sh
timeout --foreground ${WAIT_TIMEOUT} wait-vnc.sh

# Usage at https://github.com/kanaka/noVNC/blob/master/utils/launch.sh
${NORMAL_USER_HOME}/noVNC/utils/launch.sh \
  --listen ${NOVNC_PORT}\
  --vnc localhost:${VNC_PORT}
