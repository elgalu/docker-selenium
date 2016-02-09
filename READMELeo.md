## Build

    time (docker build -t="elgalu/selenium:2.51.0a" . ;echo $?;beep)
    docker run --rm -ti -m 4000M --cpu-quota=0 --name=grid -p=4444:24444 -p=5920:25900 -p=2222:22222 -e DISABLE_ROLLBACK=true -e VIDEO=true -e MEM_JAVA="1024m" -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" -v /dev/shm:/dev/shm elgalu/selenium:2.51.0a

Wait and id

    docker exec grid wait_all_done 30s
    docker exec grid versions

Chrome artifact

    VER="48.0.2564.103"
    wget -nv --show-progress -O binaries/google-chrome-stable_${VER}_amd64.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    #old: docker cp grid:/home/application/chrome-deb/. binaries/

## Push

    docker push elgalu/selenium:2.51.0a ;echo $?;beep
    docker inspect -f='{{.Id}}' elgalu/selenium:2.51.0a | xclip -sel clip
    # also grab digest and update CHANGELOG.md
    git add CHANGELOG.md && gci "2.51.0a: Update image id and digest"
    docker tag -f elgalu/selenium:2.51.0a elgalu/selenium:latest
    docker push elgalu/selenium:latest
    git tag 2.51.0a && git tag -f latest && git push && git push --tags -f

Location of binaries, e.g.

    /home/user/oss/docker/binaries

Push setup, first time only:

    docker login
    cp ~/.docker/config.json ~/.docker/config.pub.json

## Build hub

Build a grid with extra nodes

    docker run --rm --name=grid -p 4444:24444 -p 5920:25900 -v /dev/shm:/dev/shm -e VNC_PASSWORD=hola elgalu/selenium:2.51.0a

    docker run --rm --name=node -e DISP_N=13 -e SSHD_PORT=22223 -e SUPERVISOR_HTTP_PORT=29003 -e VNC_PORT=25903 -e SELENIUM_NODE_CH_PORT=25330 -e SELENIUM_NODE_FF_PORT=25331 -e GRID=false -e CHROME=true -e FIREFOX=true --net=container:grid elgalu/selenium:2.51.0a

See logs

    docker exec -ti grid bash -c "ls -lah /var/log/cont/"

## Transfer used browser source artifacts to keep them in the cloud

    SSHCMD="-o StrictHostKeyChecking=no -q -P 2222 application@localhost"
    mkdir -p binaries && cd binaries
    scp ${SSHCMD}:/home/application/chrome-deb/google*.deb .

List chrome versions via docker exec

    docker exec -ti grid bash -c "ls -lah /home/application/chrome-deb/"

List firefox versions via docker exe

    docker exec -ti grid bash -c "ls -lah /home/application/firefox-src/ && ls -lah /home/application/selenium/firefox**/firefox/firefox"

## Transfer the other way around

    SSHOPTS="-o StrictHostKeyChecking=no -q -P 2222"
    scp ${SSHOPTS} /local/file.txt application@localhost:/home/application/

## To update image id and digest

    docker inspect -f='{{.Id}}' elgalu/selenium:2.51.0a
    docker images --digests

## Run with shared dir

    docker run --rm --name=grid -p=127.0.0.1:4460:24444 -p=127.0.0.1:5910:25900 \
      -v /e2e/uploads:/e2e/uploads elgalu/selenium:2.51.0a
    docker run --rm --name=grid -p=4460:24444 -p=5910:25900 \
      -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) elgalu/selenium:2.51.0a


    docker run --rm --name=ff -p=127.0.0.1:4461:24444 -p=127.0.0.1:5911:25900 -v /e2e/uploads:/e2e/uploads elgalu/selenium:2.51.0a

## Run without shared dir and bind ports to all network interfaces

    docker run -d --name=grid -p=0.0.0.0:4444:24444 -p=0.0.0.0:5900:25900 elgalu/selenium:0.1

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

    docker run --rm --name=grid -p=0.0.0.0:8813:8484 -p=0.0.0.0:2222:2222 -p=0.0.0.0:4470:24444 -p=0.0.0.0:5920:25900 -e SCREEN_WIDTH=1800 -e SCREEN_HEIGHT=1110 -e VNC_PASSWORD=hola -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" elgalu/selenium:2.51.0a

    docker run --rm --name=grid -p=4470:24444 -p=5920:25900 -e VNC_PASSWORD=hola elgalu/selenium:2.51.0a
    docker run --rm --name=grid -p=4470:24444 -p=5920:25900 -e VNC_PASSWORD=hola docker.io/elgalu/selenium:2.51.0a
    docker run --rm --name=grid -p=0.0.0.0:4470:24444 -p=0.0.0.0:5920:25900 --add-host myserver.dev:172.17.42.1 elgalu/selenium:2.51.0a

