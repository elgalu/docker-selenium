#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh

# Make it portable
[ -z "${VIDEO_BASE_PATH}" ] && export \
    VIDEO_BASE_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}"

# Remove the video file if exists
sudo rm -f "${VIDEO_BASE_PATH}"*

# Call the video recording tool
# ffmpeg-start-sh
ffmpeg-start-sh &
VID_TOOL_PID=$!

# Exit all child processes properly
# sudo killall -SIGINT avconv
function shutdown {
  echo "Trapped SIGTERM or SIGINT so shutting down ffmpeg gracefully..."
  sleep ${VIDEO_STOP_SLEEP_SECS}
  kill -SIGTERM ${VID_TOOL_PID} || true
  sleep ${VIDEO_STOP_SLEEP_SECS}
  wait ${VID_TOOL_PID}
  fix_videos.sh
  echo "ffmpeg shutdown complete."
  exit 0
}

# Wait for the file to exists
echo "Waiting for file ${VIDEO_BASE_PATH}* to be created..."
while ! ls -l "${VIDEO_BASE_PATH}"* >/dev/null 2>&1; do sleep 0.1; done

# Now wait for video recording to start or fail
timeout --foreground ${WAIT_TIMEOUT} wait-video-rec.sh

# Run function shutdown() when this process receives a killing signal
trap shutdown SIGTERM SIGINT SIGKILL

# tells bash to wait until child processes have exited
wait
