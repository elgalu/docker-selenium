#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# -- Wait for vnc2swf to connect -- #
# echo "Waiting for vnc2swf video recording to start..."
# while ! grep "Connected:" ${VIDEO_LOG_FILE} >/dev/null; do
#   echo -n '.'
#   sleep 0.2;
# done

# -- Wait for ffmpeg to connect -- #
echo "Waiting for ffmpeg video recording to start..."
while ! grep "Stream mapping:" ${VIDEO_LOG_FILE} >/dev/null; do
  echo -n '.'
  sleep 0.2;
done

echo "Video ${VIDEO_PATH} started to be recorded! (wait-video-rec.sh)"
