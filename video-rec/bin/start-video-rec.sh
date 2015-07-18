#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
# timeout --foreground ${WAIT_TIMEOUT} wait-vnc.sh
# timeout --foreground ${WAIT_TIMEOUT} wait-selenium-hub.sh
# timeout --foreground ${WAIT_TIMEOUT} wait-selenium-node-chrome.sh
# timeout --foreground ${WAIT_TIMEOUT} wait-selenium-node-firefox.sh

# Make it portable
[ -z "${HOST_GID}" ] && export HOST_GID=$(stat -c "%g" ${VIDEOS_DIR})
[ -z "${HOST_UID}" ] && export HOST_UID=$(stat -c "%u" ${VIDEOS_DIR})
[ -z "${VIDEO_PATH}" ] && export \
    VIDEO_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}.${VIDEO_FILE_EXTENSION}"

# Remove the video file if exists
sudo rm -f "${VIDEO_PATH}"

# Call the video recording tool
# ffmpeg-start-sh or vnc2swf-start.sh
ffmpeg-start-sh &
VID_TOOL_PID=$!

# Exit all child processes properly
function shutdown {
  echo "Trapped SIGTERM or SIGINT so shutting down ffmpeg gracefully..."
  sudo kill -SIGINT ${VID_TOOL_PID}
  sleep 0.7 #wait so the file is flushed
  # sudo killall -SIGINT avconv
  sudo killall -SIGINT ffmpeg
  sleep 0.3 #wait so the file is flushed
  echo "ffmpeg shutdown complete."
  exit 0
}

# Wait for the file to exists
echo "Waiting for file ${VIDEO_PATH} to be created..."
while [ ! -f "${VIDEO_PATH}" ]; do sleep 0.1; done

echo "File is "${VIDEO_PATH}" ready, will fix perms."
sudo chown ${HOST_UID}:${HOST_GID} ${VIDEO_PATH}

# How wait for video recording to start or fail
timeout --foreground ${WAIT_TIMEOUT} wait-video-rec.sh

# Run function shutdown() when this process a killer signal
trap shutdown SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait
