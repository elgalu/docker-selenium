#!/usr/bin/env bash

# Start the X server that can run on machines with no real display
#==============================
# using Xdummy instead of Xvfb
#==============================
# genereate_xorg_configs.sh || die "Failed to start genereate_xorg_configs!" 11 true
# Xorg ${DISPLAY} -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR \
#   +extension RENDER -logfile ${XVFB_LOG} -config ${HOME}/xorg.conf | tee $XVFB_LOG &
# XVFB_PID=$!
