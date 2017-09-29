#!/usr/bin/env bash

# set +e: don't exit if a command exits with a non-zero status
set +e

######################################################################
# Relaxing permissions for OpenShift and other non-sudo environments #
######################################################################

# List of directories in which we need to fix perms:
DIR_LIST="/var/lib/dbus /tmp /var/run /run /var/log/cont /etc/supervisor"
DIR_LIST="${DIR_LIST} /videos ${VIDEOS_DIR} /test /home/seluser"

# Relaxing permissions for OpenShift and other non-sudo environments
chmod 777 /etc/passwd

# Permissions related to the X system
chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

for d in ${DIR_LIST}; do

  chown -R seluser:seluser ${d}

  # Give full acess to everything (easier)
  # chmod -R 777 ${d}

  # Give 666 to files that were not executable
  find ${d} ! -executable -type f -exec chmod 666 "{}" \;

  # Give 777 to directories
  find ${d} -type d -exec chmod 777 "{}" \;

  # Give 777 to files that were already executable
  find ${d} -executable -type f -exec chmod 777 "{}" \;

done
