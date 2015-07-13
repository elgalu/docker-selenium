#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

#---------------------
# Fix/extend ENV vars
#---------------------
# We recalculate screen dimensions because docker run supports changing them
export GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}""x""${SCREEN_DEPTH}"
# These values are only available when the container started
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
export CONTAINER_IP=$(ip addr show dev eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
#end.

#--------------------------------
# Improve etc/hosts and fix dirs
improve_etc_hosts.sh
fix_dirs.sh

#-------------------------
# Docker alongside docker
docker_alongside_docker.sh

#------------------
# Fix running user
#------------------
RUN_PREFIX="sudo -E HOME=/home/$NORMAL_USER -u $NORMAL_USER"
# RUN_SUPERVISOR="supervisord -c /etc/supervisor/supervisord.conf --pidfile ${RUN_DIR}/supervisord.pid"
RUN_SUPERVISOR="supervisord -c /etc/supervisor/supervisord.conf"
RUN_START="${RUN_PREFIX} $BIN_UTILS/start.sh"
# RUN_TAIL="grc tail -f ${LOGS_DIR}/supervisord.log --pid=$(cat ${RUN_DIR}/supervisord.pid) --sleep-interval=0.1"
WHOAMI=$(whoami)
WHOAMI_EXIT_CODE=$?
echo "-- INFO: Container USER var is: '$USER', \$(whoami) returns '$WHOAMI', UID is '$UID'"

#------
# exec
#------
if [ $WHOAMI_EXIT_CODE != 0 ]; then
  if [ $UID != $NORMAL_USER_UID]; then
    echo "-- WARN: UID '$UID' is different from the expected '$NORMAL_USER_UID'"
    echo "-- INFO: Will try to fix uid before continuing"
    # TODO: fix it ...
    echo "-- now will try to use NORMAL_USER: '$NORMAL_USER' to continue"
    exec ${RUN_PREFIX} ${RUN_SUPERVISOR}
  else
    echo "-- WARN: You seem to be running docker -u {{some-non-existing-user-in-container}}"
    echo "-- will try to use NORMAL_USER: '$NORMAL_USER' instead."
    exec ${RUN_PREFIX} ${RUN_SUPERVISOR}
  fi
elif [ "$WHOAMI" = "root" ]; then
  echo "-- WARN: Container running user is 'root' so switching to less privileged one"
  echo "-- will use NORMAL_USER: '$NORMAL_USER' instead."
  exec ${RUN_PREFIX} ${RUN_SUPERVISOR}
else
  echo "-- INFO: Will use \$USER '$USER' and \$(whoami) is '$WHOAMI'"
  exec ${RUN_SUPERVISOR}
fi

# Note: sudo -i creates a login shell for someUser, which implies the following:
# - someUser's user-specific shell profile, if defined, is loaded.
# - $HOME points to someUser's home directory, so there's no need for -H (though you may still specify it)
# - the working directory for the impersonating shell is the someUser's home directory.
