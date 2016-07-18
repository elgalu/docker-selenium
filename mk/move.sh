#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
# set -u: treat unset variables as an error and exit immediately
set -e
set -u

echoerr() { awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }" ; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

if [ "$(uname)" = 'Darwin' ]; then
  die "Sorry: moving windows with wmctrl in OSX is not properly supported."
fi

DISP="$(docker exec ${COMPOSE_PROJ_NAME}_${browser}_${node} cat DISPLAY)"
CONT_HOSTNAME=$(docker exec ${COMPOSE_PROJ_NAME}_${browser}_${node} hostname)
WIN_TITLE="${CONT_HOSTNAME}${DISP} - VNC Viewer"

if [ "${browser}" = "chrome" ] && [ "${node}" = "1" ]; then
  # NorthWest(1)0,0
  set -x && wmctrl -r "${WIN_TITLE}" -e 1,0,0,-1,-1
elif [ "${browser}" = "firefox" ] && [ "${node}" = "1" ]; then
  # NorthEast(3)1920,0
  set -x && wmctrl -r "${WIN_TITLE}" -e 3,1920,0,-1,-1
elif [ "${browser}" = "chrome" ] && [ "${node}" = "2" ]; then
  # SouthEast(9)1920,1080
  set -x && wmctrl -r "${WIN_TITLE}" -e 9,1920,1080,-1,-1
elif [ "${browser}" = "firefox" ] && [ "${node}" = "2" ]; then
  # SouthWest(7)0,1080
  set -x && wmctrl -r "${WIN_TITLE}" -e 7,0,1080,-1,-1
else
  # TODO: make it smarter
  echo "-- TODO: Sorry I still don't know where to move ${browser} node: ${node}"
fi
