# Docker repo to spawn selenium standalone servers with Chrome and Firefox with VNC support
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/elgalu/docker-selenium?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

* selenium-server-standalone
* google-chrome-stable
* firefox (stable)
* VNC access (useful for debugging the container)
* openbox (lightweight window manager using freedesktop standards)

## Note this repo evolved into SeleniumHQ/docker-selenium
See: https://github.com/SeleniumHQ/docker-selenium

Note SeleniumHQ/docker-selenium project is more useful for building selenium grids while this one focuses on building disposable standalone selenium servers that you should `docker stop` as soon as your tests finishes. It also focuses on debugging via VNC which can be difficult on a Selenium Grid given you can't know in advance in which node will your test end up running and therefore can't know to which node to connect via VNC to actually see the test running.

### One-liner Install & Usage

In general: add `sudo` only if needed in your environment and `--privileged` if you really need it.

    sudo docker run --privileged -p 4444:4444 -p 5900:5900 -e VNC_PASSWORD=hola elgalu/selenium:v2.45.0-oracle1

### Non-privileged

If your setup is correct, privileged mode and sudo should not be necessary:

    docker run --rm --name=ch -p=0.0.0.0:8484:8484 -p=0.0.0.0:2222:2222 \
                              -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 \
        -e SCREEN_WIDTH=1920 -e SCREEN_HEIGHT=1080 \
        -e VNC_PASSWORD=hola -e WITH_GUACAMOLE=false \
        -e SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" \
        elgalu/selenium:v2.45.0-oracle1

Make sure `docker run` finishes with **start.sh all done and ready for testing** else you won't be able to start your tests.
Selenium should be up and running at http://localhost:4470/wd/hub open the web page to confirm is running.

If using option `WITH_GUACAMOLE=true` you can open a browser into http://localhost:8484/#/login/ and login to guacamole with user "docker" and the same password as ${VNC_PASSWORD} so you no longer need a VNC client to debug the docker instance. Else you can simply connect to vnc://localhost:5920 using a VNC client or Safari Browser.

You can also ssh into the machine as long as `SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)"` is correct.

    ssh -p 2222 -o StrictHostKeyChecking=no application@localhost

That's is useful for tunneling else you can stick with `docker exec` to get into the instance with a shell:

    docker exec -ti ch bash

## Security

### Option 1 - Use immutable image digests
Given docker.io currently allows to push the same tag image twice this represent a security concern but since docker >= 1.6.2 is possible to fetch the digest sha256 instead of the tag so you can be sure you're using the exact same docker image every time:

    # e.g. sha256 for tag v2.45.0-oracle1
    export SHA=e7698b35ca2bbf51caed32ffbc26d1a653ba4a4d26adbbbaab98fb5d02f92fbf
    docker pull elgalu/selenium@sha256:${SHA}

### Option 2 - Check the Full Image Id

Verify that image id is indeed correct

    # e.g. full image id for tag v2.45.0-oracle1
    export IMGID=fcaf12794d4311ae5c511cbc5ebc500ff01782b4eac18fe28f994557ebb401fe
    if docker inspect -f='{{.Id}}' elgalu/selenium:v2.45.0-oracle1 |grep ${IMGID} &> /dev/null; then
        echo "Image ID tested ok"
    else
        echo "Image ID doesn't match"
    fi

