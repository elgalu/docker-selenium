#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ "${VIDEO}" = "true" ]; then
  # backup
  stop-video || true
  mkdir -p /test/videos/bup/
  mv /videos/* /test/videos/bup/
fi

selenium_test chrome
selenium_test firefox

if [ "${VIDEO}" = "true" ]; then
  # restore backup
  mv /test/videos/bup/* /videos/
  start-video
fi
