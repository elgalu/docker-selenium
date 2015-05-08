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
    bc \
  && rm -rf /var/lib/apt/lists/*

#=================
# Locale settings
#=================
# TODO: Allow to change instance language OS and Browser level
ENV LANGUAGE en_US.UTF-8
ENV LANG $LANGUAGE
RUN locale-gen $LANGUAGE \
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
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openjdk-7-jre-headless \
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

#====================================
# Java8 - OpenJDK latest from utopic
#====================================
# Workaround to use latest OpenJDK package which is only available for utopic
# https://github.com/zalando/docker-openjdk/blob/master/Dockerfile
# RUN curl -o /tmp/openjdk-8-#1.deb \
#   http://de.archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-{jre,jre-headless,jdk}_8u40~b09-1_amd64.deb
# # http://stackoverflow.com/questions/8477036/how-to-make-debian-package-install-dependencies
# RUN dpkg -i /tmp/openjdk-8-*.deb || apt-get -f --force-yes --yes install \
#   && dpkg -i /tmp/openjdk-8-*.deb \
#   && rm /tmp/openjdk-8-*.deb

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

#=========
# fluxbox
# A fast, lightweight and responsive window manager
#=========
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     fluxbox \
#   && rm -rf /var/lib/apt/lists/*

#=========
# Openbox
# A lightweight window manager using freedesktop standards
#=========
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openbox obconf menu \
  && mkdir -p /tmp/.X11-unix \
  && chmod 1777 /tmp/.X11-unix \
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
# NOT working!
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     lxde \
#   && mkdir -p /usr/share/backgrounds \
#   && rm -rf /var/lib/apt/lists/*

#=========
# GNOME ubuntu-desktop
# The fat and full featured windows manager
#=========
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     ubuntu-desktop \
#   && rm -rf /var/lib/apt/lists/*

#===============
# Google Chrome
#===============
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    google-chrome-stable \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/apt/sources.list.d/google-chrome.list

#=================
# Mozilla Firefox
#=================
# dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
RUN apt-get update -qqy \
  && apt-get -qqy install \
    firefox \
    dbus-x11 \
  && rm -rf /var/lib/apt/lists/*

#==============================================================================
# java blocks until kernel have enough entropy to generate the /dev/random seed
#==============================================================================
# SeleniumHQ/docker-selenium/issues/14
RUN apt-get update -qqy \
  && apt-get -qqy install \
    haveged \
  && service haveged start \
  && update-rc.d haveged defaults

#========================================
# Add normal user with passwordless sudo
#========================================
ENV NORMAL_USER application
ENV NORMAL_USER_UID 999
RUN useradd $NORMAL_USER --uid $NORMAL_USER_UID --shell /bin/bash --create-home \
  && usermod -a -G sudo $NORMAL_USER \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers

#==============
# VNC and Xvfb
#==============
RUN apt-get update -qqy \
  && apt-get -qqy install \
    x11vnc \
    xvfb \
    xorg \
  && rm -rf /var/lib/apt/lists/*

# USER $NORMAL_USER
# RUN  mkdir -p $HOME/.vnc

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
ENV DISPLAY :1
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
CMD ["entry.sh"]
