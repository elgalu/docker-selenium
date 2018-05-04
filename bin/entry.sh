#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "150"
  errnum=${2-188}
  exit $errnum
}

if [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
  log "Kubernetes service account found."
  export USE_KUBERNETES=true
fi

# Required env vars
[ -z "${HOSTNAME}" ] && die "Need env var HOSTNAME"

#==============================================
# OpenShift or non-sudo environments support
#==============================================

CURRENT_UID="$(id -u)"
CURRENT_GID="$(id -g)"

# Ensure that assigned uid has entry in /etc/passwd.
if ! whoami &> /dev/null; then
  echo "extrauser:x:${CURRENT_UID}:0::/home/extrauser:/bin/bash" >> /etc/passwd
fi

# Tests if the container works without sudo access
if [ "${REMOVE_SELUSER_FROM_SUDOERS_FOR_TESTING}" == "true" ]; then
  sudo rm $(which sudo)
  if sudo pwd >/dev/null 2>&1; then
    die "Somehow we still have sudo access despite having removed it. Quitting. $(sudo pwd)"
  fi
fi

# Flag to know if we have sudo access
if sudo pwd >/dev/null 2>&1; then
  export WE_HAVE_SUDO_ACCESS="true"
else
  export WE_HAVE_SUDO_ACCESS="false"
  warn "We don't have sudo"
fi

if [ ${CURRENT_GID} -ne 1000 ]; then
  if [ "${WE_HAVE_SUDO_ACCESS}" == "true" ]; then
    sudo groupadd --gid ${CURRENT_GID} selgroup
    sudo gpasswd -a $(whoami) selgroup
  fi
fi

#==============================================
# Java blocks until kernel have enough entropy
# to generate the /dev/random seed
#==============================================
# See: SeleniumHQ/docker-selenium/issues/14
# Added a non-sudo conditional so this works on non-sudo environments like K8s
if [ "${WE_HAVE_SUDO_ACCESS}" == "true" ]; then
  # We found that, for better entropy, running haveged
  # with --privileged and sudo here works more reliable
  sudo -E haveged || true
else
  haveged || true
fi

# Workaround that might help to get dbus working in docker
#  http://stackoverflow.com/a/38355729/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/87#issuecomment-187659234
#  - still unclear if this helps: `-v /var/run/dbus:/var/run/dbus`
#  - this works generates errors: DBUS_SESSION_BUS_ADDRESS="/dev/null"
#  - this gives less erros: DBUS_SESSION_BUS_ADDRESS="unix:abstract=/dev/null"
rm -f /var/lib/dbus/machine-id
mkdir -p /var/run/dbus
service dbus restart >dbus_service.log

# Test dbus works
service dbus status >dbus_service_status.log
export $(dbus-launch)
export NSS_USE_SHARED_DB=ENABLED
# echo "-- INFO: DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS}"
#=> e.g. DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-APZO4BE4TJ,guid=6e9c098d053d3038cb0756ae57ecc885
# echo "-- INFO: DBUS_SESSION_BUS_PID=${DBUS_SESSION_BUS_PID}"
#=> e.g. DBUS_SESSION_BUS_PID=44

#-----------------------------------------------
# Perform cleanup to support `docker restart`
log "Stopping supervisord to support docker restart..."
stop >/dev/null 2>&1 || true

if ! rm -f ${LOGS_DIR}/* ; then
  warn "The container has just started yet we already don't have write access to ${LOGS_DIR}/*"
  ls -la ${LOGS_DIR}/ || true
fi

if ! rm -f ${RUN_DIR}/* ; then
  warn "The container has just started yet we already don't have write access to ${RUN_DIR}/*"
  ls -la ${RUN_DIR}/ || true
fi

#---------------------
# Fix/extend ENV vars
#---------------------
export SELENIUM_JAR_PATH="/home/seluser/selenium-server-standalone-3.jar"
export FIREFOX_DEST_BIN="/usr/bin/firefox"
export DOSEL_VERSION=$(cat VERSION)
export FIREFOX_VERSION=$(firefox_version)
# CHROME_FLAVOR would allow to have separate installations for stable, beta, unstable
export CHROME_PATH="/usr/bin/google-chrome-${CHROME_FLAVOR}"
export CHROME_VERSION=$(chrome_${CHROME_FLAVOR}_version)

echo "-- INFO: Docker Img. Version: ${DOSEL_VERSION}"
echo "-- INFO: Chrome..... Version: ${CHROME_VERSION}"
echo "-- INFO: Firefox.... Version: ${FIREFOX_VERSION}"

if [ "${USE_SELENIUM}" == "2" ]; then
  echo -e "\n\n\n\n"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!!! WARNING!!! You are using the unmaintained Selenium 2 !!!"
  echo "!!! to continue using Selenium 2 please use the proper tag:"
  echo "!!! docker pull elgalu/selenium:2                        !!!"
  echo "!!!                                                      !!!"
  echo "!!! Will start with Selenium 3 anyway                    !!!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo -e "\n\n\n\n"
fi

echo "-- INFO: Using Selenium.....: ${SEL_VER}"

# We recalculate screen dimensions because docker run supports changing them
export SCREEN_DEPTH="${SCREEN_MAIN_DEPTH}+${SCREEN_SUB_DEPTH}"
export GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}""x""${SCREEN_DEPTH}"

# These values are only available when the container started
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')

# export CONTAINER_IP=$(ip addr show dev ${ETHERNET_DEVICE_NAME} | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
# 2017-09 Found a more portable, even works in alpine:
export CONTAINER_IP=`getent hosts ${HOSTNAME} | awk '{ print $1 }'`
# Trying again to retrieve the container IP when using Zalenium
if [ "${ZALENIUM}" == "true" ] && [ "${CONTAINER_IP}" == "" ]; then
    # Sometimes the networking is not fast and the container IP is not there, we retry a few times for one minute to get it.
    echo "Retrying to get CONTAINER_IP..." 1>&2
    WAIT_UNTIL=$((SECONDS + 60))
    while [ $SECONDS -lt ${WAIT_UNTIL} ]; do
        export CONTAINER_IP=`getent hosts ${HOSTNAME} | awk '{ print $1 }'`
        if [ "${CONTAINER_IP}" != "" ]; then
          break
        fi
        echo -n '.'
        sleep 2
    done
fi

# if [ "${DOCKER_HOST_IP}" == "" ] || [[ ${DOCKER_HOST_IP} == 127* ]]; then
#   # TODO: Try with an alternative method
#   # die "DOCKER_HOST_IP is '${DOCKER_HOST_IP}'"
#   # export DOCKER_HOST_IP=$(ip route show | awk '/default/ {print $3}')
# fi

# if [ "${CONTAINER_IP}" == "" ] || [[ ${CONTAINER_IP} == 127* ]]; then
#   # TODO: Try with an alternative method
#   # die "CONTAINER_IP is '${CONTAINER_IP}'"
#   # export CONTAINER_IP=$(hostname -i)
# fi

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
export COMMON_CAPS="${COMMON_CAPS},tz=${TZ}"

# Video
export FFMPEG_FRAME_SIZE="${SCREEN_WIDTH}x${SCREEN_HEIGHT}"

# {{CONTAINER_IP}} is a place holder for dynamically setting the IP of a node
if [ "${SELENIUM_NODE_HOST}" = "{{CONTAINER_IP}}" ] || [ "${SELENIUM_NODE_HOST}" = "__CONTAINER_IP__" ]; then
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

if [ "${MULTINODE}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-multinode"
fi

if [ "${CHROME}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-node-chrome"
fi

if [ "${FIREFOX}" = "true" ]; then
  export SUPERVISOR_REQUIRED_SRV_LIST="${SUPERVISOR_REQUIRED_SRV_LIST}|selenium-node-firefox"
fi

if [ "${SELENIUM_HUB_PORT}" = "" ]; then
  echo "FATAL: SELENIUM_HUB_PORT is empty but should be a number" 1>&2
  exit 120
fi

# Fix extra quotes in Time zone $TZ env var
export TZ=$(echo ${TZ} | sed "s/^\([\"']\)\(.*\)\1\$/\2/g")

# https://github.com/SeleniumHQ/selenium/issues/2078#issuecomment-218320864
# https://github.com/SeleniumHQ/selenium/blob/master/py/selenium/webdriver/firefox/firefox_binary.py#L27
echo "webdriver.log.file has been discontinued." > "${LOGS_DIR}/firefox_browser.log"
echo "Please send us a PR if you know how to set the path for the Firefox browser logs." >> "${LOGS_DIR}/firefox_browser.log"

echo "Setting --user-data-dir=/home/seluser/chrome-user-data-dir" > "${LOGS_DIR}/chrome_browser.log"
echo "breaks the ability of clients to set Chrome options via the capabilities."   >> "${LOGS_DIR}/chrome_browser.log"
echo "Please send us a PR if you know how to set the path for the Firefox browser logs." >> "${LOGS_DIR}/chrome_browser.log"
# When running for Zalenium prepare certain customizations
if [ "${ZALENIUM}" == "true" ]; then
  # Set proper desktop background
  mv -f /usr/share/images/fluxbox/wallpaper-zalenium.png /usr/share/images/fluxbox/ubuntu-light.png
fi

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

if [ "${SELENIUM_NODE_CH_PORT}" == "" ]; then
  die "SELENIUM_NODE_CH_PORT is empty"
fi

if [ "${SELENIUM_NODE_FF_PORT}" = "0" ]; then
  export SELENIUM_NODE_FF_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_NODE_FF_PORT}" = "${DEFAULT_SELENIUM_NODE_FF_PORT}" ]; then
    export SELENIUM_NODE_FF_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

if [ "${SELENIUM_NODE_FF_PORT}" == "" ]; then
  die "SELENIUM_NODE_FF_PORT is empty"
fi

if [ "${SELENIUM_MULTINODE_PORT}" = "0" ]; then
  export SELENIUM_MULTINODE_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ]; then
  # User want to pick random ports but may also want to fix some others
  if [ "${SELENIUM_MULTINODE_PORT}" = "${DEFAULT_SELENIUM_MULTINODE_PORT}" ]; then
    export SELENIUM_MULTINODE_PORT=$(get_unused_port_from_range ${RANDOM_PORT_FROM} ${RANDOM_PORT_TO})
  fi
fi

# Video
export VIDEO_LOG_FILE="${LOGS_DIR}/video-rec-stdout.log"
export VIDEO_PIDFILE="${RUN_DIR}/video.pid"
if [ "${VIDEO_FILE_NAME}" = "" ]; then
  export VIDEO_FILE_NAME="vid"
  [ "${CHROME}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_chrome_${SELENIUM_NODE_CH_PORT}"
  [ "${FIREFOX}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_firefox_${SELENIUM_NODE_FF_PORT}"
  [ "${MULTINODE}" = "true" ] && export VIDEO_FILE_NAME="${VIDEO_FILE_NAME}_chrome_or_firefox_${SELENIUM_MULTINODE_PORT}"
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

# -ge # greater than or equal
if [ "${SELENIUM_NODE_CH_PORT}" -ge "40000" ] && \
   [ "${SELENIUM_NODE_CH_PORT}" != "${DEFAULT_SELENIUM_NODE_CH_PORT}" ]; then
    SELENIUM_FIRST_NODE_PORT=${SELENIUM_NODE_CH_PORT}
fi

if [ "${SELENIUM_NODE_FF_PORT}" -ge "40000" ]; then
  if [ "${SELENIUM_NODE_FF_PORT}" != "${DEFAULT_SELENIUM_NODE_FF_PORT}" ]; then
    export SELENIUM_FIRST_NODE_PORT=${SELENIUM_NODE_FF_PORT}
  fi
fi

if [ "${SELENIUM_MULTINODE_PORT}" -ge "40000" ] && \
   [ "${SELENIUM_MULTINODE_PORT}" != "${DEFAULT_SELENIUM_MULTINODE_PORT}" ]; then
    export SELENIUM_FIRST_NODE_PORT=${SELENIUM_MULTINODE_PORT}
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
        --data cd2="${CHROME_VERSION}"
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
        --data cd20="${ZALENIUM}"
    )

    curl ${GA_ENDPOINT} "${args[@]}" \
        --silent --output /dev/null >/dev/null 2>&1 & disown
  fi
}

#--------------------------------
# Improve etc/hosts and fix dirs
if [ "${WE_HAVE_SUDO_ACCESS}" == "true" ]; then
  sudo -E improve_etc_hosts.sh
fi

#-------------------------
# Docker alongside docker
if [ "${WE_HAVE_SUDO_ACCESS}" == "true" ]; then
  docker_alongside_docker.sh
fi

#-------------------------------
# Fix small tiny 64mb shm issue
#-------------------------------
# https://github.com/elgalu/docker-selenium/issues/20
if [ "${SHM_TRY_MOUNT_UNMOUNT}" = "true" ] && [ "${WE_HAVE_SUDO_ACCESS}" == "true" ]; then
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
echo "${SELENIUM_MULTINODE_PORT}" > MULTINODE_PORT
echo "${VNC_PORT}" > VNC_PORT
echo "${NOVNC_PORT}" > NOVNC_PORT
echo "${SUPERVISOR_HTTP_PORT}" > SUPERVISOR_HTTP_PORT
echo "${FIREFOX_DEST_BIN}" > FIREFOX_DEST_BIN
echo "${USE_SELENIUM}" > USE_SELENIUM
echo "${SELENIUM_JAR_PATH}" > SELENIUM_JAR_PATH
echo "${LOGS_DIR}" > LOGS_DIR
echo "${FIREFOX_VERSION}" > FIREFOX_VERSION
echo "${CHROME_VERSION}" > CHROME_VERSION
echo "${CHROME}" > CHROME
echo "${CHROME_FLAVOR}" > CHROME_FLAVOR
echo "${FIREFOX}" > FIREFOX
echo "${MULTINODE}" > MULTINODE
echo "${WAIT_TIMEOUT}" > WAIT_TIMEOUT
echo "${COMMON_CAPS}" > COMMON_CAPS
echo "${SELENIUM_HUB_HOST}" > SELENIUM_HUB_HOST
echo "${SELENIUM_HUB_PROTO}" > SELENIUM_HUB_PROTO
echo "${SELENIUM_NODE_HOST}" > SELENIUM_NODE_HOST
echo "${CHROME_PATH}" > CHROME_PATH
echo "${MAX_SESSIONS}" > MAX_SESSIONS
echo "${SEL_RELEASE_TIMEOUT_SECS}" > SEL_RELEASE_TIMEOUT_SECS
echo "${SEL_BROWSER_TIMEOUT_SECS}" > SEL_BROWSER_TIMEOUT_SECS
echo "${SEL_CLEANUPCYCLE_MS}" > SEL_CLEANUPCYCLE_MS
echo "${SEL_NODEPOLLING_MS}" > SEL_NODEPOLLING_MS
echo "${SEL_UNREGISTER_IF_STILL_DOWN_AFTER}" > SEL_UNREGISTER_IF_STILL_DOWN_AFTER
echo "${SELENIUM_NODE_PARAMS}" > SELENIUM_NODE_PARAMS
echo "${CUSTOM_SELENIUM_NODE_PROXY_PARAMS}" > CUSTOM_SELENIUM_NODE_PROXY_PARAMS
echo "${CUSTOM_SELENIUM_NODE_REGISTER_CYCLE}" > CUSTOM_SELENIUM_NODE_REGISTER_CYCLE
echo "${USE_KUBERNETES}" > USE_KUBERNETES
echo "${XMANAGER}" > XMANAGER
echo "${DOCKER_HOST_IP}" > DOCKER_HOST_IP
echo "${CONTAINER_IP}" > CONTAINER_IP
echo "${WE_HAVE_SUDO_ACCESS}" > WE_HAVE_SUDO_ACCESS
echo "${GRID}" > GRID

# Open a new file descriptor that redirects to stdout:
exec 3>&1

# Try 2 times first
start-xvfb.sh || start-xvfb.sh
export DISPLAY="$(cat DISPLAY)"
export DISP_N="$(cat DISP_N)"

# For 1 more time for Xvfb or retry
if ! timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh >/var/log/cont/wait-xvfb.1.log 2>&1 3>&1; then
  start-xvfb.sh || start-xvfb.sh
  export DISPLAY="$(cat DISPLAY)"
  export DISP_N="$(cat DISP_N)"
fi

timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh >/var/log/cont/wait-xvfb.2.log 2>&1 3>&1 || \
  die "Failed while waiting for Xvfb to start. We cannot continue!"

env > env

#------
# exec
#------
# export NORMAL_USER_UID="$(id -u seluser)"
# export NORMAL_USER_GID="$(id -g seluser)"
ga_track_start

if [ "${DEBUG}" == "bash" ]; then
  run-supervisord.sh &
  cd /var/log/cont
  exec bash
else
  exec run-supervisord.sh
fi

# Note: sudo -i creates a login shell for someUser, which implies the following:
# - someUser's user-specific shell profile, if defined, is loaded.
# - $HOME points to someUser's home directory, so there's no need for -H (though you may still specify it)
# - the working directory for the impersonating shell is the someUser's home directory.
