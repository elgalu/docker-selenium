###################################################
# Selenium standalone docker for Chrome & Firefox #
###################################################
#== Ubuntu xenial is 16.04, i.e. FROM ubuntu:16.04
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
# next:     xenial-TBD
FROM ubuntu:xenial-20160303.1
ENV UBUNTU_FLAVOR xenial

#== Ubuntu wily is 15.10, i.e. FROM ubuntu:15.10
# FROM ubuntu:wily-20151208
# ENV UBUNTU_FLAVOR wily

#== Ubuntu vivid is 15.04, i.e. FROM ubuntu:15.04
#                    http://cloud-images.ubuntu.com/releases/15.04/
# FROM ubuntu:vivid-20150611
# ENV UBUNTU_FLAVOR vivid

#== Ubuntu trusty is 14.04, i.e. FROM ubuntu:14.04
#== Could also use ubuntu:latest but for the sake I replicating an precise env...
#                    http://cloud-images.ubuntu.com/releases/14.04/
# FROM ubuntu:trusty-20150630
# ENV UBUNTU_FLAVOR trusty

#== Ubuntu precise is 12.04, i.e. FROM ubuntu:12.04
#== Could also use ubuntu:latest but for the sake I replicating an precise env...
#                    http://cloud-images.ubuntu.com/releases/12.04/
# FROM ubuntu:precise-20150612
# ENV UBUNTU_FLAVOR precise

#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list

MAINTAINER Leo Gallucci <elgalu3@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

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
# dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
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
    tree \
    dbus-x11 \
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

#==============================
# Java9 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     openjdk-9-jre-headless \
#   && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /etc/java-9-openjdk/security/java.security \
#   && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /etc/java-9-openjdk/security/java.security \
#   && rm -rf /var/lib/apt/lists/*

#==================
# Java8 - Oracle
#==================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     software-properties-common \
#   && echo debconf shared/accepted-oracle-license-v1-1 \
#       select true | debconf-set-selections \
#   && echo debconf shared/accepted-oracle-license-v1-1 \
#       seen true | debconf-set-selections \
#   && add-apt-repository ppa:webupd8team/java \
#   && apt-get update -qqy \
#   && apt-get -qqy install \
#     oracle-java8-installer \
#   && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security \
#   && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security \
#   && rm -rf /var/lib/apt/lists/*

