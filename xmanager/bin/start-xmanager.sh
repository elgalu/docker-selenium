#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Open new file descriptors that redirects to stderr/stdout
exec 3>&1
exec 4>&2

# echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&4;
}

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "150"
  errnum=${2-110}
  exit $errnum
}

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh

function start_fluxbox() {
  fluxbox -display ${DISPLAY} -verbose \
    1> "${LOGS_DIR}/fluxbox-tryouts-stdout.log" \
    2> "${LOGS_DIR}/fluxbox-tryouts-stderr.log" &
}

if [ "${XMANAGER}" = "openbox" ]; then
  # Openbox is a lightweight window manager using freedesktop standards
  exec openbox-session
elif [ "${XMANAGER}" = "fluxbox" ]; then
  # Fluxbox is a fast, lightweight and responsive window manager
  i=0
  stat_failed=true
  while true ; do
    let i=${i}+1
    if ! start_fluxbox; then
      echo "-- WARN: start_fluxbox() failed!" 1>&3
    fi
    timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
    if timeout --foreground "${WAIT_FOREGROUND_RETRY}" wait-xmanager.sh &> "${LOGS_DIR}/wait-xmanager-stdout.log"; then
      stat_failed=false
      break
    else
      echo "-- WARN: wait-xmanager.sh failed! for DISPLAY=${DISPLAY}" 1>&3
      killall fluxbox || true
    fi
    if [ ${i} -gt 10 ]; then
      echoerr "-- ERROR: Failed to start Fluxbox at $0 after many retries."
      break
    fi
  done
  [ "${stat_failed}" = "true" ] && die "Failed to start_fluxbox()."
  wait
else
  die "The chosen X manager is not supported: '${XMANAGER}'"
fi

#----------------
# Alternative 3.
# GNOME Shell provides core interface functions like switching windows,
#  launching applications or see your notifications
# gnome-shell -display ${DISPLAY}

#----------------
# Alternative 4.
# GNOME ubuntu desktop; The fat and full featured windows manager
# /etc/X11/Xsession &
# gnome-session &

#----------------
# Alternative 5.
# Not working: LXDE is a Lightweight X11 Desktop Environment
# lxde -display ${DISPLAY}

#----------------
# Alternative 6.
# lightdm is a fat and full featured windows manager
# lightdm-session
