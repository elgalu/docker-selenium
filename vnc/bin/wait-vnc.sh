#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

export VNC_PORT=$(cat VNC_PORT)
LOGSDTOUT="${VNC_TRYOUT_OUT_LOG}.${VNC_PORT}.log"
LOGERR="${VNC_TRYOUT_ERR_LOG}.${VNC_PORT}.log"

fail_fast() {
  # killall x11vnc || true
  exit 3
}

if [ "${VNC_START}" != "true" ]; then
  echo "Won't start VNC service due to VNC_START env var false"
  exit 0
fi

# Note this active wait provokes below error, so ignore it
#  "webSocketsHandshake: unknown connection error"

if [ -z "${XE_DISP_NUM}" ]; then
  echo "Waiting for VNC to be ready via process, nc or netstat on VNC_PORT=${VNC_PORT}..."
  echo -n 'By_process.'
  while ! pidof x11vnc >/dev/null 2>&1; do
    echo -n '.'
    sleep 0.1
    if grep "ListenOnTCPPort: Address already in use" ${LOGERR}; then
      fail_fast
    elif grep "could not obtain listening port" ${LOGERR}; then
      fail_fast
    elif grep "bind: Permission denied" ${LOGERR}; then
      fail_fast
    fi
  done; echo -n 'OK...'
  echo -n 'By_nc.'
  while ! nc -z localhost ${VNC_PORT}; do
    echo -n '.'
    sleep 0.1
    if grep "ListenOnTCPPort: Address already in use" ${LOGERR}; then
      fail_fast
    elif grep "could not obtain listening port" ${LOGERR}; then
      fail_fast
    elif grep "bind: Permission denied" ${LOGERR}; then
      fail_fast
    fi
  done; echo -n 'OK...'
  # echo -n 'By_netstat.'
  # while ! netstat -an | \
  #         grep "LISTEN" | \
  #         grep ":${VNC_PORT} " >/dev/null 2>&1; do
  #   echo -n '.'
  #   sleep 0.1
  # done; echo -n 'OK...'
  echo -n 'By_log_stderr.'
  while ! grep "Got connection from client" ${LOGERR}; do
    echo -n '.'
    sleep 0.1
    if grep "ListenOnTCPPort: Address already in use" ${LOGERR}; then
      fail_fast
    elif grep "could not obtain listening port" ${LOGERR}; then
      fail_fast
    elif grep "bind: Permission denied" ${LOGERR}; then
      fail_fast
    fi
    nc -z localhost ${VNC_PORT}
  done; echo -n 'OK...'
  echo -n 'By_log_stdout.'
  while ! grep "PORT=${VNC_PORT}" ${LOGSDTOUT}; do
    echo -n '.'
    sleep 0.1
  done; echo -n 'OK...'
else
  echo "Will not wait for VNC because env var XE_DISP_NUM is set."
fi

echo "Done wait-vnc.sh"
