###################################################
# Selenium standalone docker for Chrome & Firefox #
###################################################
#== Ubuntu wily is 15.10.x, i.e. FROM ubuntu:15.10
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
FROM ubuntu:wily-20150708
ENV UBUNTU_FLAVOR wily

#== Ubuntu vivid is 15.04.x, i.e. FROM ubuntu:15.04
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
#                    http://cloud-images.ubuntu.com/releases/15.04/
# FROM ubuntu:vivid-20150611
# ENV UBUNTU_FLAVOR vivid

#== Ubuntu trusty is 14.04.x, i.e. FROM ubuntu:14.04
#== Could also use ubuntu:latest but for the sake I replicating an precise env...
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
#                    http://cloud-images.ubuntu.com/releases/14.04/
# FROM ubuntu:14.04.2
# ENV UBUNTU_FLAVOR trusty

#== Ubuntu precise is 12.04.x, i.e. FROM ubuntu:12.04
#== Could also use ubuntu:latest but for the sake I replicating an precise env...
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
#                    http://cloud-images.ubuntu.com/releases/12.04/
# FROM ubuntu:precise-20150612
# ENV UBUNTU_FLAVOR precise

#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list

MAINTAINER Leo Gallucci <elgalu3@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

#========================
# Miscellaneous packages
#========================
# netcat-openbsd - nc — arbitrary TCP and UDP connections and listens
# net-tools - arp, hostname, ifconfig, netstat, route, plipconfig, iptunnel
# iputils-ping - ping, ping6 - send ICMP ECHO_REQUEST to network hosts
# apt-utils - commandline utilities related to package management with APT
# wget - The non-interactive network downloader
# curl - transfer a URL
# bc - An arbitrary precision calculator language
# pwgen: generates random, meaningless but pronounceable passwords
# ts from moreutils will prepend a timestamp to every line of input you give it
# grc is a terminal colorizer that works nice with tail https://github.com/garabik/grc
RUN apt-get update -qqy \
  && apt-get -qqy install \
    apt-utils \
    sudo \
    net-tools \
    telnet \
    jq \
    netcat-openbsd \
    iputils-ping \
    unzip \
    wget \
    curl \
    pwgen \
    bc \
    grc \
    moreutils \
  && rm -rf /var/lib/apt/lists/*

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
RUN locale-gen ${LANGUAGE} \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get update -qqy \
  && apt-get -qqy install \
    language-pack-en \
  && rm -rf /var/lib/apt/lists/*

#===================
# Timezone settings
#===================
# Full list at http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#  e.g. "US/Pacific" for Los Angeles, California, USA
# ENV TZ "US/Pacific"
ENV TZ "Europe/Berlin"
# Apply TimeZone
RUN echo $TZ | tee /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#==============================
# Java7 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     openjdk-7-jre-headless \
#   && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/java.security \
#   && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/java.security \
#   && rm -rf /var/lib/apt/lists/*

#==============================
# Java8 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     openjdk-8-jre-headless \
#   && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security \
#   && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security \
#   && rm -rf /var/lib/apt/lists/*

#==================
# Java8 - Oracle
#==================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
RUN apt-get update -qqy \
  && apt-get -qqy install \
    software-properties-common \
  && echo debconf shared/accepted-oracle-license-v1-1 \
      select true | debconf-set-selections \
  && echo debconf shared/accepted-oracle-license-v1-1 \
      seen true | debconf-set-selections \
  && add-apt-repository ppa:webupd8team/java \
  && apt-get update -qqy \
  && apt-get -qqy install \
    oracle-java8-installer \
  && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security \
  && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security \
  && rm -rf /var/lib/apt/lists/*

#==============================================================================
# java blocks until kernel have enough entropy to generate the /dev/random seed
#==============================================================================
# This fix is not working so commented out.
#  SeleniumHQ/docker-selenium/issues/14
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     haveged rng-tools \
#   && service haveged start \
#   && update-rc.d haveged defaults

#=========================================
# Python2 for Firefox, Supervisor, others
#=========================================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    python2.7 \
    python-pip \
    python2.7-dev \
    python-openssl \
    libssl-dev libffi-dev \
  && easy_install -U pip \
  && rm -rf /var/lib/apt/lists/*

#=======
# Fonts
#=======
RUN apt-get update -qqy \
  && apt-get -qqy install \
    fonts-ipafont-gothic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable \
    ttf-ubuntu-font-family \
    libfreetype6 \
    libfontconfig \
  && rm -rf /var/lib/apt/lists/*

#=========
# Openbox
# A lightweight window manager using freedesktop standards
#=========
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openbox obconf menu \
  && rm -rf /var/lib/apt/lists/*

#=========
# fluxbox
# A fast, lightweight and responsive window manager
#=========
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     fluxbox \
#   && rm -rf /var/lib/apt/lists/*

#=========
# GNOME Shell provides core interface functions like switching windows,
# launching applications or see your notifications
#=========
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     gnome-shell \
#   && rm -rf /var/lib/apt/lists/*

#=========
# LXDE lxde/lubuntu-desktop
# A Lightweight X11 Desktop Environment
#=========
# NOT working! TODO: see https://github.com/dockerfile/ubuntu-desktop/blob/master/Dockerfile#L13
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     lxde \
#   && mkdir -p /usr/share/backgrounds \
#   && rm -rf /var/lib/apt/lists/*

#=========
# LightDM is the display manager running in Ubuntu
# A fat and full featured windows manager
#=========
# allowed_users=anybody fixes X: user not authorized to run the X server, aborting
#  http://karuppuswamy.com/wordpress/2010/09/26/how-to-fix-x-user-not-authorized-to-run-the-x-server-aborting/
# The issue can be recreated with "ami-ed7c149a" and maybe in CentOS
# ENV XAUTH_DIR /var/lib/lightdm
# ENV XAUTHORITY ${XAUTH_DIR}/.Xauthority
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     lightdm dbus-x11 x11-common \
#   && dpkg-reconfigure --frontend noninteractive lightdm x11-common \
#   && sed -i 's/allowed_users=console/allowed_users=anybody/g' \
#             /etc/X11/Xwrapper.config \
#   && touch ${XAUTHORITY} \
#   && chmod 666 ${XAUTHORITY} \
#   && chown -R ${NORMAL_USER}:${NORMAL_USER} ${XAUTH_DIR} \
#   && rm -rf /var/lib/apt/lists/*

#======================
# GNOME ubuntu-desktop
# The fat and full featured windows manager
#======================
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     ubuntu-desktop \
#   && rm -rf /var/lib/apt/lists/*

#========================================
# Add normal user with passwordless sudo
#========================================
ENV NORMAL_USER application
ENV NORMAL_GROUP ${NORMAL_USER}
ENV NORMAL_USER_UID 998
ENV NORMAL_USER_GID 997
RUN groupadd -g ${NORMAL_USER_GID} ${NORMAL_GROUP} \
  && useradd ${NORMAL_USER} --uid ${NORMAL_USER_UID} \
         --shell /bin/bash  --gid ${NORMAL_USER_GID} \
         --create-home \
  && usermod -a -G sudo ${NORMAL_USER} \
  && gpasswd -a ${NORMAL_USER} video \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers
ENV NORMAL_USER_HOME /home/${NORMAL_USER}

#====================
# Supervisor install
#====================
# https://github.com/Supervisor/supervisor
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     supervisor \
# 2015-06-24 commit: b3ad59703b554f, version: supervisor-4.0.0.dev0
#  https://github.com/Supervisor/supervisor/commit/b3ad59703b554fcf61639ca922e
# TODO: Upgrade to supervisor stable 4.0 as soon as is released
RUN pip install --upgrade \
      https://github.com/Supervisor/supervisor/zipball/b3ad59703b554f \
  && rm -rf /var/lib/apt/lists/*

#=====================
# Use Normal User now
#=====================
USER ${NORMAL_USER}

#==========
# Selenium
#==========
ENV SEL_MAJOR_MINOR_VER 2.46
ENV SEL_PATCH_LEVEL_VER 0
ENV SEL_HOME ${NORMAL_USER_HOME}/selenium
RUN  mkdir -p ${SEL_HOME} \
  && export SELBASE="http://selenium-release.storage.googleapis.com" \
  && export SELPATH="${SEL_MAJOR_MINOR_VER}/selenium-server-standalone-${SEL_MAJOR_MINOR_VER}.${SEL_PATCH_LEVEL_VER}.jar" \
  && wget --no-verbose ${SELBASE}/${SELPATH} \
      -O ${SEL_HOME}/selenium-server-standalone.jar

#==================
# Chrome webdriver
#==================
# How to get cpu arch dynamically: $(lscpu | grep Architecture | sed "s/^.*_//")
ENV CPU_ARCH 64
ENV CHROME_DRIVER_FILE "chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_BASE chromedriver.storage.googleapis.com
# Gets latest chrome driver version. Or you can hard-code it, e.g. 2.15
RUN mkdir -p ${NORMAL_USER_HOME}/tmp && cd ${NORMAL_USER_HOME}/tmp \
  # && CHROME_DRIVER_VERSION=2.15 \
  && CHROME_DRIVER_VERSION=$(curl 'http://chromedriver.storage.googleapis.com/LATEST_RELEASE' 2> /dev/null) \
  && CHROME_DRIVER_URL="${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}" \
  && wget --no-verbose -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
  && cd ${SEL_HOME} \
  && rm -rf chromedriver \
  && unzip ${NORMAL_USER_HOME}/tmp/chromedriver_linux${CPU_ARCH}.zip \
  && rm ${NORMAL_USER_HOME}/tmp/chromedriver_linux${CPU_ARCH}.zip \
  && mv ${SEL_HOME}/chromedriver \
        ${SEL_HOME}/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 ${SEL_HOME}/chromedriver-$CHROME_DRIVER_VERSION \
  && ln -s ${SEL_HOME}/chromedriver-${CHROME_DRIVER_VERSION} \
           ${SEL_HOME}/chromedriver

#==========================================================
# Google Chrome - Keep chrome versions as they delete them
#==========================================================
# How to get notified of latest version of chrome:
#  https://chrome.google.com/webstore/detail/the-latest-versions-of-go/bibclkcoilbnbnppanidhimphmfbjaab
# TODO: Use Google fingerprint to verify downloads
#  http://www.google.de/linuxrepositories/
RUN mkdir -p ${NORMAL_USER_HOME}/chrome-deb \
  && wget --no-verbose -O \
    ${NORMAL_USER_HOME}/chrome-deb/google-chrome-stable_current_amd64.deb \
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

#==============
# Back to sudo
#==============
USER root

#=====================================
# Google Chrome - Latest through apt
#=====================================
#==========================
# If you have issue "Failed to move to new PID namespace" on OpenVZ (AWS ECS)
#  https://bugs.launchpad.net/chromium-browser/+bug/577919
# - try to pass chrome switch --no-sandbox see: http://peter.sh/experiments/chromium-command-line-switches/#no-sandbox
# - try /dev/shm? see: https://github.com/travis-ci/travis-ci/issues/938#issuecomment-16345102
# - try xserver-xephyr see: https://github.com/enkidulan/hangout_api/blob/master/.travis.yml#L5
#     && sudo chmod 1777 /dev/shm \
# - try /opt/google/chrome/chrome-sandbox see: https://github.com/web-animations/web-animations-js/blob/master/.travis-setup.sh#L66
# Package libnss3-1d might help with issue 20
#     libnss3-1d \
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#   && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
#   && apt-get update -qqy \
#   && apt-get -qqy install \
#     google-chrome-stable \
#   && rm -rf /var/lib/apt/lists/* \
#   && rm /etc/apt/sources.list.d/google-chrome.list

#===================
# VNC, Xvfb, Xdummy
#===================
# xvfb: Xvfb or X virtual framebuffer is a display server
#  + implements the X11 display server protocol
#  + performs all graphical operations in memory
#
# Xdummy: Is like Xvfb but uses an LD_PRELOAD hack to run a stock X server
#  - uses a "dummy" video driver
#  - with Xpra allows to use extensions like Randr, Composite, Damage
#
# Pyvnc2swf: Is a cross-platform screen recording tool (vnc2swf command)
#  - captures screen motion through VNC protocol
#  - generates a Shockwave Flash (SWF) movie
RUN apt-get update -qqy \
  && apt-get -qqy install \
    x11vnc \
    pyvnc2swf \
    xvfb \
    xorg \
    xserver-xorg-video-dummy \
  && rm -rf /var/lib/apt/lists/*

ENV RUN_DIR /var/run/sele

#======================
# OpenSSH server (sshd)
#======================
# http://linux.die.net/man/5/sshd_config
# http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man5/sshd_config.5
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openssh-server \
  && echo "PidFile ${RUN_DIR}/sshd.pid" >> /etc/ssh/sshd_config \
  && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes"  >> /etc/ssh/sshd_config \
  && rm -rf /var/lib/apt/lists/*

#=========
# Android
#=========
# TODO
# https://github.com/web-animations/web-animations-js/blob/master/.travis-setup.sh#L50
# https://github.com/elgalu/pastedirectory/blob/master/static/web_components/web-animations-js/tools/android/setup.sh

#===================
# DNS & hosts stuff
#===================
COPY ./dns/etc/hosts /tmp/hosts

########################################
# noVNC to expose VNC via an html page #
########################################
RUN mkdir -p ${NORMAL_USER_HOME}/tmp && cd ${NORMAL_USER_HOME}/tmp \
  # Download noVNC commit 8f3c0f6b9 dated 2015-07-01
  && export NOVNC_SHA="8f3c0f6b9b5e5c23a7dc7e90bd22901017ab4fc7" \
  && wget -O noVNC.zip \
      "https://github.com/kanaka/noVNC/archive/${NOVNC_SHA}.zip" \
  && unzip -x noVNC.zip \
  && mv noVNC-${NOVNC_SHA} \
       ${NORMAL_USER_HOME}/noVNC \
  # Download websockify commit 558a6439f dated 2015-06-02
  && export WEBSOCKIFY_SHA="558a6439f14b0d85a31145541745e25c255d576b" \
  && wget -O websockify.zip \
      "https://github.com/kanaka/websockify/archive/${WEBSOCKIFY_SHA}.zip" \
  && unzip -x websockify.zip \
  && mv websockify-${WEBSOCKIFY_SHA} \
       ${NORMAL_USER_HOME}/noVNC/utils/websockify

#======================
# Chrome, Chromedriver
#======================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    gdebi \
  && gdebi --non-interactive \
      ${NORMAL_USER_HOME}/chrome-deb/google-chrome-stable_current_amd64.deb \
  && ln -s ${SEL_HOME}/chromedriver /usr/bin \
  && chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${SEL_HOME} \
  && rm -rf /var/lib/apt/lists/*

#==========================
# Mozilla Firefox - Latest
#==========================
# dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     firefox \
#     dbus-x11 \
#   && rm -rf /var/lib/apt/lists/*

#=================
# Mozilla Firefox
#=================
# Where to find latest version:
#  http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/linux-x86_64/en-US/
# dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
# FIREFOX_VERSION can be latest // 38.0 // 37.0 // 37.0.1 // 37.0.2 and so on
# FF_LANG can be either en-US // de // fr and so on
# Regarding the pip packages, see released versions at:
#  https://github.com/mozilla/mozdownload/releases
ENV FIREFOX_VERSION latest
ENV FF_LANG "en-US"
RUN apt-get update -qqy \
  && apt-get -qqy install \
    dbus-x11 \
  && pip install --upgrade mozInstall==1.12 \
  # Always safer to install for git specific commit, in this case
  #  commit 191a3e6bc700a28f3d62 dated 2015-06-02 is version 1.15
  # && pip install --upgrade mozdownload==1.15 \
  && pip install --upgrade \
        https://github.com/mozilla/mozdownload/zipball/191a3e6bc700a28f3d62 \
  && mkdir -p ${NORMAL_USER_HOME}/firefox-src \
  && cd ${NORMAL_USER_HOME}/firefox-src \
  && mozdownload --application=firefox --locale=$FF_LANG --retry-attempts=3 \
      --platform=linux64 --log-level=WARN --version=$FIREFOX_VERSION \
  && mozinstall --app=firefox \
      firefox-$FIREFOX_VERSION.$FF_LANG.linux64.tar.bz2 \
      --destination=${SEL_HOME} \
  && ln -s ${SEL_HOME}/firefox/firefox /usr/bin \
  && chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${SEL_HOME} \
  && rm -rf /var/lib/apt/lists/*

#=================
# Supervisor conf
#=================
ADD supervisor/etc/supervisor/supervisord.conf /etc/supervisor/
ADD xvfb/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD xmanager/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD vnc/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD novnc/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD sshd/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD selenium/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD xterm/etc/supervisor/conf.d/* /etc/supervisor/conf.d/

#==================
# User & ssh stuff
#==================
USER ${NORMAL_USER}
ENV USER ${NORMAL_USER}
ENV HOME ${NORMAL_USER_HOME}
ENV VNC_STORE_PWD_FILE ${HOME}/.vnc/passwd

#========================================================================
# Some configuration options that can be customized at container runtime
#========================================================================
ENV BIN_UTILS /bin-utils
ENV PATH ${PATH}:${BIN_UTILS}
# JVM uses only 1/4 of system memory by default
ENV MEM_JAVA_PERCENT 80
# Max amount of time to wait for other processes dependencies
ENV WAIT_TIMEOUT 5s
ENV SCREEN_WIDTH 1900
ENV SCREEN_HEIGHT 1480
ENV SCREEN_MAIN_DEPTH 24
ENV SCREEN_DEPTH ${SCREEN_MAIN_DEPTH}+32
ENV DISP_N 10
ENV DISPLAY :${DISP_N}
ENV XEPHYR_DISPLAY :${DISP_N}
ENV SCREEN_NUM 0
# ENV XEPHYR_SCREEN_SIZE "${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}"""
# Even though you can change them below, don't worry too much about container
# internal ports since you can map them to the host via `docker run -p`
ENV SELENIUM_PORT 24444
ENV VNC_PORT 25900
ENV NOVNC_PORT 26080
# You can set the VNC password or leave null so a random password is generated:
# ENV VNC_PASSWORD topsecret
ENV SSHD_PORT 22222
# Supervisor (process management) http server
ENV SUPERVISOR_HTTP_PORT 29001
ENV SUPERVISOR_HTTP_USERNAME supervisorweb
ENV SUPERVISOR_HTTP_PASSWORD somehttpbasicauthpwd
# Supervisor loglevel and also general docker log level
# can be: debug, warn, trace, info
ENV LOGLEVEL info
ENV LOGFILE_MAXBYTES 10MB
ENV LOGFILE_BACKUPS 5
# Logs are now managed by supervisord.conf, see
#  ${LOGS_DIR}/*.log
ENV LOGS_DIR /var/log/sele
#===============================
# Run docker from inside docker
# Usage: docker run -v /var/run/docker.sock:/var/run/docker.sock
#                   -v $(which docker):$(which docker)
ENV DOCKER_SOCK "/var/run/docker.sock"

#================================
# Expose Container's Directories
#================================
# VOLUME ${LOGS_DIR}

# Only expose ssh port given the other services are not secured
# forcing the user to open ssh tunnels or use docker run -p ports...
# EXPOSE ${SELENIUM_PORT} ${VNC_PORT} ${SSHD_PORT} ${TOMCAT_PORT}
EXPOSE ${SSHD_PORT}

#================
# Binary scripts
#================
ADD bin/* ${BIN_UTILS}/
ADD utils/bin/* ${BIN_UTILS}/
ADD java/bin/* ${BIN_UTILS}/
ADD dns/bin/* ${BIN_UTILS}/
ADD xvfb/bin/* ${BIN_UTILS}/
ADD xmanager/bin/* ${BIN_UTILS}/
ADD vnc/bin/* ${BIN_UTILS}/
ADD novnc/bin/* ${BIN_UTILS}/
ADD sshd/bin/* ${BIN_UTILS}/
ADD selenium/bin/* ${BIN_UTILS}/
ADD xterm/bin/* ${BIN_UTILS}/

#=====================================================
# Meta JSON file to hold commit info of current build
#=====================================================
COPY scm-source.json /
# Ensure the file is up-to-date else you should update it by running
#  ./host-scripts/gen-scm-source.sh
# on the host
RUN [ $(find ./ -mtime -1 -type f -name "scm-source.json" 2>/dev/null) ] \
    || please_update_scm-source_json

#===================
# CMD or ENTRYPOINT
#===================
# ENTRYPOINT ["entry.sh"]
CMD ["entry.sh"]
# CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
