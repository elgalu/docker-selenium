#!/usr/bin/env bash

# DISABLED! since we always need Xvfb this file will be deprecated

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ -f /tmp/xvfb.pid ]; then
  kill $(cat /tmp/xvfb.pid)
  rm -f /tmp/xvfb.pid
fi

if [ ! -z "${XE_DISP_NUM}" ]; then
  echo "INFO: XE_DISP_NUM '${XE_DISP_NUM}' was provided so switching to that DISPLAY"
  echo "INFO:   and skipping virtual framebuffer startup in favor of remote."
  export DISP_N="${XE_DISP_NUM}"
  export DISPLAY=":${DISP_N}"
else
  if [ ":$DISP_N" != "${DISPLAY}" ]; then
    echo "WARN: DISP_N '${DISP_N}' doesn't match DISPLAY '${DISPLAY}'"
    export DISPLAY=":${DISP_N}"
    echo "WARN:   so fixing it; new DISPLAY is '${DISPLAY}'"
  fi

  # Start the X server that can run on machines with no real display
  # using Xvfb instead of Xdummy
  echo "Will start Xvfb with DISPLAY=${DISPLAY}"
  echo "Will start Xvfb with screen=${SCREEN_NUM} geometry=${GEOMETRY}"
  echo "Will start Xvfb with XVFB_CLI_OPTS_TCP=${XVFB_CLI_OPTS_TCP}"
  echo "Will start Xvfb with XVFB_CLI_OPTS_BASE=${XVFB_CLI_OPTS_BASE}"
  echo "Will start Xvfb with XVFB_CLI_OPTS_EXT=${XVFB_CLI_OPTS_EXT}"
  Xvfb ${DISPLAY} -screen ${SCREEN_NUM} ${GEOMETRY} \
    ${XVFB_CLI_OPTS_TCP} ${XVFB_CLI_OPTS_BASE} ${XVFB_CLI_OPTS_EXT}
fi

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee $XVFB_LOG
# But is no longer required because individual logs are maintained by
# supervisord right now.
