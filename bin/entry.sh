#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Workaround that might help to get dbus working in docker
#  http://stackoverflow.com/a/38355729/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/87#issuecomment-187659234
#  - still unclear if this helps: `-v /var/run/dbus:/var/run/dbus`
#  - this works generates errors: DBUS_SESSION_BUS_ADDRESS="/dev/null"
#  - this gives less erros: DBUS_SESSION_BUS_ADDRESS="unix:abstract=/dev/null"
sudo rm -f /var/lib/dbus/machine-id
sudo mkdir -p /var/run/dbus
sudo service dbus restart
# Test dbus works
service dbus status
export $(dbus-launch)
export NSS_USE_SHARED_DB=ENABLED
echo "-- INFO: DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS}"
#=> e.g. DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-APZO4BE4TJ,guid=6e9c098d053d3038cb0756ae57ecc885
echo "-- INFO: DBUS_SESSION_BUS_PID=${DBUS_SESSION_BUS_PID}"
#=> e.g. DBUS_SESSION_BUS_PID=44
#
#-----------------------------------------------
# Perform cleanup to support `docker restart`
stop >/dev/null 2>&1 || true
rm -f ${LOGS_DIR}/*
rm -f ${RUN_DIR}/*

# Selenium IDE RC (legacy) doesn't seem to keep working on Selenium 3
if [ "${USE_SELENIUM}" == "3" ]; then
  export RC_CHROME="false"
  export RC_FIREFOX="false"
  # Support restart docker container for selenium 3 @aituganov
  if [ ! -f /usr/bin/geckodriver ]; then
    sudo mv /opt/geckodriver /usr/bin/geckodriver
    sudo ln -fs /usr/bin/geckodriver /opt/geckodriver
  fi
fi

if [ "${USE_SELENIUM}" == "3" ]; then
  sudo cp /capabilities3.json /capabilities.json
  sudo cp /capabilities3.json /home/seluser/capabilities.json
  sudo cp /capabilities3.json /home/seluser/caps.json
else
  sudo cp /capabilities2.json /capabilities.json
  sudo cp /capabilities2.json /home/seluser/capabilities.json
  sudo cp /capabilities2.json /home/seluser/caps.json
fi

# We need larger screens for Selenium IDE RC tests
# if [ "${RC_CHROME}" = "true" ] || [ "${RC_FIREFOX}" = "true" ]; then
#   export SCREEN_HEIGHT=$((SCREEN_HEIGHT*2))
# fi

#---------------------
# Fix/extend ENV vars
#---------------------
export SELENIUM_JAR_PATH="/home/seluser/selenium-server-standalone-${USE_SELENIUM}.jar"
export FIREFOX_DEST_BIN="/home/seluser/firefox-for-sel-${USE_SELENIUM}/firefox"
sudo ln -fs ${FIREFOX_DEST_BIN} /usr/bin/firefox
export FIREFOX_VERSION=$(firefox_version)
export CHROME_VESION=$(chrome_stable_version)
export DOSEL_VERSION=$(cat VERSION)

echo "-- INFO: Chrome..... Version: ${CHROME_VESION}"
echo "-- INFO: Firefox.... Version: ${FIREFOX_VERSION}"
echo "-- INFO: Selenium... Version: ${USE_SELENIUM}"
echo "-- INFO: Dosel...... Version: ${DOSEL_VERSION}"

# export PATH="${PATH}:${BIN_UTILS}"
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

# Common capabilities for both nodes (Chrome/Firefox)
export COMMON_CAPS="maxInstances=${MAX_INSTANCES}"
export COMMON_CAPS="${COMMON_CAPS},platform=LINUX"
export COMMON_CAPS="${COMMON_CAPS},acceptSslCerts=true"
# https://wiki.saucelabs.com/display/DOCS/Test+Configuration+Options#TestConfigurationOptions-SpecifyingtheScreenResolution
export COMMON_CAPS="${COMMON_CAPS},screenResolution=${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
# https://www.browserstack.com/automate/capabilities
export COMMON_CAPS="${COMMON_CAPS},resolution=${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
# https://testingbot.com/support/other/test-options#screenresolution
export COMMON_CAPS="${COMMON_CAPS},screen-resolution=${SCREEN_WIDTH}x${SCREEN_HEIGHT}"

# CHROME_FLAVOR would allow to have separate installations for stable, beta, unstable
export CHROME_PATH="/usr/bin/google-chrome-${CHROME_FLAVOR}"
export CHROME_VERSION=$(${CHROME_PATH} --version 2>&1 | grep "Google Chrome" | grep -iEo "[0-9.]{2,20}.*")

# Video
export FFMPEG_FRAME_SIZE="${SCREEN_WIDTH}x${SCREEN_HEIGHT}"

# {{CONTAINER_IP}} is a place holder for dynamically setting the IP of a node
if [ "${SELENIUM_NODE_HOST}" = "{{CONTAINER_IP}}" ]; then
  export SELENIUM_NODE_HOST="${CONTAINER_IP}"
fi

# Random ID used for Google Analytics
# If it is running inside the Zalando Jenkins env,
# we pick the team name from the ${BUILD_URL}
# else we pick it from the kernel id
# docker installation, not related to the user nor the machine
if [[ ${BUILD_URL} == *"zalan.do"* ]]; then
    RANDOM_USER_GA_ID=$(echo ${BUILD_URL} | cut -d'/' -f 3 | cut -d'.' -f 1)
elif [ "${CI}" = "true" ]; then
    RANDOM_USER_GA_ID="travis"
else
    RANDOM_USER_GA_ID=$(cat /proc/version 2>&1 | sed -e 's/ /_/g' | sed -e 's/[()]//g' | sed -e 's/@.*_gcc_version/_gcc/g' | sed -e 's/__/_/g' | sed -e 's/Linux_version_//g' | sed -e 's/generic_build/genb/g')
    RANDOM_USER_GA_ID="${DOSEL_VERSION}_${RANDOM_USER_GA_ID}"
fi

#----------------------------------------------------------
# Extend required services depending on what the user needs
export SUPERVISOR_NOT_REQUIRED_SRV_LIST1="video-rec"
# if [ "${VIDEO}" = "true" ]; then
#   export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|video-rec"
# else
#   export SUPERVISOR_NOT_REQUIRED_SRV_LIST1="video-rec"
# fi

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

if [ "${RC_CHROME}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-rc-chrome"
fi

if [ "${RC_FIREFOX}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-rc-firefox"
fi

if [ "${SELENIUM_HUB_PORT}" = "" ]; then
  echo "FATAL: SELENIUM_HUB_PORT is empty but should be a number" 1>&2
  exit 120
fi

# Fix old typo
if [ "${PICK_ALL_RANDMON_PORTS}" == "true" ]; then
  export PICK_ALL_RANDOM_PORTS="${PICK_ALL_RANDMON_PORTS}"
fi

# Fix extra quotes in Time zone $TZ env var
export TZ=$(echo ${TZ} | sed "s/^\([\"']\)\(.*\)\1\$/\2/g")

# TODO: Remove this duplicated logic
if [ "${SELENIUM_HUB_PORT}" = "0" ]; then
  export SELENIUM_HUB_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_HUB_PORT}" = "${DEFAULT_SELENIUM_HUB_PORT}" ]; then
    export SELENIUM_HUB_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

if [ "${SELENIUM_NODE_CH_PORT}" = "0" ]; then
  export SELENIUM_NODE_CH_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_CH_PORT}" = "${DEFAULT_SELENIUM_NODE_CH_PORT}" ]; then
    export SELENIUM_NODE_CH_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

if [ "${SELENIUM_NODE_FF_PORT}" = "0" ]; then
  export SELENIUM_NODE_FF_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_FF_PORT}" = "${DEFAULT_SELENIUM_NODE_FF_PORT}" ]; then
    export SELENIUM_NODE_FF_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

if [ "${SELENIUM_NODE_RC_CH_PORT}" = "0" ]; then
  export SELENIUM_NODE_RC_CH_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_RC_CH_PORT}" = "${DEFAULT_SELENIUM_NODE_RC_CH_PORT}" ]; then
    export SELENIUM_NODE_RC_CH_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

if [ "${SELENIUM_NODE_RC_FF_PORT}" = "0" ]; then
  export SELENIUM_NODE_RC_FF_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_RC_FF_PORT}" = "${DEFAULT_SELENIUM_NODE_RC_FF_PORT}" ]; then
    export SELENIUM_NODE_RC_FF_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

# Video
export VIDEO_LOG_FILE="${LOGS_DIR}/video-rec-stdout.log"
export VIDEO_PIDFILE="${RUN_DIR}/video.pid"
if [ "${VIDEO_FILE_NAME}" = "" ]; then
  export VIDEO_FILE_NAME="vid"
  [ "${CHROME}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_chrome_${SELENIUM_NODE_CH_PORT}"
  [ "${FIREFOX}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_firefox_${SELENIUM_NODE_FF_PORT}"
fi
export VIDEO_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}.${VIDEO_FILE_EXTENSION}"
echo "${VIDEO_LOG_FILE}" > VIDEO_LOG_FILE
echo "${VIDEO_PIDFILE}" > VIDEO_PIDFILE
echo "${VIDEO_FILE_NAME}" > VIDEO_FILE_NAME
echo "${VIDEO_PATH}" > VIDEO_PATH

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
      export VNC_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
    elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
      # User want to pick random ports but may also want to fix some others
      if [ "${VNC_PORT}" = "${DEFAULT_VNC_PORT}" ]; then
        export VNC_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
      fi
    fi
  fi
else
  export SUPERVISOR_NOT_REQUIRED_SRV_LIST2="vnc"
fi


if [ "${NOVNC_PORT}" = "0" ]; then
  export NOVNC_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${NOVNC_PORT}" = "${DEFAULT_NOVNC_PORT}" ]; then
    export NOVNC_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

if [ "${SUPERVISOR_HTTP_PORT}" = "0" ]; then
  export SUPERVISOR_HTTP_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SUPERVISOR_HTTP_PORT}" = "${DEFAULT_SUPERVISOR_HTTP_PORT}" ]; then
    export SUPERVISOR_HTTP_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
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

ga_track_start () {
  if [ "${SEND_ANONYMOUS_USAGE_INFO}" == "true" ]; then
    DisplayDataProcessingAgreement

    START_META_DATA=""
    START_META_DATA="${START_META_DATA} -proxy='${SELENIUM_NODE_PROXY_PARAMS}'"
    START_META_DATA="${START_META_DATA} -registerCycle='${SELENIUM_NODE_REGISTER_CYCLE}'"
    START_META_DATA="${START_META_DATA} CHROME_ARGS='${CHROME_ARGS}'"
    START_META_DATA="${START_META_DATA} SELENIUM_HUB_HOST='${SELENIUM_HUB_HOST}'"
    START_META_DATA="${START_META_DATA} SELENIUM_NODE_HOST='${SELENIUM_NODE_HOST}'"
    START_META_DATA="${START_META_DATA} SELENIUM_HUB_PARAMS='${SELENIUM_HUB_PARAMS}'"
    START_META_DATA="${START_META_DATA} SELENIUM_NODE_PARAMS='${SELENIUM_NODE_PARAMS}'"
    START_META_DATA="${START_META_DATA} RC_CHROME='${RC_CHROME}'"
    START_META_DATA="${START_META_DATA} RC_FIREFOX='${RC_FIREFOX}'"
    START_META_DATA="${START_META_DATA} MEM_JAVA_PERCENT='${MEM_JAVA_PERCENT}'"
    START_META_DATA="${START_META_DATA} WAIT_TIMEOUT='${WAIT_TIMEOUT}'"
    START_META_DATA="${START_META_DATA} WAIT_FOREGROUND_RETRY='${WAIT_FOREGROUND_RETRY}'"
    START_META_DATA="${START_META_DATA} WAIT_VNC_FOREGROUND_RETRY='${WAIT_VNC_FOREGROUND_RETRY}'"
    START_META_DATA="${START_META_DATA} MAX_DISPLAY_SEARCH='${MAX_DISPLAY_SEARCH}'"
    START_META_DATA="${START_META_DATA} TRAVIS_REPO_SLUG='${TRAVIS_REPO_SLUG}'"
    START_META_DATA="${START_META_DATA} TRAVIS_JOB_NUMBER='${TRAVIS_JOB_NUMBER}'"

    # https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
    local args=(
        --max-time 10
        --data v=${GA_API_VERSION}
        --data aip=1
        --data t="screenview"
        --data tid="${GA_TRACKING_ID}"
        --data cid="${RANDOM_USER_GA_ID}"
        --data an="dosel"
        --data av="${DOSEL_VERSION}"
        --data sc="start"
        --data ds="docker"
        --data sr="${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
        --data sd="${SCREEN_SUB_DEPTH}"
        --data ul="${TZ}"
        --data cd="start ${START_META_DATA}"
        --data cd1="${USE_SELENIUM}"
        --data cd2="${CHROME_VESION}"
        --data cd3="${CHROME_FLAVOR}"
        --data cd4="${FIREFOX_VERSION}"
        --data cd5="${SCREEN_WIDTH}"
        --data cd6="${SCREEN_HEIGHT}"
        --data cd7="${SCREEN_DEPTH}"
        --data cd8="${MAX_INSTANCES}"
        --data cd9="${MAX_SESSIONS}"
        --data cd10="${GRID}"
        --data cd11="${CHROME}"
        --data cd12="${FIREFOX}"
        --data cd13="${VNC_START}"
        --data cd14="${NOVNC}"
        --data cd15="${PICK_ALL_RANDOM_PORTS}"
        --data cd16="${SELENIUM_HUB_PORT}"
        --data cd17="${SELENIUM_NODE_CH_PORT}"
        --data cd18="${SELENIUM_NODE_FF_PORT}"
        --data cd19="${NOVNC_PORT}"
    )

    curl ${GA_ENDPOINT} "${args[@]}" \
        --silent --output /dev/null >/dev/null 2>&1 & disown
  fi
}

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
# elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ] || [ "${DISP_N}" = "-1" ]; then
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
echo "${SELENIUM_NODE_RC_CH_PORT}" > SELENIUM_NODE_RC_CH_PORT
echo "${SELENIUM_NODE_RC_CH_PORT}" > RC_CH_PORT
echo "${SELENIUM_NODE_RC_FF_PORT}" > SELENIUM_NODE_RC_FF_PORT
echo "${SELENIUM_NODE_RC_FF_PORT}" > RC_FF_PORT
echo "${DISPLAY}" > DISPLAY
echo "${VNC_PORT}" > VNC_PORT
echo "${NOVNC_PORT}" > NOVNC_PORT
echo "${SUPERVISOR_HTTP_PORT}" > SUPERVISOR_HTTP_PORT
echo "${FIREFOX_DEST_BIN}" > FIREFOX_DEST_BIN
echo "${USE_SELENIUM}" > USE_SELENIUM
echo "${SELENIUM_JAR_PATH}" > SELENIUM_JAR_PATH
echo "${LOGS_DIR}" > LOGS_DIR
echo "${FIREFOX_VERSION}" > FIREFOX_VERSION
echo "${CHROME_VESION}" > CHROME_VESION
env > env

#------
# exec
#------
# export NORMAL_USER_UID="$(id -u seluser)"
# export NORMAL_USER_GID="$(id -g seluser)"
ga_track_start
exec run-supervisord.sh

# Note: sudo -i creates a login shell for someUser, which implies the following:
# - someUser's user-specific shell profile, if defined, is loaded.
# - $HOME points to someUser's home directory, so there's no need for -H (though you may still specify it)
# - the working directory for the impersonating shell is the someUser's home directory.
