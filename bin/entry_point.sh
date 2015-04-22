#!/usr/bin/env bash
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"
export DOCKER_HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
export CONTAINER_IP=$(ip addr show dev eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
export VNC_PORT=5900
export XVFB_LOG="/tmp/Xvfb_headless.log"
export FLUXBOX_LOG="/tmp/fluxbox_manager.log"
export VNC_LOG="/tmp/x11vnc_forever.log"
export XTERMINAL_LOG="/tmp/local-sel-headless.log"
export SELENIUM_LOG="/tmp/selenium-server-standalone.log"

# As of docker >= 1.2.0 is possible to append our stuff directly into /etc/hosts
cat /tmp/hosts >> /etc/hosts
echo "$DOCKER_HOST_IP  docker.host"      >> /etc/hosts
echo "$CONTAINER_IP    docker.guest"     >> /etc/hosts
echo "$DOCKER_HOST_IP  docker.host.dev"  >> /etc/hosts
echo "$CONTAINER_IP    docker.guest.dev" >> /etc/hosts

# Start the X server that can run on machines with no display
# hardware and no physical input devices
/usr/bin/Xvfb $DISPLAY -screen 0 $GEOMETRY -ac +extension RANDR 2>&1 | tee $XVFB_LOG &
sleep 0.5

# A fast, lightweight and responsive window manager
fluxbox -display $DISPLAY 2>&1 | tee $FLUXBOX_LOG &

# Start a GUI xTerm to help debugging when VNC into the container
x-terminal-emulator -geometry 120x40+10+10 -ls -title "x-terminal-emulator" &
sleep 0.5

# Start a GUI xTerm to easily debug the headless instance
x-terminal-emulator -geometry 100x30-10-20 -ls -title "local-sel-headless" \
    -e "/opt/selenium/local-sel-headless.sh" 2>&1 | tee $XTERMINAL_LOG &

# Start VNC server to enable viewing what's going on but not mandatory
x11vnc -forever -usepw -shared -rfbport $VNC_PORT -display $DISPLAY 2>&1 | tee $VNC_LOG
