#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
# set -e

# echo "-- INFO: Available Firefox Versions: ${FIREFOX_VERSIONS}"
echo "-- INFO: Available Firefox Versions: ${FIREFOX_VERSION}"

#---------------------
# Fix/extend ENV vars
#---------------------
# export PATH="${PATH}:${BIN_UTILS}"
export DISPLAY=":${DISP_N}"
export XEPHYR_DISPLAY=":${DISP_N}"
export VIDEO_LOG_FILE="${LOGS_DIR}/video-rec-stdout.log"
export VIDEO_PIDFILE="${RUN_DIR}/video.pid"
export SAUCE_LOG_FILE="${LOGS_DIR}/saucelabs-stdout.log"
export BSTACK_LOG_FILE="${LOGS_DIR}/browserstack-stdout.log"
export SUPERVISOR_PIDFILE="${RUN_DIR}/supervisord.pid"
export DOCKER_SELENIUM_STATUS="${LOGS_DIR}/docker-selenium-status.log"
touch ${DOCKER_SELENIUM_STATUS}
# We recalculate screen dimensions because docker run supports changing them
export SCREEN_DEPTH="${SCREEN_MAIN_DEPTH}+${SCREEN_SUB_DEPTH}"
export GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}""x""${SCREEN_DEPTH}"
# These values are only available when the container started
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
export CONTAINER_IP=$(ip addr show dev ${ETHERNET_DEVICE_NAME} | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
export COMMON_CAPS="maxInstances=${MAX_INSTANCES},platform=LINUX,acceptSslCerts=true"
export CHROME_PATH="/usr/bin/google-chrome-${CHROME_FLAVOR}"
export CHROME_VERSION=$(${CHROME_PATH} --version 2>&1 | grep "Google Chrome" | grep -iEo "[0-9.]{2,20}.*")
export CHROME_BROWSER_CAPS="browserName=chrome,${COMMON_CAPS},version=${CHROME_VERSION},chrome_binary=${CHROME_PATH}"
# For current selected firefox
export FIREFOX_DEST_BIN="${FF_DEST}/firefox"
# We may need uid & gid from host machine
export HOST_GID=$(stat -c "%g" ${VIDEOS_DIR})
export HOST_UID=$(stat -c "%u" ${VIDEOS_DIR})
# Video
export VIDEO_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}.${VIDEO_FILE_EXTENSION}"
export FFMPEG_FRAME_SIZE="${SCREEN_WIDTH}x${SCREEN_HEIGHT}"

#----------------------------------------------------------
# Extend required services depending on what the user needs
if [ "${VIDEO}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|video-rec"
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST1="video-rec"
fi

if [ "${NOVNC}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|novnc"
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST2="novnc"
fi

if [ "${GRID}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-hub"
fi

if [ "${CHROME}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-node-chrome"
fi

if [ "${FIREFOX}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-node-firefox"
fi

if [ "${SAUCE_TUNNEL}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|saucelabs"
fi

if [ "${BSTACK_TUNNEL}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|browserstack"
fi


#----------------------------------------
# Remove lock files, thanks @garagepoort
clear_x_locks.sh

#--------------------------------
# Improve etc/hosts and fix dirs
improve_etc_hosts.sh
fix_dirs.sh

#-------------------------
# Docker alongside docker
docker_alongside_docker.sh

#------------------
# Fix running user
#------------------
RUN_PREFIX="sudo -E HOME=/home/$NORMAL_USER -u $NORMAL_USER"
WHOAMI=$(whoami)
WHOAMI_EXIT_CODE=$?
echo "-- INFO: Container USER var is: '$USER', \$(whoami) returns '$WHOAMI', UID is '$UID'"

#-------------------------------
# Fix small tiny 64mb shm issue
#-------------------------------
# https://github.com/elgalu/docker-selenium/issues/20
if [ "${SHM_TRY_MOUNT_UNMOUNT}" = "true" ]; then
  sudo umount /dev/shm || true
  sudo mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${SHM_SIZE} \
    tmpfs /dev/shm || true
fi

#------
# exec
#------
if [ $WHOAMI_EXIT_CODE != 0 ]; then
  if [ $UID != $NORMAL_USER_UID]; then
    echo "-- WARN: UID '$UID' is different from the expected '$NORMAL_USER_UID'"
    echo "-- INFO: Will try to fix uid before continuing"
    # TODO: fix it ...
    echo "-- now will try to use NORMAL_USER: '$NORMAL_USER' to continue"
    exec ${RUN_PREFIX} run-supervisord.sh --nodaemon
  else
    echo "-- WARN: You seem to be running docker -u {{some-non-existing-user-in-container}}"
    echo "-- will try to use NORMAL_USER: '$NORMAL_USER' instead."
    exec ${RUN_PREFIX} run-supervisord.sh --nodaemon
  fi
elif [ "$WHOAMI" = "root" ]; then
  echo "-- WARN: Container running user is 'root' so switching to less privileged one"
  echo "-- will use NORMAL_USER: '$NORMAL_USER' instead."
  exec ${RUN_PREFIX} run-supervisord.sh --nodaemon
else
  echo "-- INFO: Will use \$USER '$USER' and \$(whoami) is '$WHOAMI'"
  exec run-supervisord.sh --nodaemon
fi

# Note: sudo -i creates a login shell for someUser, which implies the following:
# - someUser's user-specific shell profile, if defined, is loaded.
# - $HOME points to someUser's home directory, so there's no need for -H (though you may still specify it)
# - the working directory for the impersonating shell is the someUser's home directory.
