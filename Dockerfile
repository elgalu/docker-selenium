###################################################
# Selenium standalone docker for Chrome & Firefox #
###################################################
#== Ubuntu wily is 15.10.x, i.e. FROM ubuntu:15.10
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
# FROM ubuntu:wily-20150611
# ENV UBUNTU_FLAVOR wily

#== Ubuntu vivid is 15.04.x, i.e. FROM ubuntu:15.04
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
#                    http://cloud-images.ubuntu.com/releases/15.04/
FROM ubuntu:vivid-20150611
ENV UBUNTU_FLAVOR vivid

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
  && mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
  && chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix \
  && mkdir -p /var/log/sele \
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

#==========
# Selenium
#==========
USER ${NORMAL_USER}
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
RUN mkdir -p ${NORMAL_USER_HOME}/tmp &&  cd ${NORMAL_USER_HOME}/tmp \
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

# back to sudo
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

#=========
# Android
#=========
# TODO
# https://github.com/web-animations/web-animations-js/blob/master/.travis-setup.sh#L50
# https://github.com/elgalu/pastedirectory/blob/master/static/web_components/web-animations-js/tools/android/setup.sh

#==========================
# Mozilla Firefox - Latest
#==========================
# dbus-x11 is needed to avoid http://askubuntu.com/q/237893/134645
# RUN apt-get update -qqy \
#   && apt-get -qqy install \
#     firefox \
#     dbus-x11 \
#   && rm -rf /var/lib/apt/lists/*

