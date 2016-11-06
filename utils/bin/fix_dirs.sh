#!/usr/bin/env bash

# Set default firefox to the chosen one
sudo ln -fs ${FIREFOX_DEST_BIN} /usr/bin/firefox

# May need to fix perms when mounting volumes
#  Issue: http://stackoverflow.com/questions/23544282/
#  Solution: http://stackoverflow.com/a/28596874/511069
# GROUP_EXISTS=$(cat /etc/group | grep ${HOST_GID} | wc -l)
# # Create new group using target GID and add seluser user
# if [ $GROUP_EXISTS == "0" ]; then
#   sudo groupadd -g ${HOST_GID} tempgroup
#   sudo gpasswd -a seluser tempgroup
# else
#   # GID exists, find group name and add
#   EXISTING_GROUP=$(getent group ${HOST_GID} | cut -d: -f1)
#   sudo gpasswd -a seluser ${EXISTING_GROUP}
# fi
# Update: Actually let's just use sudo