#==================
# Java9 - Oracle
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
    oracle-java9-installer \
  && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-9-oracle/conf/security/java.security \
  && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-9-oracle/conf/security/java.security \
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
RUN apt-get update -qqy \
  && apt-get -qqy install \
    fluxbox \
  && rm -rf /var/lib/apt/lists/*

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
# RUN wget -nv -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#   && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
#   && apt-get update -qqy \
#   && apt-get -qqy install \
#     google-chrome-${CHROME_FLAVOR} \
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

#============
# SelenDroid
#============
# TODO
# https://github.com/selendroid/selendroid
# http://selendroid.io/scale.html

########################################
# noVNC to expose VNC via an html page #
########################################
# RUN mkdir -p ${NORMAL_USER_HOME}/tmp && cd ${NORMAL_USER_HOME}/tmp \
#   # Download noVNC commit 8f3c0f6b9 dated 2015-07-01
#   && export NOVNC_SHA="8f3c0f6b9b5e5c23a7dc7e90bd22901017ab4fc7" \
#   && wget -nv -O noVNC.zip \
#       "https://github.com/kanaka/noVNC/archive/${NOVNC_SHA}.zip" \
#   && unzip -x noVNC.zip \
#   && mv noVNC-${NOVNC_SHA} \
#        ${NORMAL_USER_HOME}/noVNC \
#   # Download websockify commit 558a6439f dated 2015-06-02
#   && export WEBSOCKIFY_SHA="558a6439f14b0d85a31145541745e25c255d576b" \
#   && wget -nv -O websockify.zip \
#       "https://github.com/kanaka/websockify/archive/${WEBSOCKIFY_SHA}.zip" \
#   && unzip -x websockify.zip \
#   && mv websockify-${WEBSOCKIFY_SHA} \
#        ${NORMAL_USER_HOME}/noVNC/utils/websockify

#===============================
# ffmpeg/libav and video codecs
#===============================
# ffmpeg (ffmpeg): Is a better alternative to Pyvnc2swf
#   (use in Ubuntu >= 15) packages: ffmpeg
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     libx264-dev \
#     libvorbis-dev \
#     libx11-dev \
#     ffmpeg \
#   && rm -rf /var/lib/apt/lists/*

#===============================
# ffmpeg/libav and video codecs
#===============================
# libav-tools (avconv): Is a fork of ffmpeg
#   (use in Ubuntu <= 14) packages: libav-tools libx264-142
RUN apt-get update -qqy \
  && apt-get -qqy install \
    libx264-dev \
    libvorbis-dev \
    libx11-dev \
    libav-tools \
  && rm -rf /var/lib/apt/lists/*

#=======================================================
# video-to-animated-gifs with vvo/gifify and imagemagick
#=======================================================
# gifify: check elgalu/gifify-docker instead
# imagemagick convert between image formats as well as transformations
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     imagemagick \
#     fontconfig \
#     libfontconfig1 \
#     libfontconfig1-dev \
#     libass5 \
#     libass-dev \
#   && rm -rf /var/lib/apt/lists/*

#=====================
# gifsicle for gifify
#=====================
# install fork of gifsicle with better lossless gif support
# ENV GIFS_VER=1.82.1
# RUN cd /usr/local/lib \
#   && wget -nv "https://github.com/pornel/giflossy/releases/download/lossy%2F${GIFS_VER}/gifsicle-${GIFS_VER}-lossy.zip" \
#   && unzip gifsicle-${GIFS_VER}-lossy.zip -d gifsicle \
#   && rm gifsicle-${GIFS_VER}-lossy.zip \
#   && mv gifsicle/linux/gifsicle-debian6 /usr/local/bin/gifsicle \
#   && gifsicle --version

#=================================
# NodeJS so we can install gifify
#=================================
# See gifify options at https://github.com/vvo/gifify#command-line-usage
# some possible versions: v4.3.2, v5.7.1
# ENV NODE_VER="v5.7.1" \
#     NODE_PLATFORM="linux-x64" \
#     PATH=/usr/local/lib/node/bin:$PATH
# RUN NODE_FIL="node-${NODE_VER}-${NODE_PLATFORM}" \
#   && cd /usr/local/lib \
#   && wget -nv "https://nodejs.org/dist/${NODE_VER}/${NODE_FIL}.tar.xz" \
#   && tar xf ${NODE_FIL}.tar.xz \
#   && rm ${NODE_FIL}.tar.* \
#   && mv ${NODE_FIL} node \
#   && node --version \
#   && npm --version \
#   && npm install -g gifify \
#   && gifify --version

#==========================
# Mozilla Firefox - Latest
#==========================
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     firefox \
#   && rm -rf /var/lib/apt/lists/*

#=========================================
# Python2 for Supervisor and other stuff
#=========================================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    python2.7 \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qqy \
  && apt-get -qqy install \
    python-pip \
  && pip install --upgrade pip \
  && pip install --upgrade setuptools \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qqy \
  && apt-get -qqy install \
    python-openssl \
    libssl-dev libffi-dev \
  && rm -rf /var/lib/apt/lists/*

#=========================================
# Python3 for Supervisor, others
#=========================================
# Note Python3 fails installing mozInstall==1.12 with
#  NameError: name 'file' is not defined
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     python3.5 \
#     python3-pip \
#     python3.5-dev \
#     python3-openssl \
#     libssl-dev libffi-dev \
#   && pip3 install --upgrade pip \
#   && rm -rf /var/lib/apt/lists/*

ENV CPU_ARCH 64
ENV SEL_HOME ${NORMAL_USER_HOME}/selenium

#===============================
# Mozilla Firefox install tools
#===============================
# ENV FF_LANG "en-US"
# Browser language/locale
# Using mozlog==2.10 or 3.1 to avoid
#  AttributeError: 'module' object has no attribute 'getLogger'
# Update BASE_URL
#  MOZ_DOWN_SHA="894e579b8de6a0ec05e98ccae8d4c2c730657c19
# RUN  mkdir -p ${NORMAL_USER_HOME}/firefox-src \
#   && mkdir -p ${SEL_HOME} \
#   && pip install mozlog==3.1 \
#   && export MOZ_DOWN_SHA="cc7aa3f0d7dee05e92dee0a894dd90cc982a91d8" \
#   && pip install \
#       "https://github.com/elgalu/mozdownload/zipball/${MOZ_DOWN_SHA}" \
#   && pip install mozInstall==1.12 \
#   && echo ""

# elgalu fork (no longer working since s3 mozilla changes)
  # && export MOZ_DOWN_SHA="aaf77cdbe15e6283654883afcd41d2acaeea7a24" \
  # && pip install \
  #     "https://github.com/elgalu/mozdownload/zipball/${MOZ_DOWN_SHA}" \

# more forks:
# RUN  export MOZ_INST_SHA="163e711efb751a80d03d9fb6e2ac0e011902c9df" \
#   && export MOZ_DOWN_SHA="028ae444426b6e7691138e88ac306c6f8e6dfd74" \
#   && pip install --upgrade requests==2.6.0 \
#   && pip install --upgrade \
#       "https://github.com/elgalu/mozinstall/zipball/${MOZ_INST_SHA}" \
#   && pip install --upgrade \
#       "https://github.com/mozilla/mozdownload/zipball/${MOZ_DOWN_SHA}" \
#   && mkdir -p ${NORMAL_USER_HOME}/firefox-src
# Notes:
#  Always safer to install for git specific commit, in this case
#   mozInstall  commit 163e711ef dated 2015-06-11 is version 1.12
#  && pip install --upgrade mozInstall==1.12 \
#   mozdownload commit 028ae4444 dated 2015-03-05 is version 1.14
#  && pip install --upgrade mozdownload==1.14 \

#====================
# Supervisor install
#====================
# https://github.com/Supervisor/supervisor
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     supervisor \
# 2016-02-01 commit: eb904ccdb3573e, version: supervisor-4.0.0.dev0
# 2015-06-24 commit: b3ad59703b554f, version: supervisor-4.0.0.dev0
# 2015-08-24 commit: 304b4f388d3e3f, supervisor/version.txt: 4.0.0.dev0
#  https://github.com/Supervisor/supervisor/commit/b3ad59703b554fcf61639ca92
#  https://github.com/Supervisor/supervisor/commit/304b4f388d3e3f
# TODO: Upgrade to supervisor stable 4.0 as soon as is released
RUN SHA="eb904ccdb3573e22784ad36fa81de3cbd718afea" \
  && pip install --upgrade \
      "https://github.com/Supervisor/supervisor/zipball/${SHA}" \
  && rm -rf /var/lib/apt/lists/*

#----------------------------#
# FIREFOX_VERSIONS: 24 to 29 #
#----------------------------#
# Will split firefox versions in smaller chunks so the layers are smaller
# All firefox versions we provide from oldes to newest
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS1 "24.0, 25.0.1, 26.0, 27.0.1, 28.0, 29.0.1"
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS1} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

#------------------------------#
# FIREFOX_VERSIONS: 30, 31, 32 #
#------------------------------#
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS2 "30.0, 31.0, 32.0.3"
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS2} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

#------------------------------#
# FIREFOX_VERSIONS: 33, 34, 35 #
#------------------------------#
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS3 "33.0.3, 34.0.5, 35.0.1"
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS3} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

#------------------------------#
# FIREFOX_VERSIONS: 36, 37, 38 #
#------------------------------#
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS4 "36.0.4, 37.0.2, 38.0.6"
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS4} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

#---------------------#
# FIREFOX_VERSIONS 39 #
#---------------------#
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS5 "39.0.3"
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS5} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

# ------------------------#
# Sauce Connect Tunneling #
# ------------------------#
# https://docs.saucelabs.com/reference/sauce-connect/
ENV SAUCE_CONN_VER="sc-4.3.13-linux" \
    SAUCE_CONN_DOWN_URL="https://saucelabs.com/downloads"
RUN cd /tmp \
  && wget -nv "${SAUCE_CONN_DOWN_URL}/${SAUCE_CONN_VER}.tar.gz" \
  && tar -zxf ${SAUCE_CONN_VER}.tar.gz \
  && rm -rf /usr/local/${SAUCE_CONN_VER} \
  && mv ${SAUCE_CONN_VER} /usr/local \
  && ln -sf /usr/local/${SAUCE_CONN_VER}/bin/sc /usr/local/bin/sc \
  && which sc

# -----------------------#
# BrowserStack Tunneling #
# -----------------------#
# https://www.browserstack.com/local-testing
ENV BSTACK_TUNNEL_URL="https://www.browserstack.com/browserstack-local" \
    BSTACK_TUNNEL_ZIP="BrowserStackLocal-linux-x64.zip"
RUN cd /tmp \
  && wget -nv "${BSTACK_TUNNEL_URL}/${BSTACK_TUNNEL_ZIP}" \
  && unzip ${BSTACK_TUNNEL_ZIP} \
  && chmod 755 BrowserStackLocal \
  && rm ${BSTACK_TUNNEL_ZIP} \
  && mv BrowserStackLocal /usr/local/bin \
  && which BrowserStackLocal

#---------------------#
# FIREFOX_VERSIONS 40 #
#---------------------#
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS6 "40.0.3"
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS6} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

#-------------------------#
# FIREFOX_VERSIONS Latest #
#-------------------------#
# Install Latest available firefox version
# this also used to work: ENV FIREFOX_LATEST_VERSION latest
#
# Where to find latest version:
#  https://archive.mozilla.org/pub/mozilla.org/firefox/releases/latest/linux-x86_64/en-US/
#  https://download-installer.cdn.mozilla.net/pub/mozilla.org/firefox/releases/latest/linux-x86_64/en-US/
#  https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/linux-x86_64/en-US/
# e.g. 44.0 instead of latest
#  https://archive.mozilla.org/pub/firefox/releases/44.0/linux-x86_64/en-US/firefox-44.0.tar.bz2
# FF_LANG can be either en-US // de // fr and so on
# Regarding the pip packages, see released versions at:
#  https://github.com/mozilla/mozdownload/releases
ENV FF_VER="45.0" \
    FF_LANG="en-US" \
    FF_PLATFORM="linux-x86_64" \
    FF_BASE_URL="https://archive.mozilla.org/pub" \
    FF_DEST="${SEL_HOME}/firefox"
ENV FF_COMP="firefox-${FF_VER}.tar.bz2"
ENV FF_URL "${FF_BASE_URL}/firefox/releases/${FF_VER}/${FF_PLATFORM}/${FF_LANG}/${FF_COMP}"
RUN mkdir -p ${SEL_HOME} && cd ${SEL_HOME} \
  && wget -nv "${FF_URL}" -O "firefox.tar.bz2" \
  && bzip2 -d "firefox.tar.bz2" \
  && tar xf "firefox.tar" \
  && rm "firefox.tar"

  # && rm -rf ${NORMAL_USER_HOME}/firefox-src
# RUN mkdir -p ${NORMAL_USER_HOME}/firefox-src \
#   && cd ${NORMAL_USER_HOME}/firefox-src \
  # && mkdir -p ${FIREFOX_DEST} && cd ${FIREFOX_DEST} \
# RUN cd ${NORMAL_USER_HOME}/firefox-src \
#   && for FF_VER in $(echo ${FIREFOX_VERSIONS_LAST} | tr "," "\n"); do \
#          mozdownload --application=firefox \
#            --locale=${FF_LANG} --retry-attempts=1 \
#            --platform=linux64 --log-level=WARN --version=${FF_VER} \
#       && export FIREFOX_DEST="${SEL_HOME}/firefox-${FF_VER}" \
#       && mkdir -p ${FIREFOX_DEST} \
#       && mozinstall --app=firefox \
#           firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#           --destination=${FIREFOX_DEST} \
#       && rm firefox-${FF_VER}.${FF_LANG}.linux64.tar.bz2 \
#      ;done

#-----------#
# Fix perms #
#-----------#
RUN  chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${SEL_HOME} \
  && chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${NORMAL_USER_HOME}

#=====================
# Use Normal User now
#=====================
USER ${NORMAL_USER}

#==========
# Selenium
#==========
ENV SEL_MAJOR_MINOR_VER 2.52
ENV SEL_PATCH_LEVEL_VER 0
RUN  mkdir -p ${SEL_HOME} \
  && export SELBASE="http://selenium-release.storage.googleapis.com" \
  && export SELPATH="${SEL_MAJOR_MINOR_VER}/selenium-server-standalone-${SEL_MAJOR_MINOR_VER}.${SEL_PATCH_LEVEL_VER}.jar" \
  && wget -nv ${SELBASE}/${SELPATH} \
      -O ${SEL_HOME}/selenium-server-standalone.jar

#==================
# Chrome webdriver
#==================
# How to get cpu arch dynamically: $(lscpu | grep Architecture | sed "s/^.*_//")
ENV CHROME_DRIVER_FILE "chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_BASE chromedriver.storage.googleapis.com
# Gets latest chrome driver version. Or you can hard-code it, e.g. 2.15
RUN mkdir -p ${NORMAL_USER_HOME}/tmp && cd ${NORMAL_USER_HOME}/tmp \
  # 1st dup line CHROME_DRIVER_VERSION is just to invalidate docker cache
  && CHROME_DRIVER_VERSION="2.21" \
  # && CHROME_DRIVER_VERSION=$(curl 'http://chromedriver.storage.googleapis.com/LATEST_RELEASE' 2> /dev/null) \
  && CHROME_DRIVER_URL="${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}" \
  && wget -nv -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
  && cd ${SEL_HOME} \
  && rm -rf chromedriver \
  && unzip ${NORMAL_USER_HOME}/tmp/chromedriver_linux${CPU_ARCH}.zip \
  && rm ${NORMAL_USER_HOME}/tmp/chromedriver_linux${CPU_ARCH}.zip \
  && mv ${SEL_HOME}/chromedriver \
        ${SEL_HOME}/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 ${SEL_HOME}/chromedriver-$CHROME_DRIVER_VERSION \
  && ln -s ${SEL_HOME}/chromedriver-${CHROME_DRIVER_VERSION} \
           ${SEL_HOME}/chromedriver

#========================
# Google Chrome download
#========================
# How to download chrome-deb locally to keep them
#  wget -nv -O /tmp/google-chrome-stable_current_amd64.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# How to get notified of latest version of chrome:
#  https://chrome.google.com/webstore/detail/the-latest-versions-of-go/bibclkcoilbnbnppanidhimphmfbjaab
# TODO: Use Google fingerprint to verify downloads
#  http://www.google.de/linuxrepositories/
# Also fix .deb file names with correct version
RUN  latest_chrome_version_trigger="49.0.2623.87" \
  && mkdir -p ${NORMAL_USER_HOME}/chrome-deb \
  && export CHROME_URL="https://dl.google.com/linux/direct" \
  && wget -nv -O \
    ${NORMAL_USER_HOME}/chrome-deb/google-chrome-stable_current_amd64.deb \
    "${CHROME_URL}/google-chrome-stable_current_amd64.deb"
# Other chrome flavors are commented now since they were not being used:
  # && wget -nv -O \
  #   ${NORMAL_USER_HOME}/chrome-deb/google-chrome-beta_current_amd64.deb \
  #   "${CHROME_URL}/google-chrome-beta_current_amd64.deb" \
  # && wget -nv -O \
  #   ${NORMAL_USER_HOME}/chrome-deb/google-chrome-unstable_current_amd64.deb \
  #   "${CHROME_URL}/google-chrome-unstable_current_amd64.deb"
# Where to find old versions of chrome:
#   43, 44, 45, 46 -- https://github.com/elgalu/docker-selenium/releases/tag/2.48.2f
#   47 -- https://github.com/elgalu/docker-selenium/releases/tag/latest

USER root

#=======
# GDebi
#=======
RUN apt-get update -qqy \
  && apt-get -qqy install \
    gdebi

#========
# Chrome
#========
ENV CHROME_BASE_DEB_PATH "${NORMAL_USER_HOME}/chrome-deb/google-chrome"
ENV GREP_ONLY_NUMS_VER "[0-9.]{2,20}"
RUN gdebi --non-interactive ${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb \
# Other chrome flavors are commented now since they were not being used:
  # && gdebi --non-interactive ${CHROME_BASE_DEB_PATH}-beta_current_amd64.deb \
  # && gdebi --non-interactive ${CHROME_BASE_DEB_PATH}-unstable_current_amd64.deb \
  && export CH_STABLE_VER=$(/usr/bin/google-chrome-stable --version | grep -iEo "${GREP_ONLY_NUMS_VER}") \
  # && export CH_BETA_VER=$(/usr/bin/google-chrome-beta --version | grep -iEo "${GREP_ONLY_NUMS_VER}") \
  # && export CH_UNSTABLE_VER=$(/usr/bin/google-chrome-unstable --version | grep -iEo "${GREP_ONLY_NUMS_VER}") \
  && echo "${CH_STABLE_VER}" \
  && rm ${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb
  # && mv ${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb \
  #    ${CHROME_BASE_DEB_PATH}-stable_${CH_STABLE_VER}_amd64.deb \
  # && mv ${CHROME_BASE_DEB_PATH}-beta_current_amd64.deb \
  #    ${CHROME_BASE_DEB_PATH}-beta_${CH_BETA_VER}_amd64.deb \
  # && mv ${CHROME_BASE_DEB_PATH}-unstable_current_amd64.deb \
  #    ${CHROME_BASE_DEB_PATH}-unstable_${CH_UNSTABLE_VER}_amd64.deb \

# Specifically to have a wrapper for /opt/google/chrome/google-chrome
RUN mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome-base
ADD selenium-node-chrome/opt /opt

#==============
# Chromedriver
#==============
RUN ln -s ${SEL_HOME}/chromedriver /usr/bin \
  && chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${SEL_HOME} \
  && rm -rf /var/lib/apt/lists/*

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

#=================
# Supervisor conf
#=================
ADD supervisor/etc/supervisor/supervisord.conf /etc/supervisor/
ADD **/etc/supervisor/conf.d/* /etc/supervisor/conf.d/

#==============================================
# Java blocks until kernel have enough entropy
# to generate the /dev/random seed
#==============================================
# See: SeleniumHQ/docker-selenium/issues/14
RUN apt-get update -qqy \
  && apt-get -qqy install \
    haveged rng-tools \
  && service haveged start \
  && update-rc.d haveged defaults \
  && rm -rf /var/lib/apt/lists/*

#======
# User
#======
USER ${NORMAL_USER}

#===================
# DNS & hosts stuff
#===================
COPY ./dns/etc/hosts /tmp/hosts

#======
# Envs
#======
# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# ENV FIREFOX_VERSIONS="${FIREFOX_VERSIONS1}, ${FIREFOX_VERSIONS2}, ${FIREFOX_VERSIONS3}, ${FIREFOX_VERSIONS4}, ${FIREFOX_VERSIONS5}, ${FIREFOX_VERSIONS6}, ${FIREFOX_VERSIONS_LAST}" \
# ENV FIREFOX_VERSIONS="${FIREFOX_VERSIONS_LAST}" \
  # Firefox version to use during run
  # For firefox please pick one of $FIREFOX_VERSIONS, default latest
ENV FIREFOX_VERSION="${FF_VER}" \
  # Default chrome flavor, options no longer avariable: beta|unstable
  CHROME_FLAVOR="stable" \
  # User and home
  USER="${NORMAL_USER}" \
  HOME="${NORMAL_USER_HOME}" \
  # Vnc password file
  VNC_STORE_PWD_FILE="${NORMAL_USER_HOME}/.vnc/passwd" \
  BIN_UTILS="/usr/bin" \
  # JVM uses only 1/4 of system memory by default
  MEM_JAVA_PERCENT=80 \
  # Max amount of time to wait for other processes dependencies
  WAIT_TIMEOUT="15s" \
  SCREEN_WIDTH=1900 \
  SCREEN_HEIGHT=1480 \
  SCREEN_MAIN_DEPTH=24 \
  SCREEN_SUB_DEPTH=32 \
  # Display number; see entry.sh for $DISPLAY
  DISP_N=10 \
  SCREEN_NUM=0 \
  # ENV XEPHYR_SCREEN_SIZE "${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}"""
  # Even though you can change them below, don't worry too much about container
  # internal ports since you can map them to the host via `docker run -p`
  SELENIUM_HUB_PORT=24444 \
  # You may want to connect to another hub
  SELENIUM_HUB_HOST="127.0.0.1" \
  SELENIUM_NODE_HOST="127.0.0.1" \
  SELENIUM_NODE_CH_PORT=25550 \
  SELENIUM_NODE_FF_PORT=25551 \
  # Selenium additional params:
  SELENIUM_HUB_PARAMS="" \
  SELENIUM_NODE_PARAMS="" \
  # To taggle issue #58 see https://goo.gl/fz6RTu
  CHROME_ARGS="--no-sandbox" \
  # SELENIUM_NODE_CHROME_PARAMS='-Dselenium.chrome.args="--no-sandbox"' \
  # WEBDRIVER_NODE_CHROME_PARAMS='-Dwebdriver.chrome.args="--no-sandbox"' \
  # Selenium capabilities descriptive (to avoid opera/ie warnings)
  #  docs at https://code.google.com/p/selenium/wiki/Grid2
  MAX_INSTANCES=1 \
  MAX_SESSIONS=1 \
  SEL_RELEASE_TIMEOUT_SECS=19000 \
  SEL_BROWSER_TIMEOUT_SECS=16000 \
  SEL_CLEANUPCYCLE_MS=90000 \
  SEL_NODEPOLLING_MS=80000 \
  # Vnc
  VNC_PORT=25900 \
  NOVNC_PORT=26080 \
  NOVNC=false \
  # You can set the VNC password or leave null so a random password is generated:
  # ENV VNC_PASSWORD topsecret
  SSHD_PORT=22222 \
  # Supervisor (process management) http server
  SUPERVISOR_HTTP_PORT=29001 \
  SUPERVISOR_HTTP_USERNAME=supervisorweb \
  SUPERVISOR_HTTP_PASSWORD=somehttpbasicauthpwd \
  SUPERVISOR_REQUIRED_SRV_LIST="vnc|sshd|xmanager|xvfb" \
  SUPERVISOR_NOT_REQUIRED_SRV_LIST1="ignoreMe" \
  SUPERVISOR_NOT_REQUIRED_SRV_LIST2="ignoreMe" \
  SLEEP_SECS_AFTER_KILLING_SUPERVISORD=3 \
  SUPERVISOR_STOPWAITSECS=20 \
  # Supervisor loglevel and also general docker log level
  # can be: debug, warn, trace, info
  LOG_LEVEL=info \
  # when DISABLE_ROLLBACK=true it will:
  #  - output logs
  #  - exec bash to permit troubleshooting
  DISABLE_ROLLBACK=false \
  LOGFILE_MAXBYTES=10MB \
  LOGFILE_BACKUPS=5 \
  # Logs are now managed by supervisord.conf, see
  #  ${LOGS_DIR}/*.log
  LOGS_DIR="/var/log/cont" \
  # ENV VIDEO_FORMAT xxxx
  # Encoding movie type "flv", "swf5", "swf7", "mpeg" (PyMedia required)
  # or "vnc" more info at http://www.unixuser.org/~euske/vnc2swf/pyvnc2swf.html
  VNC2SWF_ENCODING=swf5 \
  # Specifies the framerate in fps. (default=12.0). Reducing the frame rate
  # sometimes helps reducing the movie size.
  VNC2SWF_FRAMERATE=25 \
  # ffmpeg encoding options
  FFMPEG_FRAME_RATE=15 \
  # Video size can be lowered down via re-encoding, see
  #  http://askubuntu.com/a/365221/134645
  FFMPEG_CODEC_ARGS="-vcodec libx264 -crf 0 -preset ultrafast" \
  # Services to start by default; true/false
  VIDEO=false \
  GRID=true \
  CHROME=true \
  FIREFOX=true \
  # Video file and extension, e.g. swf, mp4, mkv, flv
  VIDEO_FILE_EXTENSION="mkv" \
  VIDEO_FILE_NAME="test" \
  VIDEO_FLUSH_SECS="0.5" \
  VIDEO_CHUNK_SECS="00:05:00" \
  VIDEO_CHUNKS_MAX=999 \
  VIDEOS_DIR="${NORMAL_USER_HOME}/videos" \
  # You can choose what X manager to use
  XMANAGER="fluxbox" \
  # Sauce Labs tunneling. Naming is required: SAUCE_TUNNEL_ID
  SAUCE_TUNNEL="false" \
  SAUCE_USER_NAME="" \
  SAUCE_API_KEY="" \
  SAUCE_TUNNEL_DOCTOR_TEST="false" \
  SAUCE_TUNNEL_ID="docker-selenium" \
  SAUCE_TUNNEL_READY_FILE="/tmp/sauce-connect-ready" \
  SAUCE_LOCAL_SEL_PORT="4445" \
  SAUCE_WAIT_TIMEOUT="140s" \
  SAUCE_WAIT_RETRY_TIMEOUT="290s" \
  SAUCE_TUNNEL_MAX_RETRY_ATTEMPTS="1" \
  # BrowserStack tunneling. Naming is required: BSTACK_TUNNEL_ID
  BSTACK_TUNNEL="false" \
  BSTACK_ACCESS_KEY="" \
  BSTACK_TUNNEL_ID="docker-selenium" \
  BSTACK_TUNNEL_OPTS="-skipCheck -v -forcelocal" \
  BSTACK_WAIT_TIMEOUT="100s" \
  BSTACK_WAIT_RETRY_TIMEOUT="220s" \
  # Amount of lines to display when startup errors
  TAIL_LOG_LINES="15" \
  # Fix small tiny 64mb shm issue
  SHM_TRY_MOUNT_UNMOUNT="false" \
  SHM_SIZE="512M" \
  # When docker run --net=host the network name may be different
  ETHERNET_DEVICE_NAME="eth0" \
  # Supervisord stop signals
  SSHD_STOP_SIGNAL="TERM" \
  XMANAGER_STOP_SIGNAL="TERM" \
  XVFB_STOP_SIGNAL="TERM" \
  XTERM_STOP_SIGNAL="INT" \
  SELENIUM_NODE_FIREFOX_STOP_SIGNAL="TERM" \
  SELENIUM_NODE_CHROME_STOP_SIGNAL="TERM" \
  SELENIUM_HUB_STOP_SIGNAL="TERM" \
  VNC_STOP_SIGNAL="TERM" \
  NOVNC_STOP_SIGNAL="TERM" \
  VIDEO_REC_STOP_SIGNAL="INT" \
  BROWSERSTACK_STOP_SIGNAL="INT" \
  SAUCELABS_STOP_SIGNAL="INT" \
  # Java stuff
  # MEM_JAVA="1024m" \
  #===============================
  # Run docker from inside docker
  # Usage: docker run -v /var/run/docker.sock:/var/run/docker.sock
  #                   -v $(which docker):$(which docker)
  DOCKER_SOCK="/var/run/docker.sock" \
  # https://github.com/SeleniumHQ/docker-selenium/issues/87#issuecomment-187661259
  DBUS_SESSION_BUS_ADDRESS=/dev/null \
  # Restore
  DEBIAN_FRONTEND="" \
  DEBCONF_NONINTERACTIVE_SEEN=""

#================================
# Expose Container's Directories
#================================
# VOLUME ${LOGS_DIR}

# Only expose ssh port given the other services are not secured
# forcing the user to open ssh tunnels or use docker run -p ports...
# EXPOSE ${SELENIUM_HUB_PORT} ${VNC_PORT} ${SSHD_PORT} ${TOMCAT_PORT}
# Do not expose anything, pelase use `docker run -p`
# EXPOSE ${SSHD_PORT}

#================
# Binary scripts
#================
ADD bin/* ${BIN_UTILS}/
ADD **/bin/* ${BIN_UTILS}/
ADD utils/bin/selenium-grep.sh /usr/bin/errors
ADD xterm/bin/timeout-wait-xterm.sh /usr/bin/wait_all_done
ADD host-scripts/* /host-scripts/

#==================
# Fix dirs (again)
#==================
RUN mkdir -p ${NORMAL_USER_HOME}/.vnc \
  # Videos
  && mkdir -p ${VIDEOS_DIR} \
  && sudo ln -s ${VIDEOS_DIR} / \
  # Ssh stuff
  && mkdir -p ${NORMAL_USER_HOME}/.ssh \
  && touch ${NORMAL_USER_HOME}/.ssh/authorized_keys \
  && chmod 700 ${NORMAL_USER_HOME}/.ssh \
  && chmod 600 ${NORMAL_USER_HOME}/.ssh/authorized_keys \
  # Create and fix directories perms
  && sudo mkdir -p ${LOGS_DIR} \
  && sudo mkdir -p ${RUN_DIR} \
  && sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${SEL_HOME} \
  && sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${NORMAL_USER_HOME} \
  && sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${LOGS_DIR} \
  && sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${RUN_DIR} \
  && sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} /etc/supervisor \
  # This X11-unix is useful when using Xephyr
  && sudo mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
  && sudo chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix \
  # To avoid error "Missing privilege separation directory: /var/run/sshd"
  && sudo mkdir -p /var/run/sshd \
  && sudo chmod 744 /var/run/sshd \
  && echo ""

#=====================================================
# Meta JSON file to hold commit info of current build
#=====================================================
COPY scm-source.json /
# Ensure the file is up-to-date else you should update it by running
#  ./host-scripts/gen-scm-source.sh
# on the host machine

#===================
# CMD or ENTRYPOINT
#===================
# - default entrypoint is /bin/sh -c
# - there is no default command CMD
# ENTRYPOINT ["entry.sh"]
# CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
CMD "entry.sh"
