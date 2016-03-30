#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "#=====================#"
echo "# Self test on Chrome #"
echo "#=====================#"

if [ "${VIDEO}" = "true" ]; then
  stop-video || true
  mkdir -p /test/videos/bup/
  mv /videos/* /test/videos/bup/
  start-video
fi

hola chrome

if [ "${VIDEO}" = "true" ]; then
  stop-video
  mkdir -p /test/videos/chrome
  mv /videos/* /test/videos/chrome/
fi

echo "#======================#"
echo "# Self test on Firefox #"
echo "#======================#"

[ "${VIDEO}" = "true" ] && start-video

hola firefox

if [ "${VIDEO}" = "true" ]; then
  stop-video
  mkdir -p /test/videos/firefox
  mv /videos/* /test/videos/firefox/
  mv /test/videos/bup/* /videos/
  start-video #restore
fi

# How to archive console.png and videos from the docker host:
#  docker cp grid:/test/console.png .
#  docker cp grid:/test/videos/chrome/test.mkv chrome.mkv
#  docker cp grid:/test/videos/firefox/test.mkv firefox.mkv
