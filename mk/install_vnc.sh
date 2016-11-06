#!/usr/bin/env bash

# set -x: print each command right before it is executed
# set -e: exit asap if a command exits with a non-zero status
set -e
# set -u: treat unset variables as an error and exit immediately
set -u

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# http://stackoverflow.com/a/8996924/511069
md5_sum() {
  if builtin command -v md5 > /dev/null; then
    echo "md5"
  elif builtin command -v md5sum > /dev/null ; then
    echo "md5sum"
  else
    die "Neither md5 nor md5sum were found in the PATH"
  fi
  return 0
}

cd mk
if [ "$(uname)" = 'Darwin' ]; then
  echo "Will install '${VNC_CLIENT_NAME}' for OSX"
  echo "${VNC_MD5SUM_OSX}  ${VNC_FILE_OSX}" > vnc_osx.md5
  if [ ! -f "${VNC_FILE_OSX}" ]; then
    wget -nv "${VNC_DOWNLOAD_BASE_URL}/${VNC_FILE_OSX}"
  fi
  $(md5_sum) -r vnc_osx.md5
  # https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md#other-ways-to-specify-a-cask
  brew cask install ./vnc_cask.rb --force
else
  echo "Will install '${VNC_CLIENT_NAME}' for Linux"
  echo "${VNC_MD5SUM_LINUX}  ${VNC_FILE_LINUX}" > vnc_linux.md5
  if [ ! -f "${VNC_FILE_LINUX}" ]; then
    wget -nv "${VNC_DOWNLOAD_BASE_URL}/${VNC_FILE_LINUX}"
  fi
  $(md5_sum) --check vnc_linux.md5
  tar xzf ${VNC_FILE_LINUX}
  rm -f "VNC-Server-${VNC_CLIENT_VERSION}-Linux-x64.deb"
  INST_CMD="sudo dpkg -i VNC-Viewer-${VNC_CLIENT_VERSION}-Linux-x64.deb"
  echo "About to: '${INST_CMD}'"
  if ! eval "${INST_CMD}"; then
    echoerr "Please install manually with sudo or open this deb file to install it:"
    echoerr "${INST_CMD}"
  fi
  # Uninstall with:
  #  sudo apt-get -qyy remove realvnc-vnc-viewer
fi
cd ..