You can find all digests sha256 and image ids per tag in the [CHANGELOG](./CHANGELOG.md) so as of now you just need to trust the sha256 in the CHANGELOG. Bullet proof is to fork this project and build the images yourself if security is a big concern.

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
CONTAINER=$(docker run -d -p=0.0.0.0:${ANYPORT}:2222 -p=0.0.0.0:${ANYPORT}:4444 \
    -p=0.0.0.0:${ANYPORT}:5900 -e SCREEN_HEIGHT=1110 -e VNC_PASSWORD=hola \
    -e SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" elgalu/selenium:v2.45.0-oracle1

# -- Option 2.docker run- Running docker on remote docker server like in the cloud
# Useful if the docker server is running in the cloud. Establish free local ports
REMOTE_DOCKER_SRV=some.docker.server.com
ssh ${REMOTE_DOCKER_SRV} #get into the remote docker provider somehow
# Note in remote server I'm using authorized_keys instead of id_rsa.pub given
# it acts as a jump host so my public key is already on that server
CONTAINER=$(docker run -d -p=0.0.0.0:${ANYPORT}:2222 -e SCREEN_HEIGHT=1110 \
    -e VNC_PASSWORD=hola -e SSH_PUB_KEY="$(cat ~/.ssh/authorized_keys)" \
    elgalu/selenium:v2.45.0-oracle1

# -- Common: Wait for the container to start
while ! docker logs ${CONTAINER} 2>&1 | grep \
    "start.sh all done" >/dev/null; do sleep 0.2; done
json_filter='{{(index (index .NetworkSettings.Ports "2222/tcp") 0).HostPort}}'
SSHD_PORT=$(docker inspect -f='${json_filter}' $CONTAINER)
echo $SSHD_PORT #=> e.g. SSHD_PORT=32769

# -- Option 1. Obtain dynamic values like container IP and assigned free ports
json_filter='{{(index (index .NetworkSettings.Ports "4444/tcp") 0).HostPort}}'
FREE_SELE_PORT=$(docker inspect -f='${json_filter}' $CONTAINER)
json_filter='{{(index (index .NetworkSettings.Ports "5900/tcp") 0).HostPort}}'
FREE_VNC_PORT=$(docker inspect -f='${json_filter}' $CONTAINER)

# -- Option 2. Get some free ports in current local machine. Needs python.
# IMPORTANT: Go back to development machine
FREE_SELE_PORT=$(python -c 'import socket; s=socket.socket(); \
    s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
FREE_VNC_PORT=$(python -c 'import socket; s=socket.socket(); \
    s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
# -- Option 2. Tunneling selenium+vnc is necessary if using a remote docker
ssh ${TUNLOCOPTS} localhost:${FREE_SELE_PORT}:localhost:4444 \
    -p ${SSHD_PORT} application@${REMOTE_DOCKER_SRV} &
LOC_TUN_SELE_PID=$!
ssh ${TUNLOCOPTS} localhost:${FREE_VNC_PORT}:localhost:5900 \
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

### Step by step build

#### 1. Build this image

If you git clone this repo locally, i.e. cd into where the Dockerfile is, you can:

    docker build -t="elgalu/docker-selenium:local" .

If you prefer to download the final built image from docker you can pull it, personally I always prefer to build them manually except for the base images like Ubuntu 14.04.2:

    docker pull elgalu/selenium:v2.45.0-oracle1

#### 2. Use this image

##### e.g. Spawn a container for Chrome testing:

    CH=$(docker run --rm --name=ch -p=127.0.0.1::4444 -p=127.0.0.1::5900 \
        -v /e2e/uploads:/e2e/uploads elgalu/docker-selenium:local)

Note `-v /e2e/uploads:/e2e/uploads` is optional in case you are testing browser uploads on your webapp you'll probably need to share a directory for this.

The `127.0.0.1::` part is to avoid binding to all network interfaces, most of the time you don't need to expose the docker container like that so just *localhost* for now.

I like to remove the containers after each e2e test with `--rm` since this docker container is not meant to preserve state, spawning a new one is less than 3 seconds. You need to think of your docker container as processes, not as running virtual machines if case you are familiar with vagrant.

A dynamic port will be binded to the container ones, i.e.

    # Obtain the selenium port you'll connect to:
    docker port $CH 4444
    #=> 127.0.0.1:49155

    # Obtain the VNC server port in case you want to look around
    docker port $CH 5900
    #=> 127.0.0.1:49160

In case you have RealVNC binary `vnc` in your path, you can always take a look, view only to avoid messing around your tests with an unintended mouse click or keyboard.

    ./bin/vncview.sh 127.0.0.1:49160

##### e.g. Spawn a container for Firefox testing:

This command line is the same as for Chrome, remember that the selenium running container is able to launch either Chrome or Firefox, the idea around having 2 separate containers, one for each browser is for convenience plus avoid certain `:focus` issues you web app may encounter during e2e automation.

    FF=$(docker run --rm --name=ff -p=127.0.0.1::4444 -p=127.0.0.1::5900 \
        -v /e2e/uploads:/e2e/uploads elgalu/docker-selenium:local)

##### Look around

    docker images
    #=>

    REPOSITORY               TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    elgalu/docker-selenium   local               eab41ff50f72        About an hour ago   931.1 MB
    ubuntu                   14.04.2             d0955f21bf24        4 weeks ago         188.3 MB

### Troubleshooting

All output is sent to stdout so it can be inspected by running:

``` bash
$ docker logs -f <container-id|container-name>
```

Container leaves a few logs files to see what happened:

    /tmp/Xvfb_headless.log
    /tmp/xmanager.log
    /tmp/x11vnc_forever.log
    /tmp/local-sel-headless.log
    /tmp/selenium-server-standalone.log
