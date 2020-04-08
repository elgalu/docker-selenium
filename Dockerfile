#== FROM instructions support variables that are declared by
# any ARG instructions that occur before the first FROM
# ref: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#
# To overwrite the build args use:
#  docker build ... --build-arg UBUNTU_DATE=20171006
ARG UBUNTU_FLAVOR=xenial
ARG UBUNTU_DATE=20190904

#== Ubuntu xenial is 16.04, i.e. FROM ubuntu:16.04
# Find latest images at https://hub.docker.com/r/library/ubuntu/
FROM ubuntu:${UBUNTU_FLAVOR}-${UBUNTU_DATE}

#== An ARG declared before a FROM is outside of a build stage,
# so it can’t be used in any instruction after a FROM. To use
# the default value of an ARG declared before the first
# FROM use an ARG instruction without a value inside of a build stage
# ref: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG UBUNTU_FLAVOR
ARG UBUNTU_DATE

# Docker build debug logging, green colored
RUN printf "\033[1;32mFROM ubuntu:${UBUNTU_FLAVOR}-${UBUNTU_DATE} \033[0m\n"

# https://github.com/docker/docker/pull/25466#discussion-diff-74622923R677
LABEL maintainer "Diego Molina <diemol@gmail.com>"
LABEL maintainer "Leo Gallucci <elgalu3+dosel@gmail.com>"

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

#========================
# Miscellaneous packages
#========================
# libltdl7
#   allows to run docker alongside docker
# netcat-openbsd
#   inlcues `nc` an arbitrary TCP and UDP connections and listens
# pwgen
#   generates random, meaningless but pronounceable passwords
# bc
#   An arbitrary precision calculator language
# unzip
#   uncompress zip files
# bzip2
#   uncompress bzip files
# apt-utils
#   commandline utilities related to package management with APT
# net-tools
#   arp, hostname, ifconfig, netstat, route, plipconfig, iptunnel
# jq
#   jq is like sed for JSON data, you can use it to slice and filter and map
# sudo
#   sudo binary
# psmisc
#   fuser – identifies what processes are using files.
#   killall – kills a process by its name, similar to a pkill Unices.
#   pstree – Shows currently running processes in a tree format.
#   peekfd – Peek at file descriptors of running processes.
# iproute2
#   to use `ip` command
# iputils-ping
#   ping, ping6 - send ICMP ECHO_REQUEST to network hosts
# dbus-x11
#   is needed to avoid http://askubuntu.com/q/237893/134645
# wget
#   The non-interactive network downloader
# curl
#   transfer URL data using various Internet protocols
RUN apt -qqy update \
  && apt -qqy install \
    libltdl7 \
    netcat-openbsd \
    pwgen \
    bc \
    unzip \
    bzip2 \
    apt-utils \
    net-tools \
    jq \
    sudo \
    psmisc \
    iproute2 \
    iputils-ping \
    dbus-x11 \
    wget \
    curl \
    pulseaudio \
    socat \
    alsa-utils \
  && apt -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#==============================
# Locale and encoding settings
#==============================
# TODO: Allow to change instance language OS and Browser level
#  see if this helps: https://github.com/rogaha/docker-desktop/blob/68d7ca9df47b98f3ba58184c951e49098024dc24/Dockerfile#L57
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}
RUN apt -qqy update \
  && apt -qqy --no-install-recommends install \
    language-pack-en \
    tzdata \
    locales \
  && locale-gen ${LANGUAGE} \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#===================
# Timezone settings
#===================
# Full list at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#  e.g. "US/Pacific" for Los Angeles, California, USA
# e.g. ENV TZ "US/Pacific"
ENV TZ="Europe/Berlin"
# Apply TimeZone
RUN echo "Setting time zone to '${TZ}'" \
  && echo "${TZ}" > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#========================================
# Add normal user with passwordless sudo
#========================================
RUN useradd seluser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo seluser \
  && gpasswd -a seluser video \
  && echo 'seluser:secret' | chpasswd \
  && useradd extrauser \
         --shell /bin/bash  \
  && usermod -a -G sudo extrauser \
  && gpasswd -a extrauser video \
  && gpasswd -a extrauser seluser \
  && echo 'extrauser:secret' | chpasswd \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers

#==============================
# Java8 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
RUN apt -qqy update \
  && apt -qqy install \
    openjdk-8-jre-headless \
  && sed -i '/securerandom.source=/ s|/dev/u?random|/dev/./urandom|g' \
       /etc/java-*/security/java.security \
  && apt -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser
WORKDIR /home/seluser

# Docker backward compatibility
RUN echo "${UBUNTU_FLAVOR}" > UBUNTU_FLAVOR \
 && echo "${UBUNTU_DATE}" > UBUNTU_DATE

