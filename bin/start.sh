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
    if [ "${SUDO_ALLOWED}" = true ]; then
      sudo kill -s SIGTERM $the_pid
    else
      kill -s SIGTERM $the_pid
    fi
    local wait_msg="waiting for $pdesc PID: $the_pid to die..."
    timeout 1 bash -c "while [ -d /proc/$the_pid ]; do sleep 0.1 && echo $wait_msg; done"
    if [ -d /proc/$the_pid ]; then
      echo "$pdesc PID: $the_pid still running, forcing with kill -SIGKILL..."
      if [ "${SUDO_ALLOWED}" = true ]; then
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
    bash -a -c "$cmd" >$log_file 2>&1
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
  [ "$WITH_SSH" = true ]       && kill_pid_gracefully $SSHD_PID "OpenSSH server"
  [ "$WITH_GUACAMOLE" = true ] && kill_pid_gracefully $CATALINA_PID "Tomcat Catalina server"
  [ "$WITH_GUACAMOLE" = true ] && kill_pid_gracefully $GUACD_PID "Guacamole server"
  echo "Shutdown complete."
}

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"
export SCREEN_SIZE="$SCREEN_WIDTH""x""$SCREEN_HEIGHT"""
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
export CONTAINER_IP=$(ip addr show dev eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
# Active waits (poll) logs
export XVFB_POLL_LOG="/var/log/sele/xvfb_poll_start.log"
export VNC_POLL_LOG="/var/log/sele/vnc_poll_start.log"
export SELENIUM_POLL_LOG="/var/log/sele/selenium_poll_start.log"
export TOMCAT_POLL_LOG="/var/log/sele/tomcat_poll_start.log"
export GUACD_POLL_LOG="/var/log/sele/guacd_poll_start.log"

# As of docker >= 1.2.0 is possible to append our stuff directly into /etc/hosts
if [ "${SUDO_ALLOWED}" = true ]; then
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

if [ ! -z "${XE_DISP_NUM}" ]; then
  echo "INFO: XE_DISP_NUM '${XE_DISP_NUM}' was provided so switching to that DISPLAY"
  echo "INFO:   and skipping virtual framebuffer startup in favor of remote."
  export DISP_N="${XE_DISP_NUM}"
  export DISPLAY=":${DISP_N}"
else
  if [ ":$DISP_N" != "${DISPLAY}" ]; then
    echo "WARN: DISP_N '${DISP_N}' doesn't match DISPLAY '${DISPLAY}'"
    export DISPLAY=":${DISP_N}"
    echo "WARN:   so fixing it; new DISPLAY is '${DISPLAY}'"
  fi

  # Start the X server that can run on machines with no real display
  #==============================
  # using Xvfb instead of Xdummy
  #==============================
  Xvfb ${DISPLAY} -screen ${SCREEN_NUM} ${GEOMETRY} -ac -r -cc 4 -accessx \
    -xinerama +extension Composite -extension RANDR 2>&1 | tee $XVFB_LOG &
  XVFB_PID=$!

  # Start the X server that can run on machines with no real display
  #==============================
  # using Xdummy instead of Xvfb
  #==============================
  # genereate_xorg_configs.sh || die "Failed to start genereate_xorg_configs!" 11 true
  # Xorg ${DISPLAY} -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR \
  #   +extension RENDER -logfile ${XVFB_LOG} -config ${HOME}/xorg.conf | tee $XVFB_LOG &
  # XVFB_PID=$!
fi

# Active wait for ${DISPLAY} to be ready
CMD_DESC_PARAM="Xvfb Server"
CMD_PARAM="xdpyinfo -display ${DISPLAY}"
LOG_FILE_PARAM="$XVFB_POLL_LOG"
with_backoff_and_slient

# Alternative 1.
#  Openbox is a lightweight window manager using freedesktop standards
openbox-session 2>&1 | tee $XMANAGER_LOG &
XSESSION_PID=$!

# Alternative 2.
#  Fluxbox is a fast, lightweight and responsive window manager
# fluxbox -display ${DISPLAY} 2>&1 | tee $XMANAGER_LOG &

# Alternative 3.
#  GNOME Shell provides core interface functions like switching windows,
#  launching applications or see your notifications
# gnome-shell -display ${DISPLAY} 2>&1 | tee $XMANAGER_LOG &

# Alternative 4.
#  GNOME ubuntu desktop; The fat and full featured windows manager
# /etc/X11/Xsession &
# gnome-session &

# Alternative 5.
#  Not working: LXDE is a Lightweight X11 Desktop Environment
# lxde -display ${DISPLAY} 2>&1 | tee $XMANAGER_LOG &

# Alternative 6.
#  lightdm is a fat and full featured windows manager
# lightdm-session 2>&1 | tee $XMANAGER_LOG &
# XSESSION_PID=$!

# Sends selenium output to docker logs stream
$BIN_UTILS/local-sel-headless.sh 2>&1 | tee $SELENIUM_LOG &
SELENIUM_PID=$!

# Start a GUI xTerm to help debugging when VNC into the container
x-terminal-emulator -geometry 120x40+10+10 -ls -title "x-terminal-emulator" &
HANDY_TERM_PID=$!

# Set VNC password to a random one if not defined yet
if [ -z "${VNC_PASSWORD}" ]; then
  vnc_password_generated=true
  random_password=$(genpassword)
  export VNC_PASSWORD=${VNC_PASSWORD-$random_password}
fi

if [ "$WITH_GUACAMOLE" = true ] && [ -z "${XE_DISP_NUM}" ]; then
  # Generate config files based on env vars before starting guacamole
  genereate_guaca_configs.sh || die "Failed to start genereate_guaca_configs!" 9 true

  # Run guacd
  # -f     Causes guacd to run in the foreground, rather than automatically forking into the background.
  guacd -f -b "0.0.0.0" -l ${GUACAMOLE_SERVER_PORT} 2>&1 | tee ${GUACD_LOG} &
  GUACD_PID=$!

  # For guacd
  CMD_DESC_PARAM="guacd server"
  # CMD_PARAM="nc -z localhost ${GUACAMOLE_SERVER_PORT}"
  CMD_PARAM="grep \"Guacamole proxy daemon (guacd) version ${GUACAMOLE_VERSION} started\" ${GUACD_LOG}"
  LOG_FILE_PARAM="$GUACD_POLL_LOG"
  with_backoff_and_slient

  # Generate TOMCAT_CONF with dynamic port
  #
  export TOMCAT_DIR_CONF=${HOME}/tomcat/conf
  export TOMCAT_CONF=${TOMCAT_DIR_CONF}/new_server.xml

# http://examples.javacodegeeks.com/enterprise-java/tomcat/tomcat-server-xml-configuration-example/
cat >${TOMCAT_CONF} <<EOF
<?xml version='1.0' encoding='utf-8'?>
<Server port="${TOMCAT_SHUTDOWN_PORT}" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />
  <GlobalNamingResources>
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>
  <Service name="Catalina">
    <Connector port="${TOMCAT_PORT}" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="${TOMCAT_REDIRECT_PORT}" />
    <Connector port="${TOMCAT_AJP_PORT}" protocol="AJP/1.3" redirectPort="${TOMCAT_REDIRECT_PORT}" />
    <Engine name="Catalina" defaultHost="localhost">
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>
      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log" suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
      </Host>
    </Engine>
  </Service>
</Server>
EOF

  # Run tomcat to start guacamole web-server
  catalina.sh run -config ${TOMCAT_CONF} 2>&1 | tee ${CATALINA_LOG} &
  CATALINA_PID=$!
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
  x11vnc -rfbport ${VNC_PORT} -display ${DISPLAY} \
      -rfbauth ${VNC_STORE_PWD_FILE} -forever -shared 2>&1 | tee $VNC_LOG &
  VNC_SERVER_PID=$!
fi

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
if [ "${SUDO_ALLOWED}" = true ] && [ "$WITH_SSH" = true ]; then
  echo "INFO: Starting OpenSSH server..."
  sudo /usr/sbin/sshd -e -D -p ${SSHD_PORT} &
  SSHD_PID=$!
  # TODO: Add active wait to validate sshd started and works
fi

if [ -z "${XE_DISP_NUM}" ]; then
  # Active wait until VNC server is listening
  # Note this active wait provokes "webSocketsHandshake: unknown connection error"
  # so ignore that in the VNC server logs:
  CMD_DESC_PARAM="VNC Server"
  CMD_PARAM="nc -z localhost ${VNC_PORT}"
  LOG_FILE_PARAM="$VNC_POLL_LOG"
  with_backoff_and_slient
fi

# If docker running with
#  -v /var/run/docker.sock:/var/run/docker.sock
#  -v $(which docker):$(which docker)
# Fix perms to avoid sudo when the docker container can docker run
# outside of itself. Useful for integration environments for ex.
if [ -S "${DOCKER_SOCK}" ] && [ "${SUDO_ALLOWED}" = true ]; then
  TARGET_GID=$(stat -c "%g" ${DOCKER_SOCK})
  EXISTS=$(cat /etc/group | grep $TARGET_GID | wc -l)
  # Create new group using target GID and add ${NORMAL_USER}
  if [ ${EXISTS} == "0" ]; then
    GROUP_NAME="dockersockgrphelper"
    # Create the group as it doesn't exist yet
    sudo groupadd -g ${TARGET_GID} ${GROUP_NAME}
  else
    # GID exists, find the group name
    GROUP_NAME=$(getent group ${TARGET_GID} | cut -d: -f1)
  fi
  sudo gpasswd -a ${NORMAL_USER} ${GROUP_NAME}
  newgrp ${GROUP_NAME}
fi

# Active wait until selenium is up
CMD_DESC_PARAM="Selenium"
CMD_PARAM="curl -s http://localhost:$SELENIUM_PORT/wd/hub/status | jq '.state' | grep success"
LOG_FILE_PARAM="$SELENIUM_POLL_LOG"
with_backoff_and_slient

if [ "$WITH_GUACAMOLE" = true ] && [ -z "${XE_DISP_NUM}" ]; then
  CMD_DESC_PARAM="Tomcat Catalina server"
  CMD_PARAM="grep \"org.apache.catalina.startup.Catalina.start Server startup in\" ${CATALINA_LOG}"
  LOG_FILE_PARAM="$TOMCAT_POLL_LOG"
  with_backoff_and_slient
fi

echo
echo "Container docker internal IP: $CONTAINER_IP"
echo "Note if you're in Mac (OSX) 'boot2docker ip' will tell you the relevant IP"
if [ "$vnc_password_generated" = "true" ]; then
  echo "a VNC password was generated for you: $VNC_PASSWORD"
fi
echo "start.sh all done and ready for testing"

# Run function shutdown() when this process receives SIGTERM or SIGINT
# TODO: replace with supervisord or create 1 docker image per process
#  and use docker-compose to link them together
#  https://github.com/elgalu/docker-selenium/issues/24
trap shutdown SIGTERM SIGINT

# tells bash to wait until child processes have exited
wait
