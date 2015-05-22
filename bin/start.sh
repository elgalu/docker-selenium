#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
# set -e

# Echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&2;
}

# Print error and exit
die () {
  local error_msg=$1
  local opt_exit_code=$2
  local opt_perform_shutdown=$3

  echoerr "ERROR: $error_msg"
  if [ "$opt_perform_shutdown" = "true" ]; then
    shutdown
  fi
  # if $opt_exit_code is defined AND NOT EMPTY, use
  # $opt_exit_code; otherwise, set to "1"
  local errnum=${opt_exit_code-1}
  exit $errnum
}

# Kill process gracefully or force it if is resilient
kill_pid_gracefully() {
  local the_pid=$1
  local pdesc=$2
  [ -z "$the_pid" ] && die "Need to set PID as 1st param for kill_pid_gracefully()" 4
  [ -z "$pdesc" ]   && die "Need to set Description as 2nd param for kill_pid_gracefully()" 5
  if [ "$the_pid" -gt "0" ] && [ -d /proc/$the_pid ]; then
    echo "Shutting down $pdesc PID: $the_pid.."
	  if [ "$USE_SUDO_TO_FIX_ETC_HOSTS" = true ]; then
	    sudo kill -s SIGTERM $the_pid
	  else
	    kill -s SIGTERM $the_pid
	  fi
    local wait_msg="waiting for $pdesc PID: $the_pid to die..."
    timeout 1 bash -c "while [ -d /proc/$the_pid ]; do sleep 0.1 && echo $wait_msg; done"
    if [ -d /proc/$the_pid ]; then
      echo "$pdesc PID: $the_pid still running, forcing with kill -SIGKILL..."
      if [ "$USE_SUDO_TO_FIX_ETC_HOSTS" = true ]; then
        sudo kill -SIGKILL $the_pid
      else
        kill -SIGKILL $the_pid
      fi
      # Better not to wait since docker will terminate the cleanup anyway
      # echo "waiting for $pdesc PID: $the_pid to finally terminate.."
      # wait $the_pid
    fi
  fi
}

# Retries a command a with backoff.
#
# The retry count is given by $MAX_WAIT_RETRY_ATTEMPTS,
# the initial backoff timeout sleep is given by
# Timeout in seconds is $RETRY_START_SLEEP_SECS
#
# Successive backoffs double the timeout.
#
# Beware of set -e killing your whole script!
function with_backoff_and_slient {
  local max_attempts=$MAX_WAIT_RETRY_ATTEMPTS
  local timeout=$RETRY_START_SLEEP_SECS
  local attempt=0
  local exitCode=0
  local cmd_desc=$CMD_DESC_PARAM
  local cmd=$CMD_PARAM
  local log_file=$LOG_FILE_PARAM
  [ -z "$log_file" ] && log_file=/dev/null

  # while [[ $attempt < $max_attempts ]]; do
  while [ "$attempt" -lt "$max_attempts" ]; do
    # Silent but keep the log for later reporting
    $cmd >$log_file 2>&1
    exitCode=$?

    if [[ $exitCode == 0 ]]; then
      break
    fi

    echo "-- Retrying/waiting for $cmd_desc in $timeout seconds..."
    sleep $timeout
    attempt=$(( attempt + 1 ))
    # timeout=$(( timeout * 2 ))
    timeout=$(echo "scale=2; $timeout*2" | bc)
  done

  if [[ $exitCode != 0 ]]; then
    echo "$cmd_desc failed me for the last time! ($cmd)" 1>&2
    [ -f "$log_file" ] && cat $log_file
    exit $exitCode
  fi

  return $exitCode
}

# Generate a random password between 5 and 15 characters long
# returns the value as echo to stdout due to bash limitation
# that only integers are allowed: http://stackoverflow.com/a/3236940/511069
function genpassword {
  # Switched to a better password generator `pwgen` but let's keep the old fn here
  # echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%&*_+~' | fold -w $(shuf -i 5-15 -n 1) | head -n 1)
  # pwget generates random password; pwgen [ OPTIONS ] [ pw_length ] [ num_pw ]
  pwgen -c -n -1 $(echo $[ 7 + $[ RANDOM % 17 ]]) 1
}

