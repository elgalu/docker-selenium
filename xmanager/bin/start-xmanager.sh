#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&2;
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

if [ "${XMANAGER}" = "openbox" ]; then
  # Openbox is a lightweight window manager using freedesktop standards
  exec openbox-session
elif [ "${XMANAGER}" = "fluxbox" ]; then
  # Fluxbox is a fast, lightweight and responsive window manager
  exec fluxbox -display ${DISPLAY}
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
