#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Make it portable
[ -z "${HOST_GID}" ] && export HOST_GID=$(stat -c "%g" ${VIDEOS_DIR})
[ -z "${HOST_UID}" ] && export HOST_UID=$(stat -c "%u" ${VIDEOS_DIR})
[ -z "${VIDEO_BASE_PATH}" ] && export \
    VIDEO_BASE_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}"

echo "Fixing perms for "${VIDEO_BASE_PATH}"*"
sudo chown ${HOST_UID}:${HOST_GID} "${VIDEO_BASE_PATH}"*