#====================================
# Mozilla Firefox - Specific Version
#====================================
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
    python2.7 python-pip python2.7-dev python-openssl \
    libssl-dev libffi-dev dbus-x11 \
  && easy_install -U pip \
  && pip install --upgrade mozInstall==1.12 \
  && pip install --upgrade mozdownload==1.15 \
  && mkdir -p ${NORMAL_USER_HOME}/firefox-src \
  && cd ${NORMAL_USER_HOME}/firefox-src \
  && mozdownload --application=firefox --locale=$FF_LANG --retry-attempts=3 \
      --platform=linux64 --log-level=WARN --version=$FIREFOX_VERSION \
  && mozinstall --app=firefox \
      firefox-$FIREFOX_VERSION.$FF_LANG.linux64.tar.bz2 \
      --destination=${SEL_HOME} \
  && ln -s ${SEL_HOME}/firefox/firefox /usr/bin \
  && rm -rf /var/lib/apt/lists/*

#==========================================
# Chrome, Chromedriver, Firefox sudo steps
#==========================================
# RUN dpkg -i ${NORMAL_USER_HOME}/chrome-deb/google-chrome-stable_current_amd64.deb
RUN apt-get update -qqy \
  && apt-get -qqy install \
    gdebi \
  && gdebi --non-interactive \
      ${NORMAL_USER_HOME}/chrome-deb/google-chrome-stable_current_amd64.deb \
  && ln -s ${SEL_HOME}/chromedriver /usr/bin \
  && chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${SEL_HOME} \
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

#======================
# OpenSSH server (sshd)
#======================
# http://linux.die.net/man/5/sshd_config
# http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man5/sshd_config.5
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openssh-server \
  && mkdir -p /var/run/sshd \
  && chmod 744 /var/run/sshd \
  && echo "PidFile /tmp/run_sshd.pid" >> /etc/ssh/sshd_config \
  && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes"  >> /etc/ssh/sshd_config \
  && rm -rf /var/lib/apt/lists/*

#========================
# Guacamole dependencies
#========================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    gcc make \
    libcairo2-dev libpng12-dev libossp-uuid-dev \
    libssh2-1 libssh-dev libssh2-1-dev \
    libssl-dev libssl0.9.8 \
    libpango1.0-dev \
    autoconf libvncserver-dev \
  && rm -rf /var/lib/apt/lists/*

#===================
# DNS & hosts stuff
#===================
COPY ./etc/hosts /tmp/hosts

#==================
# User & ssh stuff
#==================
USER ${NORMAL_USER}
ENV USER ${NORMAL_USER}
ENV HOME ${NORMAL_USER_HOME}
RUN mkdir -p ~/.ssh \
  && touch ~/.ssh/authorized_keys \
  && chmod 700 ~/.ssh \
  && chmod 600 ~/.ssh/authorized_keys \
  && mkdir -p ${HOME}/.vnc \
  && sudo chown ${NORMAL_USER}:${NORMAL_GROUP} /var/log/sele
ENV VNC_STORE_PWD_FILE ${HOME}/.vnc/passwd

#======================
# Tomcat for Guacamole
#======================
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.23
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
# ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_HOME ${HOME}/tomcat
# WORKDIR ${CATALINA_HOME}
# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN mkdir -p ${CATALINA_HOME} \
  && cd ${CATALINA_HOME} \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys \
       05AB33110949707C93A279E3D3EFE6B686867BA6 \
       07E48665A34DCAFAE522E5E6266191C37C037D42 \
       47309207D818FFD8DCD3F83F1931D684307A10A5 \
       541FBE7D8F78B25E055DDEE13C370389288584E7 \
       61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
       79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
       9BA44C2621385CB966EBA586F72C284D731FABEE \
       A27677289986DB50844682F8ACB77FC2E86E29AC \
       A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
       DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
       F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
       F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23 \
  && wget --no-verbose "$TOMCAT_TGZ_URL" -O tomcat.tar.gz \
  && wget --no-verbose "$TOMCAT_TGZ_URL.asc" -O tomcat.tar.gz.asc \
  && gpg --verify tomcat.tar.gz.asc \
  && tar -xvf tomcat.tar.gz --strip-components=1 > /dev/null \
  && rm bin/*.bat \
  && rm tomcat.tar.gz*

#===================
# Guacamole web-app
#===================
# https://github.com/glyptodon/guacamole-server/releases
ENV GUACAMOLE_VERSION 0.9.7
ENV GUACAMOLE_WAR_SHA1 69b7566092cf13076bddc331772a5b31dba45fb5
ENV GUACAMOLE_HOME ${HOME}/guacamole
RUN mkdir -p ${GUACAMOLE_HOME}
# http://guac-dev.org/doc/gug/configuring-guacamole.html
COPY guacamole_home/* ${GUACAMOLE_HOME}/
# Disable Tomcat's manager application.
# e.g. to customize JVM's max heap size 256MB: -e JAVA_OPTS="-Xmx256m"
RUN cd ${CATALINA_HOME} && rm -rf webapps/* \
  && echo "${GUACAMOLE_WAR_SHA1}  ROOT.war" > webapps/ROOT.war.sha1 \
  && wget --no-verbose -O webapps/ROOT.war "http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-${GUACAMOLE_VERSION}.war/download" \
  && cd webapps && sha1sum -c --quiet ROOT.war.sha1 && cd .. \
  && echo "export CATALINA_OPTS=\"${JAVA_OPTS}\"" >> bin/setenv.sh
#========================
# Guacamole server guacd
#========================
ENV GUACAMOLE_SERVER_SHA1 43883eb86d70b68da723a2d57d50d866a8af5f16
RUN cd /tmp \
  && echo ${GUACAMOLE_SERVER_SHA1}  guacamole-server.tar.gz > guacamole-server.tar.gz.sha1 \
  && wget --no-verbose -O guacamole-server.tar.gz "http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-${GUACAMOLE_VERSION}.tar.gz/download" \
  && sha1sum -c --quiet guacamole-server.tar.gz.sha1 \
  && tar xzf guacamole-server.tar.gz \
  && rm guacamole-server.tar.gz* \
  && cd guacamole-server-${GUACAMOLE_VERSION} \
  && ./configure \
  && make \
  && sudo make install \
  && sudo ldconfig

#========================================================================
# Some configuration options that can be customized at container runtime
#========================================================================
ENV BIN_UTILS /bin-utils
ENV PATH ${PATH}:${BIN_UTILS}:${CATALINA_HOME}/bin
# Security requirements might prevent using sudo in the running container
ENV SUDO_ALLOWED true
ENV WITH_GUACAMOLE false
ENV WITH_SSH true
# JVM uses only 1/4 of system memory by default
ENV MEM_JAVA_PERCENT 80
ENV RETRY_START_SLEEP_SECS 0.1
ENV MAX_WAIT_RETRY_ATTEMPTS 9
ENV SCREEN_WIDTH 1900
ENV SCREEN_HEIGHT 1480
ENV SCREEN_MAIN_DEPTH 24
ENV SCREEN_DEPTH ${SCREEN_MAIN_DEPTH}+32
ENV DISP_N 10
ENV DISPLAY :${DISP_N}
ENV XEPHYR_DISPLAY :${DISP_N}
ENV SCREEN_NUM 0
# Even though you can change them below, don't worry too much about container
# internal ports since you can map them to the host via `docker run -p`
ENV SELENIUM_PORT 4444
ENV VNC_PORT 5900
# You can set the VNC password or leave null so a random password is generated:
# ENV VNC_PASSWORD topsecret
ENV SSHD_PORT 2222
ENV GUACAMOLE_SERVER_PORT 4822
# All tomcat ports can be customized if necessary
ENV TOMCAT_PORT 8484
ENV TOMCAT_SHUTDOWN_PORT 8485
ENV TOMCAT_AJP_PORT 8489
ENV TOMCAT_REDIRECT_PORT 8483
# Logs
ENV XVFB_LOG "/var/log/sele/Xvfb_headless.log"
ENV XMANAGER_LOG "/var/log/sele/xmanager.log"
ENV VNC_LOG "/var/log/sele/x11vnc_forever.log"
ENV SELENIUM_LOG "/var/log/sele/selenium-server-standalone.log"
ENV CATALINA_LOG "/var/log/sele/tomcat-server.log"
ENV GUACD_LOG "/var/log/sele/guacd-server.log"
#===============================
# Run docker from inside docker
# Usage: docker run -v /var/run/docker.sock:/var/run/docker.sock
#                   -v $(which docker):$(which docker)
ENV DOCKER_SOCK "/var/run/docker.sock"

#================================
# Expose Container's Directories
#================================
VOLUME /var/log

# Only expose ssh port given the other services are not secured
# forcing the user to open ssh tunnels or use docker run -p ports...
# EXPOSE ${SELENIUM_PORT} ${VNC_PORT} ${SSHD_PORT} ${TOMCAT_PORT}
EXPOSE ${SSHD_PORT}

#================
# Binary scripts
#================
ADD bin $BIN_UTILS

#=====================================================
# Meta JSON file to hold commit info of current build
#=====================================================
COPY scm-source.json /
# Ensure the file is up-to-date else you should update it by running
#  ./host-scripts/gen-scm-source.sh
# on the host
RUN find /scm-source.json -mmin +1 -exec echo "good enough" \;

#===================
# CMD or ENTRYPOINT
#===================
# Start a selenium standalone server for Chrome and/or Firefox
CMD ["entry.sh"]
