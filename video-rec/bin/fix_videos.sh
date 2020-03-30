#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "150"
  errnum=${2-115}
  exit $errnum
}

# Required params
[ -z "${tmp_video_path}" ] && die "Need env var set \$tmp_video_path"
[ -z "${final_video_path}" ] && die "Need env var set \$final_video_path"

# May need to fix perms when mounting volumes
#  Issue: http://stackoverflow.com/questions/23544282/
#  Solution: http://stackoverflow.com/a/28596874/511069
if [ -z "${HOST_GID}" ] && [ -z "${HOST_UID}" ]; then
  [ -z "${VIDEOS_DIR}" ] && die "Need env var set \$VIDEOS_DIR"
  export HOST_GID=$(stat -c "%g" ${VIDEOS_DIR})
  export HOST_UID=$(stat -c "%u" ${VIDEOS_DIR})
elif [ "${USE_KUBERNETES}" == "true" ]; then
  log "No sudo support in K8s so will skip setting up sudo groupadd -g ${HOST_GID} tempgroup"
else
  GROUP_EXISTS=$(cat /etc/group | grep ${HOST_GID} | wc -l)
  # Create new group using target GID and add seluser user
  if [ ${GROUP_EXISTS} == "0" ]; then
    sudo groupadd -g ${HOST_GID} tempgroup
    sudo gpasswd -a seluser tempgroup
  else
    # GID exists, find group name and add
    EXISTING_GROUP=$(getent group ${HOST_GID} | cut -d: -f1)
    sudo gpasswd -a seluser ${EXISTING_GROUP}
  fi
fi

# Portable defaults
# [ -z "${VIDEO_BASE_PATH}" ] && export \
#     VIDEO_BASE_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}"

log "Fixing perms for "${tmp_video_path}"*"
sudo chown ${HOST_UID}:${HOST_GID} "${tmp_video_path}"* || true

if [ "${VIDEO_TMP_FILE_EXTENSION}" != "${VIDEO_FILE_EXTENSION}" ]; then
  log "Changing video encoding from ${VIDEO_TMP_FILE_EXTENSION} to ${VIDEO_FILE_EXTENSION}..."

  # TODO: Move this mkv to mp4 conversion to a post-processing Zalenium thread
  # ffmpeg -i ${tmp_video_path} ${final_video_path}
  if timeout --foreground "${VIDEO_CONVERSION_MAX_WAIT}" \
        ffmpeg -i ${tmp_video_path} -vcodec libx264 ${FFMPEG_CODEC_V_ARGS} ${final_video_path}; \
        then
    log "Conversion from ${VIDEO_TMP_FILE_EXTENSION} to ${VIDEO_FILE_EXTENSION} succeeded!"
    log "Cleaning up ${tmp_video_path} ..."
    rm -f "${tmp_video_path}"
  else
    log "Conversion from ${VIDEO_TMP_FILE_EXTENSION} to ${VIDEO_FILE_EXTENSION} FAILED! in within the ${VIDEO_CONVERSION_MAX_WAIT}"
    rm -f "${final_video_path}"
    mv "${tmp_video_path}" "${final_video_path}"
  fi

fi

if [ "${VIDEO_FILE_EXTENSION}" == "mp4" ]; then
  log "Optimizing ${final_video_path} for HTTP streaming..."

  # Portable defaults
  [ -z "${VIDEO_MP4_FIX_MAX_WAIT}" ] && export \
      VIDEO_MP4_FIX_MAX_WAIT="8s"

  if timeout --foreground "${VIDEO_MP4_FIX_MAX_WAIT}" mp4box_retry.sh; then
    log "Succeeded to mp4box_retry.sh within ${VIDEO_MP4_FIX_MAX_WAIT}"
  else
    log "Failed! to mp4box_retry.sh within ${VIDEO_MP4_FIX_MAX_WAIT}"
  fi
fi