# Exit all child processes properly
function shutdown {
  echo "Trapped SIGTERM or SIGINT so shutting down gracefully..."
  kill_pid_gracefully $HANDY_TERM_PID "extra debugging terminal"
  kill_pid_gracefully $SELENIUM_PID "Selenium"
  kill_pid_gracefully $VNC_SERVER_PID "VNC server"
  kill_pid_gracefully $XVFB_PID "Xvfb"
  kill_pid_gracefully $XSESSION_PID "X server session"
  kill_pid_gracefully $SSHD_PID "OpenSSH server"
  echo "Shutdown complete."
}

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
export CONTAINER_IP=$(ip addr show dev eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
export XVFB_LOG="/tmp/Xvfb_headless.log"
export XMANAGER_LOG="/tmp/xmanager.log"
export VNC_LOG="/tmp/x11vnc_forever.log"
export SELENIUM_LOG="/tmp/selenium-server-standalone.log"
# more active waiti (poll) logs
export XVFB_POLL_LOG="/tmp/xvfb_poll_start.log"
export VNC_POLL_LOG="/tmp/vnc_poll_start.log"
export SELENIUM_POLL_LOG="/tmp/selenium_poll_start.log"

# As of docker >= 1.2.0 is possible to append our stuff directly into /etc/hosts
if [ "$USE_SUDO_TO_FIX_ETC_HOSTS" = true ]; then
  sudo -E sh -c 'cat /tmp/hosts >> /etc/hosts'
  sudo -E sh -c 'echo "$DOCKER_HOST_IP  docker.host"        >> /etc/hosts'
  sudo -E sh -c 'echo "$CONTAINER_IP    docker.guest"       >> /etc/hosts'
  sudo -E sh -c 'echo "$DOCKER_HOST_IP  docker.host.dev"    >> /etc/hosts'
  sudo -E sh -c 'echo "$DOCKER_HOST_IP  d.host.loc.dev"     >> /etc/hosts'
  sudo -E sh -c 'echo "$CONTAINER_IP    docker.guest.dev"   >> /etc/hosts'
  sudo -E sh -c 'echo "$DOCKER_HOST_IP  host.docker.local"  >> /etc/hosts'
  sudo -E sh -c 'echo "$CONTAINER_IP    guest.docker.local" >> /etc/hosts'
  sudo -E sh -c 'echo "$CONTAINER_IP    d.guest.loc.dev"    >> /etc/hosts'
  sudo -E sh -c 'echo "$DOCKER_HOST_IP  host.docker"        >> /etc/hosts'
  sudo -E sh -c 'echo "$CONTAINER_IP    guest.docker"       >> /etc/hosts'
fi

# Start the X server that can run on machines with no display
# hardware and no physical input devices
Xvfb $DISPLAY -screen $SCREEN_NUM $GEOMETRY \
    -ac -r -cc 4 -accessx -xinerama -extension RANDR 2>&1 | tee $XVFB_LOG &
XVFB_PID=$!
# Active wait for $DISPLAY to be ready: https://goo.gl/mGttpb
# for i in $(seq 1 $MAX_WAIT_RETRY_ATTEMPTS); do
#   xdpyinfo -display $DISPLAY >/dev/null 2>&1
#   [ $? -eq 0 ] && break
#   echo Waiting Xvfb to start up...
#   sleep 0.1
# done
# if [ "$i" -ge "$MAX_WAIT_RETRY_ATTEMPTS" ]; then
#   die "Failed to start Xvfb!" 1 true
# fi
CMD_DESC_PARAM="Xvfb Server"
CMD_PARAM="xdpyinfo -display $DISPLAY"
LOG_FILE_PARAM="$XVFB_POLL_LOG"
with_backoff_and_slient

# Same for all X servers
# TODO fix lightdm Xauthority issue:
#  xauth: timeout in locking authority file /var/lib/lightdm/.Xauthority
# startx -- $DISPLAY 2>&1 | tee $XMANAGER_LOG &
# XSESSION_PID=$!

# Alternative 1.
#  Openbox is a lightweight window manager using freedesktop standards
openbox-session 2>&1 | tee $XMANAGER_LOG &
XSESSION_PID=$!

# Alternative 2.
#  Fluxbox is a fast, lightweight and responsive window manager
# fluxbox -display $DISPLAY 2>&1 | tee $XMANAGER_LOG &

# Alternative 3.
#  GNOME Shell provides core interface functions like switching windows,
#  launching applications or see your notifications
# gnome-shell -display $DISPLAY 2>&1 | tee $XMANAGER_LOG &

# Alternative 4.
#  GNOME ubuntu desktop; The fat and full featured windows manager
# /etc/X11/Xsession &
# gnome-session &

# Alternative 5.
#  Not working: LXDE is a Lightweight X11 Desktop Environment
# lxde -display $DISPLAY 2>&1 | tee $XMANAGER_LOG &

# Alternative 6.
#  lightdm is a fat and full featured windows manager
# lightdm-session 2>&1 | tee $XMANAGER_LOG &
# XSESSION_PID=$!

# Start a GUI xTerm to help debugging when VNC into the container
x-terminal-emulator -geometry 120x40+10+10 -ls -title "x-terminal-emulator" &
HANDY_TERM_PID=$!

# Start a GUI xTerm to easily debug the headless instance
# Note sometimes chrome fails with:
#  session deleted because of page crash from tab crashed
#  "session deleted because of page crash" "from tab crashed"
#  reported as tmux related:
#    https://github.com/angular/protractor/issues/731
#  reported to be fixed with --disable-impl-side-painting:
#    https://code.google.com/p/chromedriver/issues/detail?id=732#c19
#    Protractor config example:
#      capabilities: {
#          browserName: 'chrome',
#          chromeOptions: {
#              args: ['--disable-impl-side-painting'],
#          },
#      },
# Example of using xvfb-run to just run selenium:
#   xvfb-run --server-num=$DISPLAY_NUM --server-args="-screen $SCREEN_NUM $GEOMETRY" \
#       "$BIN_UTILS/local-sel-headless.sh"  &
# Example of sending selenium output to a log instead of stdout
#   $BIN_UTILS/local-sel-headless.sh > $SELENIUM_LOG  &
# Current preferred way: to send selenium output to docker logs stream
$BIN_UTILS/local-sel-headless.sh 2>&1 | tee $SELENIUM_LOG &
SELENIUM_PID=$!
# You can also start it within an xterm but then the logs won't be at docker logs
# x-terminal-emulator -geometry 160x40-10-10 -ls -title "local-sel-headless" \
# -e "$BIN_UTILS/local-sel-headless.sh" 2>&1 | tee $SELENIUM_LOG &

# Set VNC password to a random one is not defined yet
if [ -z "$VNC_PASSWORD" ]; then
  vnc_password_generated=true
  random_password=$(genpassword)
  VNC_PASSWORD=${VNC_PASSWORD-$random_password}
fi

mkdir -p ~/.vnc
x11vnc -storepasswd $VNC_PASSWORD ~/.vnc/passwd

# Start VNC server to enable viewing what's going on but not mandatory
x11vnc -rfbport $VNC_PORT -display $DISPLAY \
    -forever -usepw -shared -noadd_keysyms -nopw -xkb \
    -clear_mods -clear_keys -clear_all 2>&1 | tee $VNC_LOG &
VNC_SERVER_PID=$!

# Authorize ssh user if $SSH_PUB_KEY was provided
[ -z "$HOME" ] && die "Need (\$HOME) to be set" 6
if [ ! -z "$HOME" ];then
  echo "INFO: \$SSH_PUB_KEY detected! will add to $HOME/.ssh/authorized_keys"
  echo $SSH_PUB_KEY >> $HOME/.ssh/authorized_keys
fi
# Start ssh server. Unfortunately needs sudo
# -e Write debug logs to standard error instead of the system log
# -D will not detach and does not become a daemon allowing easy monitoring
# -p Specifies the port on which the server listens for connections (default 22)
if [ "$USE_SUDO_TO_FIX_ETC_HOSTS" = true ]; then
  echo "INFO: Starting OpenSSH server..."
  sudo /usr/sbin/sshd -e -D -p ${SSHD_PORT} &
  SSHD_PID=$!
  # TODO: Add active wait to validate sshd started and works
fi

# Active wait until VNC server is listening
# for i in $(seq 1 $MAX_WAIT_RETRY_ATTEMPTS); do
#   nc -z localhost $VNC_PORT
#   [ $? -eq 0 ] && break
#   echo Waiting for VNC to start up...
#   sleep 0.1
# done
# if [ "$i" -ge "$MAX_WAIT_RETRY_ATTEMPTS" ]; then
#   die "Failed to start VNC!" 2 true
# fi
# Note this provokes "webSocketsHandshake: unknown connection error"
# so ignore that in the VNC server logs:
CMD_DESC_PARAM="VNC Server"
CMD_PARAM="nc -z localhost $VNC_PORT"
LOG_FILE_PARAM="$VNC_POLL_LOG"
with_backoff_and_slient

# Active wait until selenium is up
#  Inspired from: http://stackoverflow.com/a/21378425/511069
#  while ! curl http://localhost:4444/wd/hub/status &>/dev/null; do :; done
# for i in $(seq 1 $MAX_WAIT_RETRY_ATTEMPTS); do
#   curl http://localhost:$SELENIUM_PORT/wd/hub/status >/dev/null 2>&1
#   [ $? -eq 0 ] && break
#   echo Waiting for Selenium to start up...
#   sleep 0.1
# done
CMD_DESC_PARAM="Selenium"
CMD_PARAM="curl -s http://localhost:$SELENIUM_PORT/wd/hub/status"
LOG_FILE_PARAM="$SELENIUM_POLL_LOG"
with_backoff_and_slient
# if [ "$i" -ge "$MAX_WAIT_RETRY_ATTEMPTS" ]; then
#   die "Failed to start Selenium!" 3 true
# fi

echo
echo "Container docker internal IP: $CONTAINER_IP"
if [ "$vnc_password_generated" = "true" ]; then
  echo "a VNC password was generated for you: $VNC_PASSWORD"
fi
echo "start.sh all done and ready for testing"

# Run function shutdown() when this process receives SIGTERM or SIGINT
trap shutdown SIGTERM SIGINT

# tells bash to wait until child processes have exited
wait
