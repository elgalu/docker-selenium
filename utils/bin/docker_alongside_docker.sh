#!/usr/bin/env bash

# If docker running with
#  -v /var/run/docker.sock:/var/run/docker.sock
#  -v $(which docker):$(which docker)
# Fix perms to avoid sudo when the docker container can docker run
# outside of itself. Useful for integration environments for ex.
if [ -S "${DOCKER_SOCK}" ]; then
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
