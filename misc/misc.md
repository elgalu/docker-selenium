Miscellaneous internal notes, do not read!

## Build

    time (docker build -t elgalu/selenium . ;echo $?;beep)
    docker run --rm -ti --name=local -e SELENIUM_HUB_PORT=5555 -p=5555:5555 -p=5900:25900 -e VIDEO=true -e VNC_PASSWORD=no --shm-size=1g elgalu/selenium

### Wait
Wait and get versions

    docker exec local wait_all_done 30s
    docker exec local versions

### Tests
See [CONTRIBUTING](./CONTRIBUTING.md)


## Setup
Push setup, first time only:

    docker login
    cp ~/.docker/config.json ~/.docker/config.pub.json

## Build hub

Build a grid with extra nodes

    docker run --rm --name=local -p 4444:24444 -p 5900:25900 --shm-size=1g -e VNC_PASSWORD=hola elgalu/selenium

    docker run --rm --name=node -e DISP_N=13 -e SSHD_PORT=22223 -e SUPERVISOR_HTTP_PORT=29003 -e VNC_PORT=25903 -e SELENIUM_NODE_CH_PORT=25330 -e SELENIUM_NODE_FF_PORT=25331 -e GRID=false -e CHROME=true -e FIREFOX=true --net=container elgalu/selenium

See logs

    docker exec -ti local bash -c "ls -lah /var/log/cont/"

## Transfer used browser source artifacts to keep them in the cloud

    SSHCMD="-o StrictHostKeyChecking=no -q -P 2222 application@localhost"
    mkdir -p binaries && cd binaries
    scp ${SSHCMD}:/home/application/chrome-deb/google*.deb .

List chrome versions via docker exec

    docker exec -ti local bash -c "ls -lah /home/application/chrome-deb/"

List firefox versions via docker exe

    docker exec -ti local bash -c "ls -lah /home/application/firefox-src/ && ls -lah /home/application/selenium/firefox**/firefox/firefox"

## Transfer the other way around

    SSHOPTS="-o StrictHostKeyChecking=no -q -P 2222"
    scp ${SSHOPTS} /local/file.txt application@localhost:/home/application/

## To update image id and digest

    docker inspect -f='{{.Id}}' elgalu/selenium
    docker images --digests

## Run with shared dir

    docker run --rm --name=local -p=127.0.0.1:4460:24444 -p=127.0.0.1:5910:25900 \
      -v /e2e/uploads:/e2e/uploads elgalu/selenium
    docker run --rm --name=local -p=4460:24444 -p=5910:25900 \
      -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) elgalu/selenium


    docker run --rm --name=ff -p=127.0.0.1:4461:24444 -p=127.0.0.1:5911:25900 -v /e2e/uploads:/e2e/uploads elgalu/selenium

## Run without shared dir and bind ports to all network interfaces

    docker run -d --name=local -p=0.0.0.0:4444:24444 -p=0.0.0.0:5900:25900 elgalu/selenium:0.1

## Opening tunnels

    export SELE_INST_IP=172.17.17.17
    export SOPTS="-o StrictHostKeyChecking=no"
    export TUNLOCOPTS="-v -N $SOPTS -L"
    export TUNREVOPTS="-v -N $SOPTS -R"
    # to use selenium at localhost:
    ssh ${TUNLOCOPTS} localhost:4455:${SELE_INST_IP}:24444 -p 2222 application@${SELE_INST_IP}
    # to expose local ports 3000/2525/4545/4546 inside docker container
    ssh ${TUNREVOPTS} localhost:3000:localhost:3000 -p 2222 application@${SELE_INST_IP}
    ssh ${TUNREVOPTS} localhost:2525:localhost:2525 -p 2222 application@${SELE_INST_IP}
    ssh ${TUNREVOPTS} localhost:4545:localhost:4545 -p 2222 application@${SELE_INST_IP}
    ssh ${TUNREVOPTS} localhost:4546:localhost:4546 -p 2222 application@${SELE_INST_IP}