#=================
# Selenium latest
#=================
ARG SEL_DIRECTORY="3.14"
ENV SEL_VER="3.141.59"

RUN wget -nv "https://github.com/dosel/selenium/releases/download/selenium-3.141.59-patch-d47e74d6f2/selenium.jar" \
  && ln -s "selenium.jar" \
           "selenium-server-standalone-${SEL_VER}.jar" \
  && ln -s "selenium.jar" \
           "selenium-server-standalone-3.jar"

# TODO: Enable this again when Selenium 4.0 is released
#RUN echo $SEL_VER
#RUN  export SELBASE="https://selenium-release.storage.googleapis.com" \
#  && export SELPATH="${SEL_DIRECTORY}/selenium-server-standalone-${SEL_VER}.jar" \
#  && wget -nv ${SELBASE}/${SELPATH} \
#  && ln -s "selenium-server-standalone-${SEL_VER}.jar" \
#           "selenium-server-standalone-3.jar"

LABEL selenium_version "${SEL_VER}"

#=============================
# sudo by default from now on
#=============================
USER root

#=========================================================
# Python2 for Supervisor, selenium tests, and other stuff
#=========================================================
# RUN apt -qqy update \
#   && apt -qqy --no-install-recommends install \
#     python2.7 \
#     python-pip \
#     python-openssl \
#     libssl-dev \
#     libffi-dev \
#   && pip install --upgrade pip==9.0.3 \
#   && pip install --upgrade setuptools \
#   && rm -rf /var/lib/apt/lists/* \
#   && apt -qyy clean

#=========================================================
# Python3 for Supervisor, selenium tests, and other stuff
#=========================================================
# Note Python3 fails installing mozInstall==1.12 with
#  NameError: name 'file' is not defined
# After install, make some useful symlinks that are expected to exist
COPY test/requirements.txt /test/
RUN apt -qqy update \
  && apt -qqy --no-install-recommends install \
    python3 \
    python3-pip \
    python3-dev \
    python3-openssl \
    libssl-dev libffi-dev \
  && pip3 install --no-cache --upgrade pip==9.0.3 \
  && pip3 install --no-cache setuptools \
  && pip3 install --no-cache numpy \
  && pip3 install --no-cache --requirement /test/requirements.txt \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean
