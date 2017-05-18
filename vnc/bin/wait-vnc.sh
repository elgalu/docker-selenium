#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "150"
  errnum=${2-133}
  exit $errnum
}

export VNC_PORT=$(cat VNC_PORT)
LOGSDTOUT="${VNC_TRYOUT_OUT_LOG}.${VNC_PORT}.log"
LOGERR="${VNC_TRYOUT_ERR_LOG}.${VNC_PORT}.log"

if [ "${VNC_START}" != "true" ]; then
  log "Won't start VNC service due to VNC_START env var false"
  exit 0
fi

# Note this active wait provokes below error, so ignore it
#  "webSocketsHandshake: unknown connection error"

if [ -z "${XE_DISP_NUM}" ]; then
  log "Waiting for VNC to be ready via process, nc or netstat on VNC_PORT=${VNC_PORT}..."

  #-----------------#
  log 'By_process?'
  #-----------------#
  while ! pidof x11vnc >/dev/null 2>&1; do
    echo -n '.'
    sleep 0.1
    if grep "ListenOnTCPPort: Address already in use" ${LOGERR}; then
      die "wait-vnc: By_process: ListenOnTCPPort: Address already in use"
    elif grep "could not obtain listening port" ${LOGERR}; then
      die "wait-vnc: By_process: could not obtain listening port"
    elif grep "bind: Permission denied" ${LOGERR}; then
      die "wait-vnc: By_process: bind: Permission denied"
    fi
  done
  log 'By_process:OK'

  #-----------------#
  log 'By_nc?'
  #-----------------#
  while ! nc -z localhost ${VNC_PORT}; do
    echo -n '.'
    sleep 0.1
    if grep "ListenOnTCPPort: Address already in use" ${LOGERR}; then
      die "wait-vnc: By_nc: ListenOnTCPPort: Address already in use"
    elif grep "could not obtain listening port" ${LOGERR}; then
      die "wait-vnc: By_nc: could not obtain listening port"
    elif grep "bind: Permission denied" ${LOGERR}; then
      die "wait-vnc: By_nc: bind: Permission denied"
    fi
  done
  log 'By_nc:OK'

  #-----------------#
  log 'By_log_stderr?'
  #-----------------#
  while ! grep "Got connection from client" ${LOGERR}; do
    echo -n '.'
    sleep 0.1
    if grep "ListenOnTCPPort: Address already in use" ${LOGERR}; then
      die "wait-vnc: By_log_stderr: ListenOnTCPPort: Address already in use"
    elif grep "could not obtain listening port" ${LOGERR}; then
      die "wait-vnc: By_log_stderr: could not obtain listening port"
    elif grep "bind: Permission denied" ${LOGERR}; then
      die "wait-vnc: By_log_stderr: bind: Permission denied"
    fi
    nc -z localhost ${VNC_PORT}
  done
  log 'By_log_stderr:OK'

  #-----------------#
  log 'By_log_stdout?'
  #-----------------#
  while ! grep "PORT=${VNC_PORT}" ${LOGSDTOUT}; do
    echo -n '.'
    sleep 0.1
  done
  log 'By_log_stdout:OK'
else
  log "Will not wait for VNC because env var XE_DISP_NUM is set."
fi

log "Done wait-vnc.sh"