## Run without dir and bind to all interfaces
Note anything after the image will be taken as arguments for the cmd/entrypoint

    docker run --rm --name=local -p=0.0.0.0:8813:8484 -p=0.0.0.0:2222:2222 -p=0.0.0.0:4470:24444 -p=0.0.0.0:5900:25900 -e SCREEN_WIDTH=1800 -e SCREEN_HEIGHT=1110 -e VNC_PASSWORD=hola -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" elgalu/selenium

    docker run --rm --name=local -p=4470:24444 -p=5900:25900 -e VNC_PASSWORD=hola elgalu/selenium
    docker run --rm --name=local -p=4470:24444 -p=5900:25900 -e VNC_PASSWORD=hola docker.io/elgalu/selenium
    docker run --rm --name=local -p=0.0.0.0:4470:24444 -p=0.0.0.0:5900:25900 --add-host myserver.dev:172.17.42.1 elgalu/selenium

However adding a custom host IP to server-selenium.local (e.g. bsele ssh config) is more work:

    ssh bsele
    sudo sh -c 'echo "10.161.128.36  myserver.dev" >> /etc/hosts'

    vncv localhost:5900 -Scaling=60%  &

    docker run --rm --name=ff -p=0.0.0.0:4471:24444 -p=0.0.0.0:5921:25900 elgalu/selenium

Automatic builds not working for me right now, maybe there is an issue with docker registry v1 vs v2
https://registry.hub.docker.com/u/elgalu/docker-selenium/builds_history/31621/

## Pulling

    docker pull registry.hub.docker.com/elgalu/selenium

## Pull

    docker run -d --name=max -p=0.0.0.0:4411:24444 -p=0.0.0.0:5911:25900 elgalu/selenium

How to connect through vnc (need a vnc client)

    vnc-client.sh server-selenium.local:{{vncPort}} -Scaling=60%  &

How to run ui:tests remotely on server-selenium.local instead of your laptop.

    grunt ui:remote-test --browser=chrome --seleniumUrl="http://server-selenium.local:{{seleniumPort}}/wd/hub" --appHost={{yourLaptopIPAddr}}

Note you may need to open firewall ports

    sudo ufw allow 3000
    sudo ufw allow 2525
    sudo ufw allow 4545
    sudo ufw allow 4546

Check it works

    http://localhost:4470/wd/hub/static/resource/hub.html

## Chrome options
    capabilities: {
        browserName: 'chrome',
        chromeOptions: {
            args: [
                '--disable-gpu',
                '--disable-impl-side-painting',
                '--disable-gpu-sandbox',
                '--disable-accelerated-2d-canvas',
                '--disable-accelerated-jpeg-decoding',
                '--no-sandbox',
                '--test-type=ui',
                ],
        },
    },

