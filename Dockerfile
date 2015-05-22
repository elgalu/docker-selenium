################
# Headless e2e #
################
#== Ubuntu vivid is 15.04.x, i.e. FROM ubuntu:15.04
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
FROM ubuntu:vivid-20150427
RUN  echo "deb http://archive.ubuntu.com/ubuntu vivid main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu vivid-updates main universe\n" >> /etc/apt/sources.list

#== Ubuntu Trusty is 14.04.x, i.e. FROM ubuntu:14.04
#== Could also use ubuntu:latest but for the sake I replicating an precise env...
# FROM ubuntu:14.04.2
# RUN  echo "deb http://archive.ubuntu.com/ubuntu trusty main universe\n" > /etc/apt/sources.list \
#   && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe\n" >> /etc/apt/sources.list

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
RUN apt-get update -qqy \
  && apt-get -qqy install \
    apt-utils \
    sudo \
    net-tools \
    netcat-openbsd \
    iputils-ping \
    unzip \
    wget \
    curl \
    pwgen \
    bc \
  && mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
  && chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix \
  && rm -rf /var/lib/apt/lists/*

#==============================
# Locale and encoding settings
#==============================
# TODO: Allow to change instance language OS and Browser level
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
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     openjdk-7-jre-headless \
#   && rm -rf /var/lib/apt/lists/*

#==============================
# Java8 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openjdk-8-jre-headless \
  && rm -rf /var/lib/apt/lists/*

#==================
# Java8 - Oracle
#==================
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
#   && rm -rf /var/lib/apt/lists/*

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

#==========
# Selenium
#==========
ENV SELENIUM_MAJOR_MINOR_VERSION 2.45
ENV SELENIUM_PATCH_LEVEL_VERSION 0
RUN  mkdir -p /opt/selenium \
  && wget --no-verbose http://selenium-release.storage.googleapis.com/$SELENIUM_MAJOR_MINOR_VERSION/selenium-server-standalone-$SELENIUM_MAJOR_MINOR_VERSION.$SELENIUM_PATCH_LEVEL_VERSION.jar -O /opt/selenium/selenium-server-standalone.jar

#==================
# Chrome webdriver
#==================
# How to get cpu arch dynamically: $(lscpu | grep Architecture | sed "s/^.*_//")
ENV CPU_ARCH 64
ENV CHROME_DRIVER_FILE "chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_BASE chromedriver.storage.googleapis.com
# Gets latest chrome driver version. Or you can hard-code it, e.g. 2.15
RUN cd /tmp \
  # && CHROME_DRIVER_VERSION=2.15 \
  && CHROME_DRIVER_VERSION=$(curl 'http://chromedriver.storage.googleapis.com/LATEST_RELEASE' 2> /dev/null) \
  && CHROME_DRIVER_URL="${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}" \
  && wget --no-verbose -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
  && cd /opt/selenium \
  && rm -rf chromedriver \
  && unzip /tmp/chromedriver_linux${CPU_ARCH}.zip \
  && rm /tmp/chromedriver_linux${CPU_ARCH}.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

#========================================
# Add normal user with passwordless sudo
#========================================
ENV NORMAL_USER application
ENV NORMAL_USER_UID 999
RUN useradd ${NORMAL_USER} --uid ${NORMAL_USER_UID} --shell /bin/bash --create-home \
  && usermod -a -G sudo ${NORMAL_USER} \
  && gpasswd -a ${NORMAL_USER} video \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers

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
# NOT working!
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

#=========
# GNOME ubuntu-desktop
# The fat and full featured windows manager
#=========
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     ubuntu-desktop \
#   && rm -rf /var/lib/apt/lists/*

#==========================
# Google Chrome - Latest
#==========================
# If you have issue "Failed to move to new PID namespace" on OpenVZ (AWS ECS)
#  https://bugs.launchpad.net/chromium-browser/+bug/577919
# - try to pass chrome switch --no-sandbox see: http://peter.sh/experiments/chromium-command-line-switches/#no-sandbox
# - try /dev/shm? see: https://github.com/travis-ci/travis-ci/issues/938#issuecomment-16345102
# - try xserver-xephyr see: https://github.com/enkidulan/hangout_api/blob/master/.travis.yml#L5
# - try /opt/google/chrome/chrome-sandbox see: https://github.com/web-animations/web-animations-js/blob/master/.travis-setup.sh#L66
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    google-chrome-stable \
  && sudo chmod 1777 /dev/shm \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/apt/sources.list.d/google-chrome.list

#=========
# Android
#=========
# TODO
# https://github.com/web-animations/web-animations-js/blob/master/.travis-setup.sh#L50

#==========================
# Mozilla Firefox - Latest
#==========================
# dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
RUN apt-get update -qqy \
  && apt-get -qqy install \
    firefox \
    dbus-x11 \
  && rm -rf /var/lib/apt/lists/*

#====================================
# Mozilla Firefox - Specific Version
#====================================
# # dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
# # FIREFOX_VERSION can be latest // 38.0 // 37.0 // 37.0.1 // 37.0.2 and so on
# ENV FIREFOX_VERSION latest
# # FF_LANG can be either en-US // de // fr and so on
# ENV FF_LANG "en-US"
# # RUN apt-get update -qqy \
# #   && apt-get -qqy install \
# #     python2.7 python-pip python2.7-dev python-openssl libssl-dev libffi-dev \
# #     dbus-x11 \
# #   && easy_install -U pip \
# #   && pip install --upgrade mozdownload mozInstall \
# #   && mozdownload --application=firefox --locale=$FF_LANG --retry-attempts=3 \
# #                  --platform=linux64  --log-level=WARN --version=$FIREFOX_VERSION \
# #   && mozinstall --app=firefox firefox-$FIREFOX_VERSION.$FF_LANG.linux64.tar.bz2 --destination=/opt/selenium \
# #   && ln -s /opt/selenium/firefox/firefox /usr/bin \
# #   && rm -rf /var/lib/apt/lists/*

#==============================================================================
# java blocks until kernel have enough entropy to generate the /dev/random seed
#==============================================================================
# SeleniumHQ/docker-selenium/issues/14
RUN apt-get update -qqy \
  && apt-get -qqy install \
    haveged \
  && service haveged start \
  && update-rc.d haveged defaults

#==============
# VNC and Xvfb
#==============
# xvfb: Xvfb or X virtual framebuffer is a display server
#  + implements the X11 display server protocol
#  + performs all graphical operations in memory
#
# Xdummy: Is like Xvfb but uses an LD_PRELOAD hack to run a stock X server
#  - uses a "dummy" video driver
#  - with Xpra allows to use extensions like Randr, Composite, Damage
RUN apt-get update -qqy \
  && apt-get -qqy install \
    x11vnc \
    xvfb \
    xorg \
  && rm -rf /var/lib/apt/lists/*

#===================
# DNS & hosts stuff
#===================
COPY ./etc/hosts /tmp/hosts

#================
# Binary scripts
#================
ENV BIN_UTILS /bin-utils
ADD bin $BIN_UTILS

#========================================================================
# Some configuration options that can be customized at container runtime
#========================================================================
ENV PATH ${PATH}:${BIN_UTILS}
# Using sudo on your dockerized app is not supported by stups-senza tools
# so allow this to be deactivated
ENV USE_SUDO_TO_FIX_ETC_HOSTS true
# JVM uses only 1/4 of system memory by default
ENV MEM_JAVA_PERCENT 80
ENV RETRY_START_SLEEP_SECS 0.1
ENV MAX_WAIT_RETRY_ATTEMPTS 8
ENV SCREEN_WIDTH 1900
ENV SCREEN_HEIGHT 1480
ENV SCREEN_DEPTH 24
ENV DISPLAY_NUM 1
ENV DISPLAY :$DISPLAY_NUM
ENV SCREEN_NUM 0
# Even though you can change them below, don't worry too much about container
# internal ports since you can map them to the host via `docker run -p`
ENV SELENIUM_PORT 4444
ENV VNC_PORT 5900
# You can set the VNC password or leave null so a random password is generated:
# ENV VNC_PASSWORD topsecret

#================================
# Expose Container's Directories
#================================
VOLUME /var/log

#================================
# Expose Container's Ports
#================================
EXPOSE 4444 5900

#===================
# CMD or ENTRYPOINT
#===================
# Start a selenium standalone server for Chrome and/or Firefox
USER ${NORMAL_USER}
ENV USER ${NORMAL_USER}
CMD ["entry.sh"]
