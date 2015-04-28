#!/usr/bin/env bash
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
export CONTAINER_IP=$(ip addr show dev eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
export VNC_PORT=5900
export XVFB_LOG="/tmp/Xvfb_headless.log"
export XMANAGER_LOG="/tmp/xmanager.log"
export VNC_LOG="/tmp/x11vnc_forever.log"
export XTERMINAL_LOG="/tmp/local-sel-headless.log"
export SELENIUM_LOG="/tmp/selenium-server-standalone.log"

# As of docker >= 1.2.0 is possible to append our stuff directly into /etc/hosts
sudo -E sh -c 'cat /tmp/hosts >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  docker.host"        >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    docker.guest"       >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  docker.host.dev"    >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    docker.guest.dev"   >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  host.docker.local"  >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    guest.docker.local" >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  host.docker"        >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    guest.docker"       >> /etc/hosts'

# Start the X server that can run on machines with no display
# hardware and no physical input devices
sudo /usr/bin/Xvfb $DISPLAY -screen $SCREEN_NUM $GEOMETRY \
    -ac -r -cc 4 -accessx -xinerama -extension RANDR 2>&1 | tee $XVFB_LOG &
sleep 0.5

# Note: sudo -i creates a login shell for someUser, which implies the following:
# - someUser's user-specific shell profile, if defined, is loaded.
# - $HOME points to someUser's home directory, so there's no need for -H (though you may still specify it)
# - the working directory for the impersonating shell is the someUser's home directory.

# Alternative 1.
#  Fluxbox is a fast, lightweight and responsive window manager
# fluxbox -display $DISPLAY 2>&1 | tee $XMANAGER_LOG &
# sleep 0.5

# Alternative 2.
#  GNOME Shell provides core interface functions like switching windows,
#  launching applications or see your notifications
# gnome-shell -display $DISPLAY 2>&1 | tee $XMANAGER_LOG &

# Alternative 3.
#  GNOME ubuntu desktop; The fat and full featured windows manager
# /etc/X11/Xsession &
# sleep 0.3
# gnome-session &
# sleep 0.3

# Alternative 4.
#  Not working: LXDE is a Lightweight X11 Desktop Environment
# lxde -display $DISPLAY 2>&1 | tee $XMANAGER_LOG &

# Alternative 5.
#  Not working: Openbox is a lightweight window manager using freedesktop standards
openbox-session 2>&1 | tee $XMANAGER_LOG &
sleep 0.5

# Start a GUI xTerm to help debugging when VNC into the container
x-terminal-emulator -geometry 120x40+10+10 -ls -title "x-terminal-emulator" &
sleep 0.1

# Start a GUI xTerm to easily debug the headless instance
x-terminal-emulator -geometry 160x40-10-10 -ls -title "local-sel-headless" \
-e "/opt/selenium/local-sel-headless.sh" 2>&1 | tee $XTERMINAL_LOG &
sleep 0.1

# Start VNC server to enable viewing what's going on but not mandatory
x11vnc -forever -usepw -shared -rfbport $VNC_PORT -display $DISPLAY \
    -noadd_keysyms -clear_mods -clear_keys -clear_all 2>&1 | tee $VNC_LOG