## Some stuff that didn't help solve the chrome crashed issue
Dockerfile

    # Disable the SUID sandbox so that Chrome can launch without being in a privileged container.
    # One unfortunate side effect is that `google-chrome --help` will no longer work.
    RUN dpkg-divert --add --rename --divert \
          /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome \
      && echo "#!/bin/bash\nexec /opt/google/chrome/google-chrome.real --disable-setuid-sandbox \"\$@\"" \
          > /opt/google/chrome/google-chrome \
      && chmod 755 /opt/google/chrome/google-chrome

    #=========================
    # Install Xpra and Xephyr
    #=========================
    USER root
    RUN wget -qO - http://winswitch.org/gpg.asc | apt-key add - \
      && echo "deb http://winswitch.org/ ${UBUNTU_FLAVOR} main" > /etc/apt/sources.list.d/winswitch.list
    RUN apt-get update -qqy \
      && apt-get -qqy install \
        xpra \
        xserver-xephyr \
        xserver-xorg-video-dummy \
      && mkdir -p ${HOME}/.xpra \
      && chown seluser:seluser ${HOME}/.xpra \
      && rm -rf /var/lib/apt/lists/*

start.sh

    # Xorg -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR +extension RENDER -logfile ${XVFB_LOG} -config ~/xorg.conf &
    # XORG_CMD="Xorg -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR +extension RENDER -logfile ${XVFB_LOG} -config ~/xorg.conf"
    # xpra --no-daemon --xvfb="${XORG_CMD}" start ${DISPLAY}
    # XVFB_PID=$!

    # xpra start ${DISPLAY}
    # sleep 5

    # xpra stop ${DISPLAY}
    # sleep 5

    # dbus-launch - Utility to start a message bus from a shell script
    # With no arguments, dbus-launch will launch a session bus instance
    # and print the address and PID of that instance to standard output
    # dbus-launch
    # DBUS_PID=$!
    # | sed -e "DBUS_SESSION_BUS_PID="

    # --xvfb -auth /home/docker/.Xauthority
      # --start-child="Xephyr -ac -screen ${SCREEN_SIZE} -query localhost -host-cursor -reset -terminate ${DISPLAY}" \
      # --xvfb="Xorg -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR +extension RENDER -logfile ${XVFB_LOG} -config ~/xorg.conf"
    # xpra start ${DISPLAY} --no-daemon --no-pulseaudio --no-mdns --no-notifications \
    #   --start-child="Xephyr -ac -screen ${SCREEN_SIZE} -query localhost -host-cursor -reset -terminate ${XEPHYR_DISPLAY}" \
    #   --xvfb="Xvfb ${DISPLAY} +extension Composite -screen ${SCREEN_NUM} ${GEOMETRY} -nolisten tcp -noreset"

## Alternatives in start.sh
Alternative to

    CMD_DESC_PARAM="Xvfb Server"
    CMD_PARAM="xdpyinfo -display $DISPLAY"
    LOG_FILE_PARAM="$XVFB_POLL_LOG"
    with_backoff_and_slient

Could be

    Active wait for $DISPLAY to be ready: https://goo.gl/mGttpb
    for i in $(seq 1 $MAX_WAIT_RETRY_ATTEMPTS); do
      xdpyinfo -display $DISPLAY >/dev/null 2>&1
      [ $? -eq 0 ] && break
      echo Waiting Xvfb to start up...
      sleep 0.1
    done
    if [ "$i" -ge "$MAX_WAIT_RETRY_ATTEMPTS" ]; then
      die "Failed to start Xvfb!" 1 true
    fi

## Other stuff
TODO fix lightdm Xauthority issue when using startx instead of openbox-session or whatever:

    # Same for all X servers
    #  xauth: timeout in locking authority file /var/lib/lightdm/.Xauthority
    startx -- $DISPLAY 2>&1 | tee $XMANAGER_LOG &
    XSESSION_PID=$!

Note sometimes chrome fails with:
session deleted because of page crash from tab crashed
"session deleted because of page crash" "from tab crashed"
reported as tmux related:
  https://github.com/angular/protractor/issues/731
reported to be fixed with --disable-impl-side-painting:
  https://code.google.com/p/chromedriver/issues/detail?id=732#c19

Protractor config example
Update: doesn't fix the issue, see: https://github.com/elgalu/docker-selenium/issues/20

    capabilities: {
        browserName: 'chrome',
        chromeOptions: {
            args: ['--disable-impl-side-painting'],
        },
    },

Example of using xvfb-run to just run selenium:

    xvfb-run --server-num=$DISP_N --server-args="-screen ${SCREEN_NUM} ${GEOMETRY}" \
      "$BIN_UTILS/local-sel-headless.sh"  &

Example of sending selenium output to a log instead of stdout

    $BIN_UTILS/local-sel-headless.sh > $SELENIUM_LOG  &

Alternative to

    $BIN_UTILS/local-sel-headless.sh 2>&1 | tee $SELENIUM_LOG &

Could be to also start it within an xterm but then the logs won't be at docker logs

    x-terminal-emulator -geometry 160x40-10-10 -ls -title "local-sel-headless" \
      -e "$BIN_UTILS/local-sel-headless.sh" 2>&1 | tee $SELENIUM_LOG &

Alternative to active wait until VNC server is listening

    for i in $(seq 1 $MAX_WAIT_RETRY_ATTEMPTS); do
      nc -z localhost $VNC_PORT
      [ $? -eq 0 ] && break
      echo Waiting for VNC to start up...
      sleep 0.1
    done
    if [ "$i" -ge "$MAX_WAIT_RETRY_ATTEMPTS" ]; then
      die "Failed to start VNC!" 2 true
    fi

Alternative to active wait until selenium is up
Inspired from: http://stackoverflow.com/a/21378425/511069

    while ! curl http://localhost:24444/wd/hub/status &>/dev/null; do :; done
    for i in $(seq 1 $MAX_WAIT_RETRY_ATTEMPTS); do
      curl http://localhost:$SELENIUM_PORT/wd/hub/status >/dev/null 2>&1
      [ $? -eq 0 ] && break
      echo Waiting for Selenium to start up...
      sleep 0.1
    done
    if [ "$i" -ge "$MAX_WAIT_RETRY_ATTEMPTS" ]; then
      die "Failed to start Selenium!" 3 true
    fi

## More notes on Xephyr and friends

- This comes handy when testing things without disturbing your normal awesome desktop:
https://awesome.naquadah.org/wiki/Using_Xephyr

- Xpra is 'screen for X', and more: it allows you to run X programs, usually on a remote host and direct their display to your local machine. It also allows you to display existing desktop sessions remotely.
Xpra has osx/win/linux clients:
    https://www.xpra.org/dists/vivid/main/binary-amd64/
    https://www.xpra.org/dists/osx/x86/
https://www.xpra.org/trac/wiki/Usage#AccesswithoutSSH

- In the context of Xpra, Xdummy allows us to use a better, more up to date X11 display server
http://xpra.org/trac/wiki/Xdummy

https://github.com/mccahill/docker-eclipse-novnc

https://github.com/bencawkwell/dockerfile-xpra/blob/master/Dockerfile#L18

cd ~/oss/docker-desktop/
https://github.com/rogaha/docker-desktop/blob/master/startup.sh#L7
https://github.com/rogaha/docker-desktop/blob/master/Dockerfile#L38

### Using free available ports and tunneling to emulate localhost testing
Let's say you need to expose 4 ports (3000, 2525, 4545, 4546) from your laptop but test on the remote docker selenium.
Enter tunneling.

```sh
# -- Common: Set some handy shortcuts.
# On development machine (target test localhost server)
SOPTS="-o StrictHostKeyChecking=no"
TUNLOCOPTS="-v -N $SOPTS -L"
TUNREVOPTS="-v -N $SOPTS -R"
# port 0 means bind to a free available port
ANYPORT=0

# -- Option 1. docker run - Running docker locally
# Run a selenium instance binding to host random ports
REMOTE_DOCKER_SRV=localhost
CONTAINER=$(docker run -d -p=0.0.0.0:${ANYPORT}:22222 -p=0.0.0.0:${ANYPORT}:24444 \
    -p=0.0.0.0:${ANYPORT}:25900 -e SCREEN_HEIGHT=1110 -e VNC_PASSWORD=hola \
    -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" elgalu/selenium

# -- Option 2.docker run- Running docker on remote docker server like in the cloud
# Useful if the docker server is running in the cloud. Establish free local ports
REMOTE_DOCKER_SRV=some.docker.server.com
ssh ${REMOTE_DOCKER_SRV} #get into the remote docker provider somehow
# Note in remote server I'm using authorized_keys instead of id_rsa.pub given
# it acts as a jump host so my public key is already on that server
CONTAINER=$(docker run -d -p=0.0.0.0:${ANYPORT}:22222 -e SCREEN_HEIGHT=1110 \
    -e VNC_PASSWORD=hola -e SSH_AUTH_KEYS="$(cat ~/.ssh/authorized_keys)" \
    elgalu/selenium

# -- Common: Wait for the container to start
./host-scripts/wait-docker-selenium.sh grid 7s
json_filter='{{(index (index .NetworkSettings.Ports "22222/tcp") 0).HostPort}}'
SSHD_PORT=$(docker inspect -f='${json_filter}' $CONTAINER)
echo $SSHD_PORT #=> e.g. SSHD_PORT=32769

# -- Option 1. Obtain dynamic values like container IP and assigned free ports
json_filter='{{(index (index .NetworkSettings.Ports "24444/tcp") 0).HostPort}}'
FREE_SELE_PORT=$(docker inspect -f='${json_filter}' $CONTAINER)
json_filter='{{(index (index .NetworkSettings.Ports "25900/tcp") 0).HostPort}}'
FREE_VNC_PORT=$(docker inspect -f='${json_filter}' $CONTAINER)

# -- Option 2. Get some free ports in current local machine. Needs python.
# IMPORTANT: Go back to development machine
FREE_SELE_PORT=$(python -c 'import socket; s=socket.socket(); \
    s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
FREE_VNC_PORT=$(python -c 'import socket; s=socket.socket(); \
    s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
# -- Option 2. Tunneling selenium+vnc is necessary if using a remote docker
ssh ${TUNLOCOPTS} localhost:${FREE_SELE_PORT}:localhost:24444 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
LOC_TUN_SELE_PID=$!
ssh ${TUNLOCOPTS} localhost:${FREE_VNC_PORT}:localhost:25900 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
LOC_TUN_VNC_PID=$!
echo $FREE_SELE_PORT $FREE_VNC_PORT

# -- Common: Expose local ports so can be tested as 'localhost'
# inside the docker container
ssh ${TUNREVOPTS} localhost:3000:localhost:3000 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
REM_TUN1_PID=$!
ssh ${TUNREVOPTS} localhost:2525:localhost:2525 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
REM_TUN2_PID=$!
ssh ${TUNREVOPTS} localhost:4545:localhost:4545 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
REM_TUN3_PID=$!
ssh ${TUNREVOPTS} localhost:4546:localhost:4546 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
REM_TUN4_PID=$!
echo Option 1. Should show 4 ports when doing it locally
echo Option 2. Should show 6 ports when doing it remotely
echo $REM_TUN1_PID $REM_TUN2_PID $REM_TUN3_PID \
    $REM_TUN4_PID $LOC_TUN_SELE_PID $LOC_TUN_VNC_PID
# Use the container as if selenium and VNC were running locally
# thanks to ssh -L port FWD
google-chrome-stable \
    "http://localhost:${FREE_SELE_PORT}/wd/hub/static/resource/hub.html"
vncv localhost:${FREE_VNC_PORT} -Scaling=70% &
# Stop all the things after your tests are done
kill $REM_TUN1_PID $REM_TUN2_PID $REM_TUN3_PID \
    $REM_TUN4_PID $LOC_TUN_SELE_PID $LOC_TUN_VNC_PID
# if in Option 2. execute below commands inside docker
# provider machine `ssh ${REMOTE_DOCKER_SRV}`
docker stop ${CONTAINER}
docker rm ${CONTAINER}
```

### Sample .travis.yml
os:
  - linux
  - osx
# OSX conf
osx_image: xcode8
# Linux conf
sudo: required
services:
  - docker
matrix:
  allow_failures:
    - env: TRAVIS_OS_NAME=osx
    - env: DOCKER_COMPOSE_VERSION="1.8.0-rc1"
    # - env: TRAVIS_OS_NAME=osx DOCKER_VERSION=stable DOCKER_COMPOSE_VERSION="1.7.1"
env:
  global:
    - TEST_SLEEPS="0.7"
  matrix:
    # Docker compose stable version
    - DOCKER_VERSION="stable"
      DOCKER_COMPOSE_VERSION="1.7.1"
      DOCKER_PUSH=true
    - DOCKER_VERSION="1.12.0-rc3"
      DOCKER_COMPOSE_VERSION="1.7.1"
    # Docker compose release candidate version
    - DOCKER_VERSION="stable"
      DOCKER_COMPOSE_VERSION="1.8.0-rc1"
    - DOCKER_VERSION="1.12.0-rc3"
      DOCKER_COMPOSE_VERSION="1.8.0-rc1"

If you also want windows manager support, i.e. want to `make move` _(optional but not supported in OSX)_

    make install_wmctrl

## Binaries

    cd binaries && wget -O stable_updates.html "http://googlechromereleases.blogspot.de/search/label/Stable%20updates"
    VER=$(grep -Po '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' stable_updates.html | head -1)
    rm -f stable_updates.html && cd ..

### videos

##################################################
# untrunc to restore a damaged (truncated) video #
##################################################
# Download ponchio/untrunc dated 2015-09-08 commit 07be275f02927417e81da7d3729a3854b9d98b37
ENV UNTRUNC_SHA="07be275f02927417e81da7d3729a3854b9d98b37"
RUN  wget -nv -O unTrunc.zip \
       "https://github.com/ponchio/untrunc/archive/${UNTRUNC_SHA}.zip" \
  && unzip -x unTrunc.zip \
  && mv untrunc-${UNTRUNC_SHA} untrunc \
  && rm unTrunc.zip \
  && cd untrunc \
  && g++ -o untrunc file.cpp main.cpp \
            track.cpp atom.cpp mp4.cpp \
            -L/usr/local/lib -lavformat \
            -lavcodec -lavutil \
  && mv untrunc /usr/bin
