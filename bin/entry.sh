#!/usr/bin/env bash

#-----------------------------------------------
# Perform cleanup to support `docker restart`
stop 2>&1 >/dev/null || true
rm -f ${LOGS_DIR}/*
rm -f ${RUN_DIR}/*

# echo "-- INFO: Available Firefox Versions: ${FIREFOX_VERSIONS}"
echo "-- INFO: Available Firefox Versions: ${FIREFOX_VERSION}"

#---------------------
# Fix/extend ENV vars
#---------------------
# export PATH="${PATH}:${BIN_UTILS}"
export VIDEO_LOG_FILE="${LOGS_DIR}/video-rec-stdout.log"
export VIDEO_PIDFILE="${RUN_DIR}/video.pid"
export SAUCE_LOG_FILE="${LOGS_DIR}/saucelabs-stdout.log"
export BSTACK_LOG_FILE="${LOGS_DIR}/browserstack-stdout.log"
export SUPERVISOR_PIDFILE="${RUN_DIR}/supervisord.pid"
export DOCKER_SELENIUM_STATUS="${LOGS_DIR}/docker-selenium-status.log"
export VNC_TRYOUT_ERR_LOG="${LOGS_DIR}/vnc-tryouts-stderr"
export VNC_TRYOUT_OUT_LOG="${LOGS_DIR}/vnc-tryouts-stdout"
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
# We may need uid & gid from host machine
export HOST_GID=$(stat -c "%g" ${VIDEOS_DIR})
export HOST_UID=$(stat -c "%u" ${VIDEOS_DIR})
# Video
export FFMPEG_FRAME_SIZE="${SCREEN_WIDTH}x${SCREEN_HEIGHT}"

# {{CONTAINER_IP}} is a place holder for dynamically setting the IP of a node
if [ "${SELENIUM_NODE_HOST}" = "{{CONTAINER_IP}}" ]; then
  export SELENIUM_NODE_HOST="${CONTAINER_IP}"
fi

#----------------------------------------------------------
# Extend required services depending on what the user needs
if [ "${VIDEO}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|video-rec"
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST1="video-rec"
fi

sudo sh -c "echo 'X11Forwarding ${SSHD_X11FORWARDING}' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'GatewayPorts ${SSHD_GATEWAYPORTS}'   >> /etc/ssh/sshd_config"
if [ "${SSHD}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|sshd"
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST2="sshd"
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

if [ "${SELENIUM_HUB_PORT}" = "" ]; then
  echo "FATAL: SELENIUM_HUB_PORT is empty but should be a number" 1>&2
  exit 120
fi

# TODO: Remove this duplicated logic
if [ "${SELENIUM_HUB_PORT}" = "0" ]; then
  export SELENIUM_HUB_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_HUB_PORT}" = "${DEFAULT_SELENIUM_HUB_PORT}" ]; then
    export SELENIUM_HUB_PORT=$(get_unused_port)
  fi
fi

if [ "${SELENIUM_NODE_CH_PORT}" = "0" ]; then
  export SELENIUM_NODE_CH_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_CH_PORT}" = "${DEFAULT_SELENIUM_NODE_CH_PORT}" ]; then
    export SELENIUM_NODE_CH_PORT=$(get_unused_port)
  fi
fi

if [ "${SELENIUM_NODE_FF_PORT}" = "0" ]; then
  export SELENIUM_NODE_FF_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_FF_PORT}" = "${DEFAULT_SELENIUM_NODE_FF_PORT}" ]; then
    export SELENIUM_NODE_FF_PORT=$(get_unused_port)
  fi
fi

# Video
if [ "${VIDEO_FILE_NAME}" = "" ]; then
  export VIDEO_FILE_NAME="vid"
  [ "${CHROME}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_chrome_${SELENIUM_NODE_CH_PORT}"
  [ "${FIREFOX}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_firefox_${SELENIUM_NODE_FF_PORT}"
fi
export VIDEO_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}.${VIDEO_FILE_EXTENSION}"


if [ "${VNC_START}" = "true" ]; then
  # TODO: Re enable shutdown at some point. But fails when
  # we have little ports available (corner case but fails)
  # export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|vnc"
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST2="vnc"

  # We need a fixed port range to expose VNC
  # due to a bug in Docker for Mac beta (1.12)
  # https://forums.docker.com/t/docker-for-mac-beta-not-forwarding-ports/8658/6
  if [ "${VNC_FROM_PORT}" != "" ] && [ "${VNC_TO_PORT}" != "" ]; then
    export VNC_PORT=$(get_unused_port_from_range ${VNC_FROM_PORT} ${VNC_TO_PORT})
  else
    if [ "${VNC_PORT}" = "0" ]; then
      export VNC_PORT=$(get_unused_port)
    elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
      # User want to pick random ports but may also want to fix some others
      if [ "${VNC_PORT}" = "${DEFAULT_VNC_PORT}" ]; then
        export VNC_PORT=$(get_unused_port)
      fi
    fi
  fi
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST2="vnc"
fi


if [ "${NOVNC_PORT}" = "0" ]; then
  export NOVNC_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${NOVNC_PORT}" = "${DEFAULT_NOVNC_PORT}" ]; then
    export NOVNC_PORT=$(get_unused_port)
  fi
fi

if [ "${SSHD_PORT}" = "0" ]; then
  export SSHD_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SSHD_PORT}" = "${DEFAULT_SSHD_PORT}" ]; then
    export SSHD_PORT=$(get_unused_port)
  fi
fi

if [ "${SAUCE_LOCAL_SEL_PORT}" = "0" ]; then
  export SAUCE_LOCAL_SEL_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SAUCE_LOCAL_SEL_PORT}" = "${DEFAULT_SAUCE_LOCAL_SEL_PORT}" ]; then
    export SAUCE_LOCAL_SEL_PORT=$(get_unused_port)
  fi
fi

if [ "${SUPERVISOR_HTTP_PORT}" = "0" ]; then
  export SUPERVISOR_HTTP_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SUPERVISOR_HTTP_PORT}" = "${DEFAULT_SUPERVISOR_HTTP_PORT}" ]; then
    export SUPERVISOR_HTTP_PORT=$(get_unused_port)
  fi
fi

# Allow node's -proxy customizations without having to use SELENIUM_NODE_PARAMS
if [ "${SELENIUM_NODE_PROXY_PARAMS}" != "" ]; then
  export CUSTOM_SELENIUM_NODE_PROXY_PARAMS="-proxy ${SELENIUM_NODE_PROXY_PARAMS}"
else
  export CUSTOM_SELENIUM_NODE_PROXY_PARAMS=""
fi

# Allow node's -registerCycle customizations without having to use SELENIUM_NODE_PARAMS
if [ "${SELENIUM_NODE_REGISTER_CYCLE}" != "" ]; then
  export CUSTOM_SELENIUM_NODE_REGISTER_CYCLE="-registerCycle ${SELENIUM_NODE_REGISTER_CYCLE}"
else
  export CUSTOM_SELENIUM_NODE_REGISTER_CYCLE=""
fi

#----------------------------------------
# Remove lock files, thanks @garagepoort
# clear_x_locks.sh

#--------------------------------
# Improve etc/hosts and fix dirs
improve_etc_hosts.sh
fix_dirs.sh

#-------------------------
# Docker alongside docker
docker_alongside_docker.sh

#----------------------------------------
# Fix autoassigned ports
#----------------------------------------
# Open a new file descriptor that redirects to stdout:
exec 3>&1

function get_free_display() {
  local selected_disp_num="-1"
  local find_display_num=-1

  # Get a list of socket DISPLAYs already used
  netstat -nlp | grep -Po '(?<=\/tmp\/\.X11-unix\/X)([0-9]+)' | sort -u > /tmp/netstatX11.log
  [ ! -s /tmp/netstatX11.log ] && echo "-- INFO: Emtpy file /tmp/netstatX11.log" 1>&3

  # important: while loops are executed in a subshell
  #  var assignments will be lost unless using <<<
  # using 11.0 12.3 1.8 and so on didn't work, left as a reference
  #  local pythonCmd="from random import shuffle;list1 = list(range($MAX_DISPLAY_SEARCH));shuffle(list1);list2 = [x/10 for x in list1];str_res = ' '.join(str(e) for e in list2);print (str_res)"
  local pythonCmd="from random import shuffle;list1 = list(range($MAX_DISPLAY_SEARCH));shuffle(list1);print (' '.join(str(e) for e in list1))"
  local displayNums=$(python -c "${pythonCmd}")
  # Always find a free DISPLAY port starting with current DISP_N if it was provided
  [ "${DISP_N}" != "-1" ] && displayNums="${DISP_N} ${displayNums}"
  IFS=' ' read -r -a arrayDispNums <<< "$displayNums"
  for find_display_num in ${arrayDispNums[@]}; do
    # read -r Do not treat a backslash character in any special way.
    #         Consider each backslash to be part of the input line.
    # -s  file is not zero size
    if [ -s /tmp/netstatX11.log ]; then
      while read read_disp_num ; do
        if [ "${read_disp_num}" = "${find_display_num}" ]; then
          echo "-- WARN: DISPLAY=:${find_display_num} is taken, searching for another..." 1>&3
          selected_disp_num="-1"
          break
        elif [ "${selected_disp_num}" = "-1" ]; then
          selected_disp_num="${find_display_num}"
          echo "-- INFO: Possible free DISPLAY=:${find_display_num}" 1>&3
          # echo "-- DEBUG: Updated selected_disp_num=$selected_disp_num" 1>&3
          # echo "-- DEBUG: WAS read_disp_num=$read_disp_num" 1>&3
        fi
      done <<< "$(cat /tmp/netstatX11.log)"
    else
      # echo "-- INFO: Emtpy file /tmp/netstatX11.log" 1>&3
      # selected_disp_num="${DEFAULT_DISP_N}"
      selected_disp_num="${find_display_num}"
    fi
    if [ "${selected_disp_num}" != "-1" ]; then
      # If we can already use that display it means there is already some
      # Xvfb there which means we need to keep looking for a free one.
      export DISPLAY=":${find_display_num}"
      if xsetroot -cursor_name left_ptr -fg white -bg black > /dev/null 2>&1; then
        echo "-- WARN: DISPLAY=:${find_display_num} is already being used, skip it..." 1>&3
        selected_disp_num="-1"
      fi
    fi
    if [ "${selected_disp_num}" != "-1" ]; then
      break
    elif [ ${find_display_num} -gt ${MAX_DISPLAY_SEARCH} ]; then
      echo "-- ERROR: Entered in an infinite loop at $0 after netstat" 1>&2 1>&3
      selected_disp_num="-1"
      break
    fi
  done
  [ "${selected_disp_num}" = "-1" ] || echo "-- INFO: Found free DISPLAY=:${selected_disp_num}" 1>&3

  echo ${selected_disp_num}
}

function start_xvfb() {
  # Start the X server that can run on machines with no real display
  # using Xvfb instead of Xdummy
  echo "-- INFO: Will try to start Xvfb at DISPLAY=${DISPLAY}" 1>&3
  # if DEBUG = true ...
  # echo "Will use the following values for Xvfb"
  # echo "  screen=${SCREEN_NUM} geometry=${GEOMETRY}"
  # echo "  XVFB_CLI_OPTS_TCP=${XVFB_CLI_OPTS_TCP}"
  # echo "  XVFB_CLI_OPTS_BASE=${XVFB_CLI_OPTS_BASE}"
  # echo "  XVFB_CLI_OPTS_EXT=${XVFB_CLI_OPTS_EXT}"
  Xvfb ${DISPLAY} -screen ${SCREEN_NUM} ${GEOMETRY} \
    ${XVFB_CLI_OPTS_TCP} ${XVFB_CLI_OPTS_BASE} ${XVFB_CLI_OPTS_EXT} \
    1> "${LOGS_DIR}/xvfb-tryouts-stdout.log" \
    2> "${LOGS_DIR}/xvfb-tryouts-stderr.log" &
}

if [ ! -z "${XE_DISP_NUM}" ]; then
  echo "INFO: XE_DISP_NUM '${XE_DISP_NUM}' was provided so switching to that DISPLAY"
  echo "INFO:   and skipping virtual framebuffer startup in favor of remote."
  export DISP_N="${XE_DISP_NUM}"
  export DISPLAY=":${DISP_N}"
  start_xvfb
# elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ] || [ "${DISP_N}" = "-1" ]; then
else
  # Find a free DISPLAY port starting with current DISP_N if any
  i=0
  while true ; do
    let i=${i}+1
    export DISP_N=$(get_free_display)
    export DISPLAY=":${DISP_N}"
    export XEPHYR_DISPLAY=":${DISP_N}"
    if ! start_xvfb; then
      echo "-- WARN: start_xvfb() failed!" 1>&3
    fi
    if timeout --foreground "${WAIT_FOREGROUND_RETRY}" wait-xvfb.sh &> "${LOGS_DIR}/wait-xvfb-stdout.log"; then
      break
    else
      echo "-- WARN: wait-xvfb.sh failed! for DISPLAY=${DISPLAY}" 1>&3
    fi
    if [ ${i} -gt ${MAX_DISPLAY_SEARCH} ]; then
      echo "-- ERROR: Failed to start Xvfb at $0 after many retries." 1>&2 1>&3
      break
    fi
  done
# else
#   export XEPHYR_DISPLAY=":${DISP_N}"
#   export DISPLAY=":${DISP_N}"
#   start_xvfb
fi


# Validations
if [ ":$DISP_N" != "${DISPLAY}" ]; then
  echo "FATAL: DISP_N '${DISP_N}' doesn't match DISPLAY '${DISPLAY}'" 1>&2
  exit 122
fi

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

#-------------------------------------------
# Keep updated environment vars inside files
#-------------------------------------------
# So can be consulted later on with:
#  docker exec grid cat HUB_PORT #=> 24444
#  docker exec grid cat DISPLAY  #=> :41
#  docker exec selenium_chrome_1 cat FF_PORT #=> 44023
echo "${SELENIUM_HUB_PORT}" > SELENIUM_HUB_PORT
echo "${SELENIUM_HUB_PORT}" > HUB_PORT
echo "${SELENIUM_NODE_CH_PORT}" > SELENIUM_NODE_CH_PORT
echo "${SELENIUM_NODE_CH_PORT}" > CH_PORT
echo "${SELENIUM_NODE_FF_PORT}" > SELENIUM_NODE_FF_PORT
echo "${SELENIUM_NODE_FF_PORT}" > FF_PORT
echo "${DISPLAY}" > DISPLAY
echo "${VNC_PORT}" > VNC_PORT
echo "${NOVNC_PORT}" > NOVNC_PORT
echo "${SSHD_PORT}" > SSHD_PORT
echo "${SAUCE_LOCAL_SEL_PORT}" > SAUCE_LOCAL_SEL_PORT
echo "${SUPERVISOR_HTTP_PORT}" > SUPERVISOR_HTTP_PORT
env > env

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
