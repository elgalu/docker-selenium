# docker-selenium tags are pointer based, for instance:
#   latest now points to 3 that points to 3.5 that points to 3.5.0 that points to 3.5.0-p1
#   3.3 points to 3.3.1 that points to 3.3.1-p27
#   and so on
FROM elgalu/selenium:3.5

USER root

# In order to install an older chrome we need to:
# 1. identify the git tag of the release that has that .deb version file
#    e.g. 3.3.1-p22
# 2. grab the .deb download url
#    e.g. https://github.com/elgalu/....../google-chrome-stable_60.0.3112.101_amd64.deb
RUN mkdir -p /home/seluser/chrome-deb \
  && cd /home/seluser/chrome-deb \
  && wget -O "older_chrome.deb" -nv \
     "https://github.com/elgalu/docker-selenium/releases/download/3.3.1-p22/google-chrome-stable_60.0.3112.101_amd64.deb"

# Installing the deb file will upgrade replace existing Chrome with the one we need
RUN cd /home/seluser/chrome-deb \
  && dpkg -i "older_chrome.deb" \
  && rm "older_chrome.deb" \
  && apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -qyy clean \
  && export CH_STABLE_VER=$(/usr/bin/google-chrome-stable --version | grep -iEo "${GREP_ONLY_NUMS_VER}") \
  && echo "${CH_STABLE_VER}"

# Restore default user
USER seluser
