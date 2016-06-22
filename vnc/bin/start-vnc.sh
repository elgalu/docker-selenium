#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Wait for this process dependencies
timeout --foreground ${WAIT_TIMEOUT} wait-xvfb.sh
timeout --foreground ${WAIT_TIMEOUT} wait-xmanager.sh

# Set VNC password to a random one if not defined yet
if [ -z "${VNC_PASSWORD}" ]; then
  random_password=$(genpassword.sh)
  export VNC_PASSWORD=${VNC_PASSWORD-$random_password}
  echo "a VNC password was generated for you: $VNC_PASSWORD"
fi

# For now is not possible to VNC at the same time we use Xephyr
# Error: X11 MIT Shared Memory Attach failed:
#  Is your DISPLAY=:12 on a remote machine?
#  Suggestion, use: x11vnc -display :0 ... for local display :0
#  X Error of failed request:  BadAccess (attempt to access private resource denied)
#  Major opcode of failed request:  130 (MIT-SHM)
if [ -z "${XE_DISP_NUM}" ]; then
  # Generate the password file
  x11vnc -storepasswd ${VNC_PASSWORD} ${VNC_STORE_PWD_FILE}

  # Start VNC server to enable viewing what's going on but not mandatory
  # -rfbport  port TCP port for RFB protocol
  # -rfbauth  passwd-file, use authentication on RFB protocol
  # -viewonly all VNC clients can only watch (default off).
  # -forever  keep listening for more connections rather than exiting as soon
  #           as the first client(s) disconnect.
  # -usepw    first look for ~/.vnc/passwd then -rfbauth or prompt for pwd
  # -shared   more than one viewer can connect at the same time (default off)
  # -noadd_keysyms add the Keysym to X srv keybd mapping on an unused key.
  #           Default: -add_keysyms
  # -nopw     disable the warn msg when running without some sort of password
  # -xkb      when in modtweak mode, use the XKEYBOARD extension
  # -clear_mods used to clear the state if the display was accidentally left
  #           with any pressed down.
  # -clear_keys As -clear_mods, except try to release ANY pressed key
  # -clear_all  As -clear_keys, except try to release any CapsLock, NumLock ...
  #
  # Redirecting to >/dev/null until https://github.com/LibVNC/x11vnc/issues/14
  x11vnc ${VNC_CLI_OPTS} -rfbport ${VNC_PORT} -rfbportv6 ${VNC_PORT} -display ${DISPLAY} \
      -rfbauth ${VNC_STORE_PWD_FILE}

  # Note to double pipe output and keep this process logs add at the end:
  #  2>&1 | tee $VNC_LOG
  # But is no longer required because individual logs are maintained by
  # supervisord right now.
fi