RUN cd /usr/local/bin \
  && { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
  && ln -s idle3 idle \
  && ln -s pydoc3 pydoc \
  && ln -s python3 python \
  && ln -s python3-config python-config \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && python --version \
  && pip --version

#====================
# Supervisor install
#====================
# TODO: Upgrade to supervisor stable 4.0 as soon as is released
# Check every now and then if version 4 is finally the stable one
#  https://pypi.python.org/pypi/supervisor
#  https://github.com/Supervisor/supervisor
# RUN apt -qqy update \
#   && apt -qqy install \
#     supervisor \
# 2018-09-28 commit: 837c159ae51f3b, supervisor/version.txt: 4.0.0.dev0
# 2018-06-01 commit: ec495be4e28c69, supervisor/version.txt: 4.0.0.dev0
# 2017-10-21 commit: 3f04badc3237f0, supervisor/version.txt: 4.0.0.dev0
# 2017-05-30 commit: 946d9cf3be4db3, supervisor/version.txt: 4.0.0.dev0
ENV RUN_DIR="/var/run/sele"
RUN SHA="837c159ae51f3bf12c1d30a8cb44f3450611983c" \
  && pip install --no-cache \
      "https://github.com/Supervisor/supervisor/zipball/${SHA}" || \
     pip install --no-cache \
      "https://github.com/Supervisor/supervisor/zipball/${SHA}" \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#================
# Font libraries
#================
# ttf-ubuntu-font-family
#   Ubuntu Font Family, sans-serif typeface hinted for clarity
# Removed packages:
# xfonts-100dpi
# xfonts-75dpi
# Regarding fonts-liberation see:
#  https://github.com/SeleniumHQ/docker-selenium/issues/383#issuecomment-278367069
RUN apt -qqy update \
  && apt -qqy --no-install-recommends install \
    libfontconfig \
    libfreetype6 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    ttf-ubuntu-font-family \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#=========
# Openbox
# A lightweight window manager using freedesktop standards
#=========
# Let's disable this as is only filling disk space
# RUN apt -qqy update \
#   && apt -qqy --no-install-recommends install \
#     openbox obconf menu \
#   && rm -rf /var/lib/apt/lists/* \
#   && apt -qyy clean

#=========
# fluxbox
# A fast, lightweight and responsive window manager
#=========
# xfce4-notifyd allows `notify-send` notifications
RUN apt -qqy update \
  && apt -qqy install \
    fluxbox \
    xfce4-notifyd \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#============================
# Xvfb X virtual framebuffer
#============================
# xvfb: Xvfb or X virtual framebuffer is a display server
#  + implements the X11 display server protocol
#  + performs all graphical operations in memory
RUN apt -qqy update \
  && apt -qqy --no-install-recommends install \
    xvfb \
    xorg \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#============
# VNC Server
#============
RUN apt -qqy update \
  && apt -qqy install \
    x11vnc \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser

########################################
# noVNC to expose VNC via an html page #
########################################
# Download elgalu/noVNC dated 2016-11-18 commit 9223e8f2d1c207fb74cb4b8cc243e59d84f9e2f6
# Download kanaka/noVNC dated 2016-11-10 commit 80b7dde665cac937aa0929d2b75aa482fc0e10ad
# Download kanaka/noVNC dated 2016-02-24 commit b403cb92fb8de82d04f305b4f14fa978003890d7
# Download kanaka/websockify dated 2016-10-10 commit cb1508fa495bea4b333173705772c1997559ae4b
# Download kanaka/websockify dated 2015-06-02 commit 558a6439f14b0d85a31145541745e25c255d576b
ENV NOVNC_SHA="9223e8f2d1c207fb74cb4b8cc243e59d84f9e2f6" \
    WEBSOCKIFY_SHA="cb1508fa495bea4b333173705772c1997559ae4b"
RUN  wget -nv -O noVNC.zip \
       "https://github.com/elgalu/noVNC/archive/${NOVNC_SHA}.zip" \
  && unzip -x noVNC.zip \
  && mv noVNC-${NOVNC_SHA} noVNC \
  && rm noVNC.zip \
  && wget -nv -O websockify.zip \
      "https://github.com/kanaka/websockify/archive/${WEBSOCKIFY_SHA}.zip" \
  && unzip -x websockify.zip \
  && rm websockify.zip \
  && mv websockify-${WEBSOCKIFY_SHA} ./noVNC/utils/websockify

#=============================
# sudo by default from now on
#=============================
USER root

#=========================
# Browser video libraries
#=========================
# gstreamer (gstreamer1.0-libav)
#   for mp4 & html5 video browser support: https://www.youtube.com/html5
# TODO: Add test to see what the browser supports by opening
#       https://www.youtube.com/html5
RUN apt -qqy update \
  && apt -qqy --no-install-recommends install \
    gstreamer1.0-libav \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#========
# ffmpeg
#========
# MP4Box (gpac) to clean the video credits to @taskworld @dtinth
# ffmpeg (ffmpeg): Is a better alternative to Pyvnc2swf
#   (use in Ubuntu >= 15) packages: ffmpeg
RUN apt -qqy update \
  && apt -qqy install \
    ffmpeg \
    gpac \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

# ------------------------#
# Sauce Connect Tunneling #
# ------------------------#
# Please use https://github.com/zalando/zalenium

# -----------------------#
# BrowserStack Tunneling #
# -----------------------#
# Please use https://github.com/zalando/zalenium

#-----------------#
# Mozilla
#-----------------#
# Install all Firefox dependencies
# Adding libasound2 and others, credits to @jackTheRipper
#  https://github.com/SeleniumHQ/docker-selenium/pull/418
    # libasound2 \
    # libpulse-dev \
    # xul-ext-ubufox \
RUN apt -qqy update \
  && apt -qqy --no-install-recommends install \
    `apt-cache depends firefox | awk '/Depends:/{print$2}'` \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser

#=============================
# sudo by default from now on
#=============================
USER root

ENV FF_LANG="en-US" \
    FF_BASE_URL="https://archive.mozilla.org/pub" \
    FF_PLATFORM="linux-x86_64" \
    FF_INNER_PATH="firefox/releases"

ARG FF_VER="75.0"

ENV FF_COMP="firefox-${FF_VER}.tar.bz2"
ENV FF_URL="${FF_BASE_URL}/${FF_INNER_PATH}/${FF_VER}/${FF_PLATFORM}/${FF_LANG}/${FF_COMP}"
RUN cd /opt \
  && wget -nv "${FF_URL}" -O "firefox.tar.bz2" \
  && bzip2 -d "firefox.tar.bz2" \
  && tar xf "firefox.tar" \
  && rm "firefox.tar" \
  && ln -fs /opt/firefox/firefox /usr/bin/firefox \
  && chown -R seluser:seluser /opt/firefox \
  && chmod -R 777 /opt/firefox

LABEL selenium_firefox_version "${FF_VER}"

#============
# GeckoDriver
#============
ARG GECKOD_VER="0.26.0"
ENV GECKOD_URL="https://github.com/mozilla/geckodriver/releases/download"
RUN wget --no-verbose -O geckodriver.tar.gz \
     "${GECKOD_URL}/v${GECKOD_VER}/geckodriver-v${GECKOD_VER}-linux64.tar.gz" \
  && rm -rf /opt/geckodriver* \
  && tar -C /opt -xvzf geckodriver.tar.gz \
  && chmod +x /opt/geckodriver \
  && cp /opt/geckodriver /usr/bin/geckodriver \
  && chown seluser:seluser /opt/geckodriver \
  && chown seluser:seluser /usr/bin/geckodriver \
  && rm geckodriver.tar.gz

COPY bin/fail /usr/bin/

#===============
# Google Chrome
#===============
# TODO: Use Google fingerprint to verify downloads
#  https://www.google.de/linuxrepositories/
ARG EXPECTED_CHROME_VERSION="81.0.4044.92"
ENV CHROME_URL="https://dl.google.com/linux/direct" \
    CHROME_BASE_DEB_PATH="/home/seluser/chrome-deb/google-chrome" \
    GREP_ONLY_NUMS_VER="[0-9.]{2,20}"

LABEL selenium_chrome_version "${EXPECTED_CHROME_VERSION}"

RUN apt -qqy update \
  && mkdir -p chrome-deb \
  && wget -nv "${CHROME_URL}/google-chrome-stable_current_amd64.deb" \
          -O "./chrome-deb/google-chrome-stable_current_amd64.deb" \
  && apt -qyy --no-install-recommends install \
        "${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb" \
  && rm "${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb" \
  && rm -rf ./chrome-deb \
  && apt -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean \
  && export CH_STABLE_VER=$(/usr/bin/google-chrome-stable --version | grep -iEo "${GREP_ONLY_NUMS_VER}") \
  && echo "CH_STABLE_VER:'${CH_STABLE_VER}' vs EXPECTED_CHROME_VERSION:'${EXPECTED_CHROME_VERSION}'" \
  && [ "${CH_STABLE_VER}" = "${EXPECTED_CHROME_VERSION}" ] || fail

# We have a wrapper for /opt/google/chrome/google-chrome
RUN mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome-base
COPY selenium-node-chrome/opt /opt
COPY lib/* /usr/lib/

# Use a custom wallpaper for Fluxbox
COPY images/wallpaper-dosel.png /usr/share/images/fluxbox/ubuntu-light.png
COPY images/wallpaper-zalenium.png /usr/share/images/fluxbox/
RUN chown -R seluser:seluser /usr/share/images/fluxbox/ \
 && chmod -R 777 /usr/share/images/fluxbox

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser

#==================
# Chrome webdriver
#==================
# How to get cpu arch dynamically: $(lscpu | grep Architecture | sed "s/^.*_//")
ARG CHROME_DRIVER_VERSION="81.0.4044.69"
ENV CHROME_DRIVER_BASE="chromedriver.storage.googleapis.com" \
    CPU_ARCH="64"
ENV CHROME_DRIVER_FILE="chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_URL="https://${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}"
# Gets latest chrome driver version. Or you can hard-code it, e.g. 2.15
RUN  wget -nv -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
  && unzip chromedriver_linux${CPU_ARCH}.zip \
  && rm chromedriver_linux${CPU_ARCH}.zip \
  && mv chromedriver \
        chromedriver-${CHROME_DRIVER_VERSION} \
  && chmod 755 chromedriver-${CHROME_DRIVER_VERSION} \
  && ln -s chromedriver-${CHROME_DRIVER_VERSION} \
           chromedriver \
  && sudo ln -s /home/seluser/chromedriver /usr/bin

#=================
# Supervisor conf
#=================
COPY supervisor/etc/supervisor/supervisord.conf /etc/supervisor/
COPY **/etc/supervisor/conf.d/* /etc/supervisor/conf.d/

#===================
# DNS & hosts stuff
#===================
COPY ./dns/etc/hosts /tmp/hosts

#======
# Envs
#======
ENV DEFAULT_SELENIUM_HUB_PORT="24444" \
    DEFAULT_SELENIUM_NODE_CH_PORT="25550" \
    DEFAULT_SELENIUM_NODE_FF_PORT="25551" \
    DEFAULT_SELENIUM_MULTINODE_PORT="25552" \
    DEFAULT_VNC_PORT="25900" \
    DEFAULT_NOVNC_PORT="26080" \
    DEFAULT_SUPERVISOR_HTTP_PORT="19001"

# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# CHROME_FLAVOR "stable"
#   Default chrome flavor, options no longer available: beta|unstable
# PICK_ALL_RANDOM_PORTS "true" / "false"
#   Randomize all ports, i.e. pick unused unprivileged ones
# RANDOM_PORT_FROM
# RANDOM_PORT_TO
#   When using PICK_ALL_RANDOM_PORTS=true the ports will
#   be from a range to avoid collisions
# MEM_JAVA_PERCENT "80"
#   Because the JVM uses only 1/4 of system memory by default
# WAIT_FOREGROUND_RETRY
# WAIT_VNC_FOREGROUND_RETRY
#   Max amount of time to wait on Xvfb or Xmanager while retrying
# XVFB_STARTRETRIES
# XMANAGER
#   We used to support 2 X managers: fluxbox | openbox
#   But after version 3.0.1 we only support fluxbox
#   to save disk space
# XMANAGER_STARTRETRIES
# XMANAGER_STARTSECS
#   Supervisor processes retry attemps (0 means do not retry)
# WAIT_TIMEOUT
#   Max amount of time to wait for other processes dependencies
# DISP_N
#   Display number; see entry.sh for $DISPLAY
# MAX_DISPLAY_SEARCH
#   Maximum searches for a free DISPLAY number
# SELENIUM_HUB_PORT
#   Even though you can change them below, don't worry too much about container
#   internal ports since you can map them to the host via `docker run -p`
# SELENIUM_HUB_PROTO
# SELENIUM_HUB_HOST
# SELENIUM_NODE_HOST
#   You may want to connect to another hub
# SELENIUM_HUB_PARAMS
# SELENIUM_NODE_PARAMS
# SELENIUM_NODE_PROXY_PARAMS
#   Selenium additional params:
# CHROME_ARGS
#   "--no-sandbox --disable-gpu" To taggle issue #58 see https://goo.gl/fz6RTu
#   more: "--ignore-certificate-errors"
# CHROME_VERBOSELOGGING
#   Will be passed with: -Dwebdriver.chrome.verboseLogging
#     SELENIUM_NODE_CHROME_PARAMS='-Dselenium.chrome.args="--no-sandbox"' \
#     WEBDRIVER_NODE_CHROME_PARAMS='-Dwebdriver.chrome.args="--no-sandbox"' \
#     Selenium capabilities descriptive (to avoid opera/ie warnings)
#      docs at https://code.google.com/p/selenium/wiki/Grid2
# SEL_RELEASE_TIMEOUT_SECS
#   -timeout AKA GRID_TIMEOUT TODO fix with, ping @allanatadministrate
#   https://github.com/SeleniumHQ/docker-selenium/pull/393
# SEL_BROWSER_TIMEOUT_SECS
# SELENIUM_NODE_REGISTER_CYCLE
#   How often in ms the node will try to register itself again.
#   Allow to restart the hub without having to restart the nodes.
#    (node) in ms. Selenium default: 5000
# SEL_CLEANUPCYCLE_MS
#   How often a proxy will check for timed out thread.
#    (node) in ms. Selenium default: 5000
# SEL_NODEPOLLING_MS
#   Interval between alive checks of node how often the hub checks if the node is still alive.
#    (node) in ms. Selenium default: 5000
# SEL_UNREGISTER_IF_STILL_DOWN_AFTER
#   If the node remains down for more than unregisterIfStillDownAfter millisec
#    it will disappear from the hub. in ms. Default: 1min
# no_proxy
# HUB_ENV_no_proxy
#   Docker for Mac beta - containers do not start #227
# VNC_FROM_PORT
# VNC_TO_PORT
#   We need a fixed port range to expose VNC due to a bug in Docker for Mac beta (1.12)
#   https://forums.docker.com/t/docker-for-mac-beta-not-forwarding-ports/8658/6
# VNC_CLI_OPTS
#   e.g. VNC_CLI_OPTS="-noipv6 -no6 -forever -shared"
#   e.g. VNC_CLI_OPTS="-forever -shared"
# VNC_PASSWORD
#   - "no" means no password; less secure but not a big deal
#   - "" (empty string) means it will be randomly generated
#   - "some-value" will use that password "some-value" or whatever
# LOG_LEVEL
#   Supervisor loglevel and also general docker log level
#   can be: debug, warn, trace, info
# DISABLE_ROLLBACK
#   When DISABLE_ROLLBACK=true it will:
#    - output logs
#    - exec bash to permit troubleshooting
# LOGS_DIR
#   Logs are now managed by supervisord.conf, see
#    ${LOGS_DIR}/*.log
# FFMPEG_FRAME_RATE
#   ffmpeg encoding options
# FFMPEG_CODEC_ARGS
#   Video size can be lowered down via re-encoding, see
#    http://askubuntu.com/a/365221/134645
# FFMPEG_DRAW_MOUSE
#    Specify whether to draw the mouse pointer. Default: 1
# VIDEO GRID CHROME FIREFOX RC_CHROME RC_FIREFOX
#   true/false which services should start upon docker run
# VIDEO_FILE_EXTENSION
#   Video file and extension, e.g. mp4, mkv
# TAIL_LOG_LINES
#   Amount of lines to display when startup errors
# SHM_TRY_MOUNT_UNMOUNT
#   Fix small tiny 64mb shm issue
# ETHERNET_DEVICE_NAME
#   When docker run --net=host the network name may be different
# XMANAGER_STOP_SIGNAL
# XVFB_STOP_SIGNAL
# XTERM_START
#  Wheather to start an xterm in the windows manager. For debugging.
# XTERM_STOP_SIGNAL
# SELENIUM_NODE_FIREFOX_STOP_SIGNAL
# SELENIUM_NODE_CHROME_STOP_SIGNAL
# SELENIUM_MULTINODE_STOP_SIGNAL
# SELENIUM_HUB_STOP_SIGNAL
# VNC_STOP_SIGNAL
# NOVNC_STOP_SIGNAL
# VIDEO_REC_STOP_SIGNAL
# DOCKER_SOCK
#   Run docker from inside docker
#   Usage: docker run -v /var/run/docker.sock:/var/run/docker.sock
#                     -v $(which docker):/usr/bin/docker
# TEST_SLEEPS
#   Used internally due to flaky tests, should be removed in the future
# SEND_ANONYMOUS_USAGE_INFO
# GA_TRACKING_ID
# GA_ENDPOINT
# GA_API_VERSION
#   All Google Analytics related, see LICENSE.md & Analytics.md for more info
ENV FIREFOX_VERSION="${FF_VER}" \
  USE_SELENIUM="3" \
  CHROME_FLAVOR="stable" \
  DEBUG="false" \
  PICK_ALL_RANDOM_PORTS="false" \
  RANDOM_PORT_FROM="23100" \
  RANDOM_PORT_TO="29999" \
  USER="seluser" \
  HOME="/home/seluser" \
  VNC_STORE_PWD_FILE="/home/seluser/.vnc/passwd" \
  BIN_UTILS="/usr/bin" \
  LIB_UTILS="/usr/lib" \
  MEM_JAVA_PERCENT=80 \
  WAIT_FOREGROUND_RETRY="2s" \
  WAIT_VNC_FOREGROUND_RETRY="6s" \
  XVFB_STARTRETRIES=0 \
  XMANAGER_STARTSECS=2 \
  XMANAGER_STARTRETRIES=3 \
  WAIT_TIMEOUT="45s" \
  SCREEN_WIDTH=1900 \
  SCREEN_HEIGHT=1880 \
  SCREEN_MAIN_DEPTH=24 \
  SCREEN_SUB_DEPTH=32 \
  DISP_N="-1" \
  MAX_DISPLAY_SEARCH=99 \
  SCREEN_NUM=0 \
  SELENIUM_HUB_PORT="${DEFAULT_SELENIUM_HUB_PORT}" \
  SELENIUM_HUB_PROTO="http" \
  SELENIUM_HUB_HOST="127.0.0.1" \
  # Unfortunately selenium is missing a -bind setting so -host
  # is used multipurpose forcing us to set it now to 0.0.0.0
  # to match the binding meaning in oposed to host meaning
  SELENIUM_NODE_HOST="0.0.0.0" \
  SELENIUM_NODE_CH_PORT="${DEFAULT_SELENIUM_NODE_CH_PORT}" \
  SELENIUM_NODE_FF_PORT="${DEFAULT_SELENIUM_NODE_FF_PORT}" \
  SELENIUM_MULTINODE_PORT="${DEFAULT_SELENIUM_MULTINODE_PORT}" \
  SELENIUM_HUB_PARAMS="" \
  SELENIUM_NODE_PARAMS="" \
  SELENIUM_NODE_PROXY_PARAMS="" \
  CHROME_ARGS="--no-sandbox --disable-setuid-sandbox --disable-gpu --disable-infobars" \
  CHROME_ADDITIONAL_ARGS="" \
  CHROME_VERBOSELOGGING="true" \
  MAX_INSTANCES=1 \
  MAX_SESSIONS=1 \
  SEL_RELEASE_TIMEOUT_SECS="19000" \
  SEL_BROWSER_TIMEOUT_SECS="16000" \
  SELENIUM_NODE_REGISTER_CYCLE="5000" \
  SEL_CLEANUPCYCLE_MS="5000" \
  SEL_NODEPOLLING_MS="5000" \
  SEL_UNREGISTER_IF_STILL_DOWN_AFTER="2500" \
  no_proxy=localhost \
  HUB_ENV_no_proxy=localhost \
  XVFB_CLI_OPTS_TCP="-nolisten tcp -nolisten inet6" \
  XVFB_CLI_OPTS_BASE="-ac -r -cc 4 -accessx -xinerama" \
  XVFB_CLI_OPTS_EXT="+extension Composite +extension RANDR +extension GLX" \
  VNC_START="true" \
  VNC_PORT="${DEFAULT_VNC_PORT}" \
  VNC_FROM_PORT="" \
  VNC_TO_PORT="" \
  VNC_CLI_OPTS="-forever -shared" \
  VNC_PASSWORD=no \
  NOVNC_PORT="${DEFAULT_NOVNC_PORT}" \
  NOVNC="false" \
  NOVNC_WAIT_TIMEOUT="5s" \
  BROWSERMOBPROXY_START="false" \
  SUPERVISOR_HTTP_PORT="${DEFAULT_SUPERVISOR_HTTP_PORT}" \
  SUPERVISOR_HTTP_USERNAME="supervisorweb" \
  SUPERVISOR_HTTP_PASSWORD="somehttpbasicauthpwd" \
  SUPERVISOR_REQUIRED_SRV_LIST="xmanager" \
  SUPERVISOR_NOT_REQUIRED_SRV_LIST1="ignoreMe" \
  SUPERVISOR_NOT_REQUIRED_SRV_LIST2="ignoreMe" \
  SLEEP_SECS_AFTER_KILLING_SUPERVISORD=3 \
  SUPERVISOR_STOPWAITSECS=20 \
  SUPERVISOR_STOPSIGNAL=TERM \
  SUPERVISOR_KILLASGROUP="false" \
  SUPERVISOR_STOPASGROUP="false" \
  LOG_LEVEL="info" \
  DISABLE_ROLLBACK="false" \
  LOGFILE_MAXBYTES=10MB \
  LOGFILE_BACKUPS=5 \
  LOGS_DIR="/var/log/cont" \
  VIDEO="false" \
  AUDIO="false" \
  GRID="true" \
  CHROME="true" \
  FIREFOX="true" \
  MULTINODE="false" \
  FFMPEG_FRAME_RATE=10 \
  FFMPEG_CODEC_ARGS="-vcodec libx264 -preset ultrafast -pix_fmt yuv420p" \
  FFMPEG_CODEC_VA_ARGS="-vcodec libx264 -acodec copy -preset ultrafast" \
  FFMPEG_FINAL_CRF=0 \
  FFMPEG_DRAW_MOUSE=1 \
  VIDEO_TMP_FILE_EXTENSION="mkv" \
  VIDEO_FILE_EXTENSION="mp4" \
  MP4_INTERLEAVES_MEDIA_DATA_CHUNKS_SECS="500" \
  VIDEO_FILE_NAME="" \
  VIDEO_BEFORE_STOP_SLEEP_SECS="1" \
  VIDEO_AFTER_STOP_SLEEP_SECS="0.5" \
  VIDEO_STOPWAITSECS="50" \
  VIDEO_CONVERSION_MAX_WAIT="20s" \
  VIDEO_MP4_FIX_MAX_WAIT="8s" \
  VIDEO_WAIT_VID_TOOL_PID_1st_sig_UP_TO_SECS="6s" \
  VIDEO_WAIT_VID_TOOL_PID_2nd_sig_UP_TO_SECS="2s" \
  VIDEO_WAIT_VID_TOOL_PID_3rd_sig_UP_TO_SECS="1s" \
  VIDEO_STOP_1st_sig_TYPE="SIGTERM" \
  VIDEO_STOP_2nd_sig_TYPE="SIGINT" \
  VIDEO_STOP_3rd_sig_TYPE="SIGKILL" \
  WAIT_TIME_OUT_VIDEO_STOP="20s" \
  VIDEOS_DIR="/home/seluser/videos" \
  XMANAGER="fluxbox" \
  FLUXBOX_START_MAX_RETRIES=5 \
  TAIL_LOG_LINES="50" \
  SHM_TRY_MOUNT_UNMOUNT="false" \
  SHM_SIZE="512M" \
  ETHERNET_DEVICE_NAME="eth0" \
  XMANAGER_STOP_SIGNAL="TERM" \
  XVFB_STOP_SIGNAL="TERM" \
  XTERM_START="false" \
  XTERM_STOP_SIGNAL="INT" \
  SELENIUM_NODE_FIREFOX_STOP_SIGNAL="TERM" \
  SELENIUM_NODE_CHROME_STOP_SIGNAL="TERM" \
  SELENIUM_MULTINODE_STOP_SIGNAL="TERM" \
  SELENIUM_HUB_STOP_SIGNAL="TERM" \
  VNC_STOP_SIGNAL="TERM" \
  NOVNC_STOP_SIGNAL="TERM" \
  VIDEO_REC_STOP_SIGNAL="INT" \
  BROWSERMOBPROXY_STOP_SIGNAL="TERM" \
  DOCKER_SOCK="/var/run/docker.sock" \
  TEST_SLEEPS="0.1" \
  ZALENIUM="false" \
  SEND_ANONYMOUS_USAGE_INFO="true" \
  GA_TRACKING_ID="UA-18144954-9" \
  GA_ENDPOINT=https://www.google-analytics.com/collect \
  GA_API_VERSION="1" \
  LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/" \
  DEBIAN_FRONTEND="" \
  USE_KUBERNETES="false" \
  REMOVE_SELUSER_FROM_SUDOERS_FOR_TESTING="false" \
  DEBCONF_NONINTERACTIVE_SEEN=""

#================================
# Expose Container's Directories
#================================
# VOLUME ${LOGS_DIR}

# Removed HEALTHCHECK because is providing no value to us but
# rather problems. When Zalenium starts N containers at the some time
# the --interval will make docker check the health of all of them
# at the same time and this causes an unnecessary CPU overhead.
# HEALTHCHECK --interval=2m --timeout=50s --retries=2 \
#   CMD wait_all_done 30s

#================
# Binary scripts
#================
COPY bin/* ${BIN_UTILS}/
COPY **/bin/* ${BIN_UTILS}/
COPY host-scripts/* /host-scripts/
COPY test/* /test/
COPY test/run_test.sh /usr/bin/run_test
COPY test/selenium_test.sh /usr/bin/selenium_test
COPY test/python_test.py /usr/bin/python_test
COPY images ./images
COPY LICENSE.md /home/seluser/
COPY Analytics.md /home/seluser/

# Include current version
COPY GLOBAL_PATCH_LEVEL.txt /home/seluser/
RUN echo "${SEL_VER}-$(cat GLOBAL_PATCH_LEVEL.txt)" > /home/seluser/VERSION

# Moved from entry.sh
ENV SUPERVISOR_PIDFILE="${RUN_DIR}/supervisord.pid" \
    DOCKER_SELENIUM_STATUS="${LOGS_DIR}/docker-selenium-status.log" \
    VNC_TRYOUT_ERR_LOG="${LOGS_DIR}/vnc-tryouts-stderr" \
    VNC_TRYOUT_OUT_LOG="${LOGS_DIR}/vnc-tryouts-stdout"

# Include Lib Browsermob Proxy
USER root

ENV BROWSERMOBPROXY_VER=2.1.4
ENV BROWSERMOBPROXY_FOLDER=browsermob-proxy-${BROWSERMOBPROXY_VER}

RUN  wget -nv -O browsermob-proxy.zip \
       "https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-${BROWSERMOBPROXY_VER}/browsermob-proxy-${BROWSERMOBPROXY_VER}-bin.zip" \
  && unzip -x browsermob-proxy.zip \
  && rm browsermob-proxy.zip \
  && mv ${BROWSERMOBPROXY_FOLDER}/lib/browsermob-dist-${BROWSERMOBPROXY_VER}.jar ${LIB_UTILS}/ \
  && rm -r ${BROWSERMOBPROXY_FOLDER}

USER seluser

#===================================
# Fix dirs (again) and final chores
#===================================
# The .X11-unix stuff is useful when using Xephyr
RUN mkdir -p /home/seluser/.vnc \
  && sudo touch /capabilities.json \
  && sudo chown seluser:seluser /capabilities.json \
  && generate_capabilities_json > /capabilities.json \
  && cp /capabilities.json /home/seluser/capabilities.json \
  && cp /capabilities.json /home/seluser/capabilities \
  && cp /capabilities.json /home/seluser/caps.json \
  && cp /capabilities.json /home/seluser/caps \
  && mkdir -p ${VIDEOS_DIR} \
  && sudo ln -s ${VIDEOS_DIR} /videos \
  && sudo mkdir -p ${LOGS_DIR} \
  && sudo mkdir -p ${RUN_DIR} \
  && sudo mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
  && sudo fixperms.sh \
  && echo ""

#=====================================================
# Meta JSON file to hold commit info of current build
#=====================================================
COPY scm-source.json /
# Ensure the file is up-to-date else you should update it by running
#  ./host-scripts/gen-scm-source.sh
# on the host machine

#==================
# ENTRYPOINT & CMD
#==================
# IMPORTANT: Using the string form `CMD "entry.sh"` without
# brackets [] causes Docker to run your process
# And using `bash` which doesn’t handle signals properly
CMD ["entry.sh"]
