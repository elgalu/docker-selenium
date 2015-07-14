#!/usr/bin/env bash

mkdir -p ${HOME}/.vnc
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Create and fix directories perms
sudo mkdir -p /etc/supervisor/conf.d
sudo mkdir -p ${LOGS_DIR}
sudo mkdir -p ${RUN_DIR}
sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${NORMAL_USER_HOME}
sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${LOGS_DIR}
sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${RUN_DIR}
sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} /etc/supervisor

# This X11-unix is useful when using Xephyr
sudo mkdir -p /tmp/.X11-unix /tmp/.ICE-unix
sudo chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

# To avoid error "Missing privilege separation directory: /var/run/sshd"
sudo mkdir -p /var/run/sshd
sudo chmod 744 /var/run/sshd

# Set default firefox to the chosen one
sudo ln -s ${FIREFOX_DEST_BIN} /usr/bin
