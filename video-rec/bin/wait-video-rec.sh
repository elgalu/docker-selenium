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
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "160"
  errnum=${2-160}
  exit $errnum
}

export DONE_MSG="Stream mapping:"

if [ "${VIDEO}" != "true" ]; then
  echo "Won't start video recording due to VIDEO env var false"
  exit 0
fi

echo "Waiting for ffmpeg video recording to start..."
# Required params
[ -z "${VIDEO_LOG_FILE}" ] && die "Required env var VIDEO_LOG_FILE"
while ! grep "${DONE_MSG}" ${VIDEO_LOG_FILE} >/dev/null; do
  echo -n '.'
  sleep 0.2;
done
echo "Videos at ${VIDEO_PATH}* started to be recorded! (wait-video-rec.sh)"
