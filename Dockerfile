#== Ubuntu xenial is 16.04, i.e. FROM ubuntu:16.04
# Find latest images at https://hub.docker.com/r/library/ubuntu/
# Layer size: big: 127.2 MB
FROM ubuntu:xenial-20170410
ENV UBUNTU_FLAVOR="xenial" \
    UBUNTU_DATE="20170410"

#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-security main universe\n" >> /etc/apt/sources.list

MAINTAINER Team TIP <elgalu3+team-tip@gmail.com>
# https://github.com/docker/docker/pull/25466#discussion-diff-74622923R677
LABEL maintainer "Team TIP <elgalu3+team-tip@gmail.com>"

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

# http://askubuntu.com/a/235911/134645
# Remove with: sudo apt-key del 2EA8F35793D8809A
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2EA8F35793D8809A \
  && apt-key update -qqy
# Remove with: sudo apt-key del 40976EAF437D05B5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 \
  && apt-key update -qqy
# Remove with: sudo apt-key del 3B4FE6ACC0B21F32
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
  && apt-key update -qqy
# Remove with: sudo apt-key del A2F683C52980AECF
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A2F683C52980AECF \
  && apt-key update -qqy

#========================
# Miscellaneous packages
#========================
# libltdl7        0.3 MB
#   allows to run docker alongside docker
# netcat-openbsd  0.5 MB
#   inlcues `nc` an arbitrary TCP and UDP connections and listens
# pwgen           0.4 MB
#   generates random, meaningless but pronounceable passwords
# bc              0.5 MB
#   An arbitrary precision calculator language
# unzip           0.7 MB
#   uncompress zip files
# bzip2           1.29 MB
#   uncompress bzip files
# apt-utils       1.0 MB
#   commandline utilities related to package management with APT
# net-tools       0.8 MB
#   arp, hostname, ifconfig, netstat, route, plipconfig, iptunnel
# jq              1.1 MB
#   jq is like sed for JSON data, you can use it to slice and filter and map
# sudo            1.3 MB
#   sudo binary
# psmisc          1.445 MB
#   fuser – identifies what processes are using files.
#   killall – kills a process by its name, similar to a pkill Unices.
#   pstree – Shows currently running processes in a tree format.
#   peekfd – Peek at file descriptors of running processes.
# iproute2        2.971 MB
#   to use `ip` command
# iputils-ping    3.7 MB
#   ping, ping6 - send ICMP ECHO_REQUEST to network hosts
# dbus-x11        4.6 MB
#   is needed to avoid http://askubuntu.com/q/237893/134645
# wget            7.3 MB
#   The non-interactive network downloader
# curl             17 MB (real +diff when with wget: 7 MB)
#   transfer URL data using various Internet protocols
# ---------------------------------------------------------
# If we install them separately the total SUM() gives 39 MB
# If we install them together   the total SUM() gives 25 MB
# ---------------------------------------------------------
# Removed packages:
#   telnet          5.2 MB
#     for debugging firewall issues
#   grc              33 MB !!
#     is a terminal colorizer that works nice with tail https://github.com/garabik/grc
#   moreutils        44 MB !!
#     has `ts` that will prepend a timestamp to every line of input you give it
# Layer size: medium: 29.8 MB
# Layer size: medium: 27.9 MB (with --no-install-recommends)
RUN apt-get -qqy update \
  && apt-get -qqy install \
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
  && apt-get -qyy autoremove \
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
# Layer size: small: ~9 MB
# Layer size: small: ~9 MB MB (with --no-install-recommends)
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    language-pack-en \
    tzdata \
    locales \
  && locale-gen ${LANGUAGE} \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/*

#===================
# Timezone settings
#===================
# Full list at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#  e.g. "US/Pacific" for Los Angeles, California, USA
# e.g. ENV TZ "US/Pacific"
ENV TZ="Europe/Berlin"
# Apply TimeZone
# Layer size: tiny: 1.339 MB
RUN echo "Setting time zone to '${TZ}'" \
  && echo "${TZ}" > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#========================================
# Add normal user with passwordless sudo
#========================================
# Layer size: tiny: 0.3 MB
RUN useradd seluser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo seluser \
  && gpasswd -a seluser video \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd

#==============================
# Java8 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
# Layer size: big: 132.2 MB
# Layer size: big: 132.2 MB (with --no-install-recommends)
RUN apt-get -qqy update \
  && apt-get -qqy install \
    openjdk-8-jre-headless \
  && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security \
  && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security \
  && apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/*

#==================
# Java8 - Oracle
#==================
# Regarding urandom see
#  http://stackoverflow.com/q/26021181/511069
#  https://github.com/SeleniumHQ/docker-selenium/issues/14#issuecomment-67414070
# Layer size: huge: 618.6 MB (with --no-install-recommends)
# Layer size: huge: 661.1 MB
# RUN apt-get -qqy update \
#   && apt-get -qqy --no-install-recommends install \
#     software-properties-common \
#   && echo debconf shared/accepted-oracle-license-v1-1 \
#       select true | debconf-set-selections \
#   && echo debconf shared/accepted-oracle-license-v1-1 \
#       seen true | debconf-set-selections \
#   && add-apt-repository ppa:webupd8team/java \
#   && apt-get -qqy update \
#   && apt-get -qqy install \
#     oracle-java8-installer \
#   && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security \
#   && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
#        /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security \
#   && apt-get -qqy install \
#     oracle-java8-set-default \
#   && apt-get -qyy autoremove \
#   && rm -rf /var/lib/apt/lists/*

#==============================================
# Java blocks until kernel have enough entropy
# to generate the /dev/random seed
#==============================================
# See: SeleniumHQ/docker-selenium/issues/14
# Layer size: tiny: 0.8 MB
RUN apt-get -qqy update \
  && apt-key update -qqy \
  && apt-get -qqy install \
    haveged rng-tools \
  && service haveged start \
  && update-rc.d haveged defaults \
  && apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/*

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser
WORKDIR /home/seluser

#======================
# Selenium 2 (default)
#======================
# Layer size: medium: 21.23 MB
ENV SEL_MAJOR_VER="2.53" \
    SEL_PATCH_LEVEL_VER="1"
ENV SEL_VER="${SEL_MAJOR_VER}.${SEL_PATCH_LEVEL_VER}"
RUN  export SELBASE="https://selenium-release.storage.googleapis.com" \
  && export SELPATH="${SEL_MAJOR_VER}/selenium-server-standalone-${SEL_VER}.jar" \
  && wget -nv ${SELBASE}/${SELPATH} \
  && ln -s "selenium-server-standalone-${SEL_VER}.jar" \
           "selenium-server-standalone-2.jar" \
  && ln -s "selenium-server-standalone-${SEL_VER}.jar" \
           "selenium-server-standalone.jar"

#============
# Selenium 3
#============
# Layer size: medium ~22 MB
ENV SEL_DIRECTORY="3.4" \
    SEL_VER="3.4.0"
RUN  export SELBASE="https://selenium-release.storage.googleapis.com" \
  && export SELPATH="${SEL_DIRECTORY}/selenium-server-standalone-${SEL_VER}.jar" \
  && wget -nv ${SELBASE}/${SELPATH} \
  && ln -s "selenium-server-standalone-${SEL_VER}.jar" \
           "selenium-server-standalone-3.jar"

LABEL selenium_version "3.4.0"

#=============================
# sudo by default from now on
#=============================
USER root

#=========================================================
# Python2 for Supervisor, selenium tests, and other stuff
#=========================================================
# Layer size: big.: 79.39 MB (with --no-install-recommends)
# Layer size: huge: 296 MB
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    python2.7 \
    python-pip \
    python-openssl \
    libssl-dev \
    libffi-dev \
  && pip install --upgrade pip \
  && pip install --upgrade setuptools \
  && rm -rf /var/lib/apt/lists/*

#=========================================================
# Python3 for Supervisor, selenium tests, and other stuff
#=========================================================
# Note Python2 comes already installed with Oracle Java
#  so better stick to it to avoid occupying more disk space
# Note Python3 fails installing mozInstall==1.12 with
#  NameError: name 'file' is not defined
# After install, make some useful symlinks that are expected to exist
# Layer size: big.: 138.9 MB (with --no-install-recommends)
# Layer size: huge: 309.9 MB
# RUN apt-get -qqy update \
#   && apt-get -qqy --no-install-recommends install \
#     python3.5 \
#     python3-pip \
#     python3.5-dev \
#     python3-openssl \
#     libssl-dev libffi-dev \
#   && pip3 install --upgrade pip \
#   && pip3 install --upgrade setuptools \
#   && rm -rf /var/lib/apt/lists/*
# RUN cd /usr/local/bin \
#   && { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
#   && ln -s idle3 idle \
#   && ln -s pydoc3 pydoc \
#   && ln -s python3 python \
#   && ln -s python3-config python-config \
#   && ln -s /usr/bin/python3 /usr/bin/python \
#   && python --version \
#   && pip --version

#====================
# Supervisor install
#====================
# TODO: Upgrade to supervisor stable 4.0 as soon as is released
# Check every now and then if version 4 is finally the stable one
#  https://pypi.python.org/pypi/supervisor
#  https://github.com/Supervisor/supervisor
# RUN apt-get -qqy update \
#   && apt-get -qqy install \
#     supervisor \
# 2017-03-07 commit: 23925d017f8ecc, supervisor/version.txt: 4.0.0.dev0
# 2017-01-05 commit: 8be5bc15e83f0f, supervisor/version.txt: 4.0.0.dev0
# 2016-11-05 commit: cbebb93f58f4a9, supervisor/version.txt: 4.0.0.dev0
ENV RUN_DIR="/var/run/sele"
RUN SHA="23925d017f8eccafb1be57c509a07df75490c83d" \
  && pip install --upgrade \
      "https://github.com/Supervisor/supervisor/zipball/${SHA}" \
  && rm -rf /var/lib/apt/lists/*

#================
# Font libraries
#================
# libfontconfig            ~1 MB
# libfreetype6             ~1 MB
# xfonts-cyrillic          ~2 MB
# xfonts-scalable          ~2 MB
# fonts-liberation         ~3 MB
# ttf-ubuntu-font-family   ~5 MB
#   Ubuntu Font Family, sans-serif typeface hinted for clarity
# Removed packages:
# fonts-ipafont-gothic     ~13 MB
# xfonts-100dpi            ~6 MB
# xfonts-75dpi             ~6 MB
# Regarding fonts-liberation see:
#  https://github.com/SeleniumHQ/docker-selenium/issues/383#issuecomment-278367069
# Layer size: small: 6.898 MB (with --no-install-recommends)
# Layer size: small: 6.898 MB
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    libfontconfig \
    libfreetype6 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    ttf-ubuntu-font-family \
  && rm -rf /var/lib/apt/lists/*

#=========
# Openbox
# A lightweight window manager using freedesktop standards
#=========
# Let's disable this as is only filling disk space
# Layer size: huge: 153.4 MB (with --no-install-recommends)
# Layer size: huge: 224.4 MB
# RUN apt-get -qqy update \
#   && apt-get -qqy --no-install-recommends install \
#     openbox obconf menu \
#   && rm -rf /var/lib/apt/lists/*

#=========
# fluxbox
# A fast, lightweight and responsive window manager
#=========
# Layer size: small: 9.659 MB
# Layer size: small: 6.592 MB (with --no-install-recommends)
RUN apt-get -qqy update \
  && apt-get -qqy install \
    fluxbox \
  && rm -rf /var/lib/apt/lists/*

#============================
# Xvfb X virtual framebuffer
#============================
# xvfb: Xvfb or X virtual framebuffer is a display server
#  + implements the X11 display server protocol
#  + performs all graphical operations in memory
# Packages that used to be together in this layer
#   xvfb                      75.69 MB  no-recommends: 68.2 MB
#   xorg                      160.3 MB  no-recommends: 134.6 MB
#   xserver-xorg-video-dummy  116.7 MB  no-recommends: 90.52 MB
# Layer size: big: 136.9 MB (with --no-install-recommends)
# Layer size: big: 162.6 MB
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    xvfb \
    xorg \
  && rm -rf /var/lib/apt/lists/*

#============
# VNC Server
#============
# Layer size: medium: 12.67 MB
# Layer size: medium: 10.08 MB (with --no-install-recommends)
RUN apt-get -qqy update \
  && apt-get -qqy install \
    x11vnc \
  && rm -rf /var/lib/apt/lists/*

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
# Layer size: small: 2.919 MB
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
# Layer size: big: 149.9 MB
# Layer size: big: 135.4 MB (with --no-install-recommends)
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    gstreamer1.0-libav \
  && rm -rf /var/lib/apt/lists/*

#=================================================
# ffmpeg/libav/avconv video codecs & dependencies
#=================================================
# MP4Box (gpac) to clean the video credits to @taskworld @dtinth
# ponchio/untrunc dependencies to restore a damaged (truncated) video
#   libavformat-dev libavcodec-dev libavutil-dev libqt4-dev make g++ libz-dev
# Layer size: medium: ~12 MB (with --no-install-recommends)
# Layer size: medium: ~21 MB
# RUN apt-get -qqy update \
#   && apt-get -qqy --no-install-recommends install \
#     libx264-dev \
#     libvorbis-dev \
#     libx11-dev \
#     gpac \
#   && rm -rf /var/lib/apt/lists/*

#========
# ffmpeg
#========
# MP4Box (gpac) to clean the video credits to @taskworld @dtinth
# ffmpeg (ffmpeg): Is a better alternative to Pyvnc2swf
#   (use in Ubuntu >= 15) packages: ffmpeg
# Layer size: medium: ~12 MB (with --no-install-recommends)
# Layer size: medium: ~17 MB
RUN apt-get -qqy update \
  && apt-get -qqy install \
    ffmpeg \
    gpac \
  && rm -rf /var/lib/apt/lists/*

#==============
# libav/avconv
#==============
# Layer size: medium: 11.58 MB (with --no-install-recommends)
# Layer size: medium: 16.75 MB
# libav-tools (avconv): a fork of ffmpeg
#   a better alternative to Pyvnc2swf
#   (use in Ubuntu <= 14) packages: libav-tools libx264-142
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    libav-tools \
  && rm -rf /var/lib/apt/lists/*

# ------------------------#
# Sauce Connect Tunneling #
# ------------------------#
# Please use https://github.com/zalando/zalenium

# -----------------------#
# BrowserStack Tunneling #
# -----------------------#
# Please use https://github.com/zalando/zalenium

#-----------------#
# Mozilla Firefox #
#-----------------#
# Install all Firefox dependencies
# Layer size: big: 83.51 MB
# Adding libasound2 and others, credits to @jackTheRipper
#  https://github.com/SeleniumHQ/docker-selenium/pull/418
    # libasound2 \
    # libpulse-dev \
    # xul-ext-ubufox \
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    `apt-cache depends firefox | awk '/Depends:/{print$2}'` \
  && rm -rf /var/lib/apt/lists/*

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser

#--- Nightly
# ENV FF_VER="52.0a0" \
#     FF_PLATFORM="linux-i686" \
#     FF_INNER_PATH="firefox/nightly/latest-mozilla-central"
# ENV FF_COMP="firefox-${FF_VER}.${FF_LANG}.${FF_PLATFORM}.tar.bz2"
# ENV FF_URL="${FF_BASE_URL}/${FF_INNER_PATH}/${FF_COMP}"
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

ENV FF_LANG="en-US" \
    FF_BASE_URL="https://archive.mozilla.org/pub" \
    FF_PLATFORM="linux-x86_64" \
    FF_INNER_PATH="firefox/releases"

#--- For Selenium 3
# Layer size: big: 108.2 MB
ENV FF_VER="52.0.2"
ENV FF_COMP="firefox-${FF_VER}.tar.bz2"
ENV FF_URL="${FF_BASE_URL}/${FF_INNER_PATH}/${FF_VER}/${FF_PLATFORM}/${FF_LANG}/${FF_COMP}"
RUN  wget -nv "${FF_URL}" -O "firefox.tar.bz2" \
  && bzip2 -d "firefox.tar.bz2" \
  && tar xf "firefox.tar" \
  && rm "firefox.tar" \
  && mv firefox firefox-for-sel-3 \
  && sudo ln -fs /home/seluser/firefox-for-sel-3/firefox /usr/bin/firefox

#--- Stable for Selenium 2
# Layer size: big: 107 MB
ENV FF_VER="47.0.1"
ENV FF_COMP="firefox-${FF_VER}.tar.bz2"
ENV FF_URL="${FF_BASE_URL}/${FF_INNER_PATH}/${FF_VER}/${FF_PLATFORM}/${FF_LANG}/${FF_COMP}"
RUN  wget -nv "${FF_URL}" -O "firefox.tar.bz2" \
  && bzip2 -d "firefox.tar.bz2" \
  && tar xf "firefox.tar" \
  && rm "firefox.tar" \
  && mv firefox firefox-for-sel-2 \
  && sudo ln -fs /home/seluser/firefox-for-sel-2/firefox /usr/bin/firefox

LABEL selenium2_firefox_version "47.0.1"
LABEL selenium3_firefox_version "52.0.2"
LABEL selenium_firefox_version "52.0.2"

#=============================
# sudo by default from now on
#=============================
USER root

#============
# GeckoDriver
#============
# Layer size: tiny: ~4 MB
ENV GECKOD_VER="0.16.1" \
    GECKOD_URL="https://github.com/mozilla/geckodriver/releases/download"
RUN wget --no-verbose -O geckodriver.tar.gz \
     "${GECKOD_URL}/v${GECKOD_VER}/geckodriver-v${GECKOD_VER}-linux64.tar.gz" \
  && rm -rf /opt/geckodriver* \
  && tar -C /opt -xvzf geckodriver.tar.gz \
  && chmod +x /opt/geckodriver \
  && rm geckodriver.tar.gz

#===============
# Google Chrome
#===============
# TODO: Use Google fingerprint to verify downloads
#  https://www.google.de/linuxrepositories/
ENV CHROME_VERSION_TRIGGER="58.0.3029.81" \
    CHROME_URL="https://dl.google.com/linux/direct" \
    CHROME_BASE_DEB_PATH="/home/seluser/chrome-deb/google-chrome" \
    GREP_ONLY_NUMS_VER="[0-9.]{2,20}"

LABEL selenium2_chrome_version "58.0.3029.81"
LABEL selenium3_chrome_version "58.0.3029.81"
LABEL selenium_chrome_version "58.0.3029.81"

# Layer size: huge: 196.3 MB
RUN apt-get -qqy update \
  && mkdir -p chrome-deb \
  && wget -nv "${CHROME_URL}/google-chrome-stable_current_amd64.deb" \
          -O "./chrome-deb/google-chrome-stable_current_amd64.deb" \
  && apt -qyy --no-install-recommends install \
        "${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb" \
  && rm "${CHROME_BASE_DEB_PATH}-stable_current_amd64.deb" \
  && rm -rf ./chrome-deb \
  && apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && export CH_STABLE_VER=$(/usr/bin/google-chrome-stable --version | grep -iEo "${GREP_ONLY_NUMS_VER}") \
  && echo "${CH_STABLE_VER}"
# We have a wrapper for /opt/google/chrome/google-chrome
RUN mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome-base
COPY selenium-node-chrome/opt /opt
COPY lib/* /usr/lib/

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER seluser

#==================
# Chrome webdriver
#==================
# How to get cpu arch dynamically: $(lscpu | grep Architecture | sed "s/^.*_//")
ENV CHROME_DRIVER_VERSION="2.29" \
    CHROME_DRIVER_BASE="chromedriver.storage.googleapis.com" \
    CPU_ARCH="64"
ENV CHROME_DRIVER_FILE="chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_URL="https://${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}"
# Gets latest chrome driver version. Or you can hard-code it, e.g. 2.15
# Layer size: small: 6.932 MB
RUN  wget -nv -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
  && unzip chromedriver_linux${CPU_ARCH}.zip \
  && rm chromedriver_linux${CPU_ARCH}.zip \
  && mv chromedriver \
        chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 chromedriver-$CHROME_DRIVER_VERSION \
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
    DEFAULT_SELENIUM_NODE_RC_CH_PORT="25552" \
    DEFAULT_SELENIUM_NODE_RC_FF_PORT="25553" \
    DEFAULT_VNC_PORT="25900" \
    DEFAULT_NOVNC_PORT="26080" \
    DEFAULT_SUPERVISOR_HTTP_PORT="19001"

# Commented for now; all these versions are still available at
#   https://github.com/elgalu/docker-selenium/releases/tag/2.47.1m
# USE_SELENIUM "2" / "3"
#   Selenium 2 or 3
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
# XTERM_STOP_SIGNAL
# SELENIUM_NODE_FIREFOX_STOP_SIGNAL
# SELENIUM_NODE_CHROME_STOP_SIGNAL
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
  PICK_ALL_RANDOM_PORTS="false" \
  RANDOM_PORT_FROM="23100" \
  RANDOM_PORT_TO="29999" \
  USER="seluser" \
  HOME="/home/seluser" \
  VNC_STORE_PWD_FILE="/home/seluser/.vnc/passwd" \
  BIN_UTILS="/usr/bin" \
  MEM_JAVA_PERCENT=80 \
  WAIT_FOREGROUND_RETRY="2s" \
  WAIT_VNC_FOREGROUND_RETRY="7s" \
  XVFB_STARTRETRIES=0 \
  XMANAGER_STARTRETRIES=0 \
  XMANAGER_STARTSECS=0 \
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
  SELENIUM_NODE_HOST="127.0.0.1" \
  SELENIUM_NODE_CH_PORT="${DEFAULT_SELENIUM_NODE_CH_PORT}" \
  SELENIUM_NODE_FF_PORT="${DEFAULT_SELENIUM_NODE_FF_PORT}" \
  SELENIUM_NODE_RC_CH_PORT="${DEFAULT_SELENIUM_NODE_RC_CH_PORT}" \
  SELENIUM_NODE_RC_FF_PORT="${DEFAULT_SELENIUM_NODE_RC_FF_PORT}" \
  SELENIUM_HUB_PARAMS="" \
  SELENIUM_NODE_PARAMS="" \
  SELENIUM_NODE_PROXY_PARAMS="" \
  CHROME_ARGS="--no-sandbox --disable-gpu --disable-infobars" \
  CHROME_ADDITIONAL_ARGS="" \
  CHROME_VERBOSELOGGING="true" \
  MAX_INSTANCES=1 \
  MAX_SESSIONS=1 \
  SEL_RELEASE_TIMEOUT_SECS=19000 \
  SEL_BROWSER_TIMEOUT_SECS=16000 \
  SELENIUM_NODE_REGISTER_CYCLE="1000" \
  SEL_CLEANUPCYCLE_MS=2000 \
  SEL_NODEPOLLING_MS=1500 \
  SEL_UNREGISTER_IF_STILL_DOWN_AFTER=2500 \
  no_proxy=localhost \
  HUB_ENV_no_proxy=localhost \
  XVFB_CLI_OPTS_TCP="-nolisten tcp -nolisten inet6" \
  XVFB_CLI_OPTS_BASE="-ac -r -cc 4 -accessx -xinerama" \
  XVFB_CLI_OPTS_EXT="+extension Composite -extension RANDR +extension GLX" \
  VNC_START="true" \
  VNC_PORT="${DEFAULT_VNC_PORT}" \
  VNC_FROM_PORT="" \
  VNC_TO_PORT="" \
  VNC_CLI_OPTS="-forever -shared" \
  VNC_PASSWORD=no \
  NOVNC_PORT="${DEFAULT_NOVNC_PORT}" \
  NOVNC="false" \
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
  LOG_LEVEL=info \
  DISABLE_ROLLBACK="false" \
  LOGFILE_MAXBYTES=10MB \
  LOGFILE_BACKUPS=5 \
  LOGS_DIR="/var/log/cont" \
  VIDEO="false" \
  GRID="true" \
  CHROME="true" \
  FIREFOX="true" \
  RC_CHROME="false" \
  RC_FIREFOX="false" \
  FFMPEG_FRAME_RATE=10 \
  FFMPEG_CODEC_ARGS="-crf 0 -preset ultrafast -qp 0" \
  FFMPEG_FINAL_CRF=0 \
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
  TAIL_LOG_LINES="15" \
  SHM_TRY_MOUNT_UNMOUNT="false" \
  SHM_SIZE="512M" \
  ETHERNET_DEVICE_NAME="eth0" \
  XMANAGER_STOP_SIGNAL="TERM" \
  XVFB_STOP_SIGNAL="TERM" \
  XTERM_STOP_SIGNAL="INT" \
  SELENIUM_NODE_FIREFOX_STOP_SIGNAL="TERM" \
  SELENIUM_NODE_CHROME_STOP_SIGNAL="TERM" \
  SELENIUM_HUB_STOP_SIGNAL="TERM" \
  VNC_STOP_SIGNAL="TERM" \
  NOVNC_STOP_SIGNAL="TERM" \
  VIDEO_REC_STOP_SIGNAL="INT" \
  DOCKER_SOCK="/var/run/docker.sock" \
  TEST_SLEEPS="0.5" \
  ZALENIUM="false" \
  SEND_ANONYMOUS_USAGE_INFO="true" \
  GA_TRACKING_ID="UA-18144954-9" \
  GA_ENDPOINT=https://www.google-analytics.com/collect \
  GA_API_VERSION="1" \
  DEBIAN_FRONTEND="" \
  DEBCONF_NONINTERACTIVE_SEEN=""

#================================
# Expose Container's Directories
#================================
# VOLUME ${LOGS_DIR}

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

#===================================
# Fix dirs (again) and final chores
#===================================
# The .X11-unix stuff is useful when using Xephyr
RUN mkdir -p /home/seluser/.vnc \
  && sudo touch /capabilities3.json \
  && sudo chown seluser:seluser /capabilities3.json \
  && generate_capabilities3_json > /capabilities3.json \
  && cp /capabilities3.json /home/seluser/capabilities3.json \
  && cp /capabilities3.json /home/seluser/capabilities3 \
  && cp /capabilities3.json /home/seluser/caps3.json \
  && cp /capabilities3.json /home/seluser/caps3 \
  && sudo cp /capabilities3.json /capabilities.json \
  && sudo cp /capabilities3.json /home/seluser/capabilities.json \
  && sudo cp /capabilities3.json /home/seluser/caps.json \
  && mkdir -p ${VIDEOS_DIR} \
  && sudo ln -s ${VIDEOS_DIR} /videos \
  && sudo chown seluser:seluser /videos \
  && sudo mkdir -p ${LOGS_DIR} \
  && sudo chown -R seluser:seluser ${LOGS_DIR} \
  && sudo mkdir -p ${RUN_DIR} \
  && sudo chown -R seluser:seluser ${RUN_DIR} \
  && sudo chown -R seluser:seluser /etc/supervisor \
  && sudo chown -R seluser:seluser /test \
  && sudo mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
  && sudo chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix \
  && echo ""

# Include current version
COPY VERSION /home/seluser/

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
