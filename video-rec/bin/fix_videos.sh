#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Optimize for HTTP streaming and fix end time
for f in *.mp4; do
  echo "Optimizing ${f} for HTTP streaming..."
  # -inter Duration : interleaves media data in chunks of desired
  # duration (in seconds). This is useful to optimize the file for
  # HTTP/FTP streaming or reducing disk access.
  # https://gpac.wp.imt.fr/mp4box/mp4box-documentation/
  MP4Box -isma -inter ${MP4_INTERLEAVES_MEDIA_DATA_CHUNKS_SECS} ${f}
  # Credits to @taskworld @dtinth https://goo.gl/JhJRI8
done

# May need to fix perms when mounting volumes
#  Issue: http://stackoverflow.com/questions/23544282/
#  Solution: http://stackoverflow.com/a/28596874/511069
if [ -z "${HOST_GID}" ] && [ -z "${HOST_UID}" ]; then
  export HOST_GID=$(stat -c "%g" ${VIDEOS_DIR})
  export HOST_UID=$(stat -c "%u" ${VIDEOS_DIR})
else
  GROUP_EXISTS=$(cat /etc/group | grep ${HOST_GID} | wc -l)
  # Create new group using target GID and add seluser user
  if [ $GROUP_EXISTS == "0" ]; then
    sudo groupadd -g ${HOST_GID} tempgroup
    sudo gpasswd -a seluser tempgroup
  else
    # GID exists, find group name and add
    EXISTING_GROUP=$(getent group ${HOST_GID} | cut -d: -f1)
    sudo gpasswd -a seluser ${EXISTING_GROUP}
  fi
fi

[ -z "${VIDEO_BASE_PATH}" ] && export \
    VIDEO_BASE_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}"

echo "Fixing perms for "${VIDEO_BASE_PATH}"*"
sudo chown ${HOST_UID}:${HOST_GID} "${VIDEO_BASE_PATH}"*