However adding a custom host IP to server-selenium.local (e.g. bsele ssh config) is more work:

    ssh bsele
    sudo sh -c 'echo "10.161.128.36  myserver.dev" >> /etc/hosts'

    vncv localhost:5920 -Scaling=60%  &

    docker run --rm --name=ff -p=0.0.0.0:4471:24444 -p=0.0.0.0:5921:25900 elgalu/selenium:2.51.0a

Automatic builds not working for me right now, maybe there is an issue with docker registry v1 vs v2
https://registry.hub.docker.com/u/elgalu/docker-selenium/builds_history/31621/

## Pulling

    docker pull registry.hub.docker.com/elgalu/selenium:2.51.0a

## Pull

    docker run -d --name=max -p=0.0.0.0:4411:24444 -p=0.0.0.0:5911:25900 elgalu/selenium:2.51.0a

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
      && chown ${NORMAL_USER}:${NORMAL_GROUP} ${HOME}/.xpra \
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

## Grid
## Hub

You can launch a grid only container via environment variables:

    docker run --rm --name=hub -p 4444:24444 -p 5930:25900 \
      -e CHROME=false -e FIREFOX=false elgalu/selenium:2.51.0a

The important part above is `-e CHROME=false -e FIREFOX=false` which tells the docker image not run run default chorme and firefox nodes turning the container into a grid-only one.

## Node

You can lunch a node only container via environment variables:

    docker run --rm --name=node -p=5940:25900 \
      -p 25550:25550 -p 25551:25551 \
      -e SELENIUM_HUB_HOST=docker.host \
      -e SELENIUM_HUB_PORT=4444 \
      -e SELENIUM_NODE_HOST=docker.host \
      -e GRID=false -e CHROME=true -e FIREFOX=true \
      elgalu/selenium:2.51.0a

The important part above is `-e GRID=false` which tells the container to be a node-only node, this this case with 2 browsers `-e CHROME=true -e FIREFOX=true` but could be just 1.

Note `SELENIUM_HUB_HOST` and `SELENIUM_NODE_HOST` represent a network firewall config challenge when running on different machines and should be changed to the proper host names or IP addresses of those.

### Grid and Nodes on the same network interface
Start the grid with Chrome and Firefox

    docker run -d --name=grid \
      -p 4444:24444 -p 5810:5810 -p 5820:5820 -p 5830:5830 \
      -e SELENIUM_NODE_CH_PORT=25010 -e SELENIUM_NODE_FF_PORT=26010 \
      -e GRID=true -e CHROME=true -e FIREFOX=true \
      -e VNC_PASSWORD=hola -e VNC_PORT=5810 \
      -v /dev/shm:/dev/shm elgalu/selenium:2.51.0a

Add another docker container node with 2 more browsers:

    docker run -d --name=node1 --net=container:grid \
      -e DISP_N=20 -e SSHD_PORT=22220 \
      -e SUPERVISOR_HTTP_PORT=29020 \
      -e SELENIUM_NODE_CH_PORT=25020 -e SELENIUM_NODE_FF_PORT=26020 \
      -e GRID=false -e CHROME=true -e FIREFOX=true \
      -e VNC_PASSWORD=hola -e VNC_PORT=5820 \
      -v /dev/shm:/dev/shm elgalu/selenium:2.51.0a

And another

    docker run -d --name=node2 --net=container:grid \
      -e DISP_N=30 -e SSHD_PORT=22230 \
      -e SUPERVISOR_HTTP_PORT=29030 \
      -e SELENIUM_NODE_CH_PORT=25030 -e SELENIUM_NODE_FF_PORT=26030 \
      -e GRID=false -e CHROME=true -e FIREFOX=true \
      -e VNC_PASSWORD=hola -e VNC_PORT=5830 \
      -v /dev/shm:/dev/shm elgalu/selenium:2.51.0a
