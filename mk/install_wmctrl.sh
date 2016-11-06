#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
# set -x: print each command right before it is executed
# set -u: treat unset variables as an error and exit immediately
set -e
set -u

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

if [ "$(uname)" = 'Darwin' ]; then
  die "Sorry: moving windows with wmctrl in OSX is not properly supported."
  #-----------------------------------------------------------------
  echo "Will install wmctrl for OSX"
  set -x
  brew cask install xquartz
  # https://github.com/Homebrew/homebrew-x11/blob/master/wmctrl.rb
  brew install homebrew/x11/wmctrl
else
  echo "Will install wmctrl for Linux"
  INST_CMD="sudo apt-get -qyy install wmctrl"
  echo "About to: '${INST_CMD}'"
  if ! eval "${INST_CMD}"; then
    echoerr "Please install wmctrl manually with sudo or open this deb file to install it:"
    echoerr "${INST_CMD}"
  fi
  # Uninstall with:
  #  sudo apt-get -qyy remove wmctrl
fi
