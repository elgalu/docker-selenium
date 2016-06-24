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

if [ "${VNC_START}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|vnc"
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST2="vnc"
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
# Fix autoassigned ports
#----------------------------------------
# Open a new file descriptor that redirects to stdout:
exec 3>&1

function get_free_display() {
  local get_random_disp_num=false
  local selected_disp_num=${DISP_N}
  local find_display_num=0

  if [ "${PICK_ALL_RANDMON_PORTS}" = "true" ] && [ "${selected_disp_num}" = "${DEFAULT_DISP_N}" ]; then
    get_random_disp_num=true
  fi

  if [ "${selected_disp_num}" = "-1" ] || [ "${get_random_disp_num}" = "true" ]; then
    selected_disp_num="-1"
    # Get a list of socket DISPLAYs already used
    netstat -nlp | grep -Po '(?<=\/tmp\/\.X11-unix\/X)([0-9]+)' | sort -u > /tmp/netstatX11.log
    #DEBUG: cat /tmp/netstatX11.log 1>&3

    # -s  file is not zero size
    if [ -s /tmp/netstatX11.log ]; then
      # important: while loops are executed in a subshell
      # var assignments will be lost unless using <<<
      while true ; do
        let find_display_num=${find_display_num}+1
        # read -r Do not treat a backslash character in any special way.
        #         Consider each backslash to be part of the input line.
        while read read_disp_num ; do
          if [ "${read_disp_num}" = "${find_display_num}" ]; then
            echo "-- WARN: DISPLAY=${find_display_num} is taken, searching for another..." 1>&3
            selected_disp_num="-1"
            break
          elif [ "${selected_disp_num}" = "-1" ]; then
            selected_disp_num="${find_display_num}"
            echo "-- INFO: Possible free DISPLAY=${find_display_num}" 1>&3
            # echo "-- DEBUG: Updated selected_disp_num=$selected_disp_num" 1>&3
            # echo "-- DEBUG: WAS read_disp_num=$read_disp_num" 1>&3
          fi
        done <<< "$(cat /tmp/netstatX11.log)"
        # echo "-- DEBUG: selected_disp_num=$selected_disp_num" 1>&3
        [ "${selected_disp_num}" != "-1" ] && break
        # echo "-- DEBUG: find_display_num=$find_display_num" 1>&3
        if [ ${find_display_num} -gt ${MAX_DISPLAY_SEARCH} ]; then
          echo "-- ERROR: Entered in an infinite loop at $0 after netstat" 1>&2 1>&3
          break
        fi
      done
    else
      echo "-- INFO: Emtpy file /tmp/netstatX11.log" 1>&3
      selected_disp_num="${DEFAULT_DISP_N}"
    fi
    [ "${selected_disp_num}" = "-1" ] || echo "-- INFO: Found free DISPLAY=${selected_disp_num}" 1>&3
  fi

  echo ${selected_disp_num}
}

export DISP_N=$(get_free_display)
export DISPLAY=":${DISP_N}"
export XEPHYR_DISPLAY=":${DISP_N}"

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

if [ "${VNC_PORT}" = "0" ]; then
  export VNC_PORT=$(get_unused_port)
elif [ "${PICK_ALL_RANDMON_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${VNC_PORT}" = "${DEFAULT_VNC_PORT}" ]; then
    export VNC_PORT=$(get_unused_port)
  fi
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
