#!/usr/bin/env bash

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
  Xvfb ${DISPLAY} -screen ${SCREEN_NUM} ${GEOMETRY} -ac -r -cc 4 -accessx \
    -xinerama +extension Composite -extension RANDR
fi

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee $XVFB_LOG
# But is no longer required because individual logs are maintained by
# supervisord right now.
