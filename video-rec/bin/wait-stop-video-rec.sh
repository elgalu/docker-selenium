#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }" ; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "160"
  errnum=${2-160}
  exit $errnum
}

echo "Waiting for video to stop recording..."
while ! supervisorctl -c /etc/supervisor/supervisord.conf \
          status video-rec 2>&1 \
          | grep -E "STOPPED|EXITED|FATAL|UNKNOWN"; do
  echo -n '.'
  sleep 0.1;
done
echo "Done waiting for video recording to stop."
