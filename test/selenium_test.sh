#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# Required params
[ -z "${1}" ] && die "Need first argument to be the browser name"
browser_name=${1}

echo "----------------------------------------"
echo "- Self test on ${browser_name}"
echo "----------------------------------------"

if [ "${VIDEO}" = "true" ]; then
  stop-video >/dev/null 2>&1 || true
  rm -f /test/videos/${browser_name}/*
  start-video
fi

# Install the correct version of selenium binding
# How to find old versions?
#  https://pypi.python.org/simple/selenium/
mkdir -p ${HOME}/.local
pip install --user -r /test/requirements-sele-${USE_SELENIUM}.txt
# pip install --install-option="--prefix=${HOME}/.local" -r /test/requirements-sele-${USE_SELENIUM}.txt
#  export PATH=$PATH:~/.local/bin
#  echo "PATH=\$PATH:~/.local/bin" >> ~/.bashrc

python_test ${browser_name}

if [ "${VIDEO}" = "true" ]; then
  stop-video
  mkdir -p /test/videos/${browser_name}
  mv /videos/* /test/videos/${browser_name}/

  for f in /test/videos/${browser_name}/*; do
    # Validate the videos are correctly encoded
    if MP4Box -isma -inter \
           ${MP4_INTERLEAVES_MEDIA_DATA_CHUNKS_SECS} ${f} 2>&1 | \
           grep "Error opening"; then
      die "MP4Box got errors meaning the mp4 video file is corrupted!"
    fi
  done
fi

# How to archive console.png and videos from the docker host:
#  docker cp grid:/test/console.png .
#  docker cp grid:/test/videos/chrome/test.mp4 chrome.mp4
#  docker cp grid:/test/videos/firefox/test.mp4 firefox.mp4
