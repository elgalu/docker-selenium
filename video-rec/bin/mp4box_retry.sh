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
[ -z "${MP4_INTERLEAVES_MEDIA_DATA_CHUNKS_SECS}" ] && die "Need env var set \$MP4_INTERLEAVES_MEDIA_DATA_CHUNKS_SECS"
[ -z "${final_video_path}" ] && die "Need env var set \$final_video_path"

# -inter Duration : interleaves media data in chunks of desired
# duration (in seconds). This is useful to optimize the file for
# HTTP/FTP streaming or reducing disk access.
# https://gpac.wp.imt.fr/mp4box/mp4box-documentation/
# Credits to @taskworld @dtinth https://goo.gl/JhJRI8

# Catch e.g.:
#  Error opening file /home/seluser/videos/vid_firefox_40004.mp4: IsoMedia File is truncated
while MP4Box -isma -inter ${MP4_INTERLEAVES_MEDIA_DATA_CHUNKS_SECS} ${final_video_path} 2>&1 | \
      grep "Error opening"; do
  log "MP4Box got errors meaning the mp4 video file is corrupted, trying again..."
  sleep 1
done

# Also interesting:
#  ponchio/untrunc is used to restore a damaged (truncated) video
#  untrunc /home/seluser/working_video.mp4 ${f}
