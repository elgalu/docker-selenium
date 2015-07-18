# Docker repo to spawn selenium standalone servers with Chrome and Firefox with VNC support
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/elgalu/docker-selenium?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

* selenium-server-standalone
* google-chrome-stable
* google-chrome-beta
* google-chrome-unstable
* firefox stable latest 15 versions
* VNC access (useful for debugging the container)
* openbox (lightweight window manager using freedesktop standards)

## Note this repo evolved into SeleniumHQ/docker-selenium
See: https://github.com/SeleniumHQ/docker-selenium

Note SeleniumHQ/docker-selenium project is more useful for building selenium grids while this one focuses on building disposable standalone selenium servers that you should `docker stop` as soon as your tests finishes. It also focuses on debugging via VNC which can be difficult on a Selenium Grid given you can't know in advance in which node will your test end up running and therefore can't know to which node to connect via VNC to actually see the test running.

### One-liner Install & Usage

In general: add `sudo` only if needed in your environment and `--privileged` if you really need it.

    sudo docker run --privileged -p 4444:24444 -p 5920:25900 \
        -e VNC_PASSWORD=hola elgalu/selenium:v2.46.0-03

### Non-privileged
### Run

If your setup is correct, privileged mode and sudo should not be necessary:

    docker run --rm --name=ch -p=0.0.0.0:4470:24444 -p=0.0.0.0:5920:25900 \
                              -p=0.0.0.0:2222:22222 -p=0.0.0.0:6080:26080 \
        -e SCREEN_WIDTH=1920 -e SCREEN_HEIGHT=1080 \
        -e VNC_PASSWORD=hola \
        -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
        elgalu/selenium:v2.46.0-03

Make sure `docker run` finishes with **selenium all done and ready for testing** else you won't be able to start your tests. To perform this check programatically please use this command where `ch` is the name of the container:

    while ! docker exec ch grep 'all done and ready for testing' /var/log/sele/xterm-stdout.log > /dev/null 2>&1; do sleep 0.2; done

Selenium should be up and running at http://localhost:4470/wd/hub open the web page to confirm is running.

You can also ssh into the machine as long as `SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)"` is correct.

    ssh -p 2222 -o StrictHostKeyChecking=no application@localhost

Include `-X` in ssh command if you want to redirect the started GUI programs to your host, e.g.

    ssh -X -p 2222 -o StrictHostKeyChecking=no application@localhost
    echo $DISPLAY #=> localhost:10.0

That's is useful for tunneling else you can stick with `docker exec` to get into the instance with a shell:

    docker exec -ti ch bash

Supervisor exposes an http server but is not enough to bind the ports via `docker run -p` so in this case you need to FWD ports with `ssh -L`

    ssh -p 2222 -o StrictHostKeyChecking=no -L localhost:29001:localhost:29001 application@localhost

### Chrome flavor

To configure which Chrome flavor (stable, beta, unstable) you want to use just pass for example `-e CHROME_FLAVOR=beta` to `docker run`. Default is `stable`.

### Firefox version

To configure which Firefox version to use first check available versions in the [CHANGELOG](./CHANGELOG.md) then pass for example `-e FIREFOX_VERSION=38.0.6` to `docker run`. Default is the latest number of the available list.

### Record Videos

If you create the container with `-e VIDEO=true` it will start recording a video through the vnc connection run upon start but first create a local folder `videos` in your current directory and mount the videos directory for an easy transfer with `-v $(pwd)/videos:/videos`

Once your tests are done you can either manually stop the recording via `docker exec ch stop-video` where *ch* is just the arbitrary container chosen name in `docker run` command. Or simply stop the container and that will stop the video recording automatically.

Relevant environment variables to customize it are:

    FFMPEG_FRAME_RATE=30
    VIDEO_FILE_NAME="test"
    VIDEO_FILE_EXTENSION="mkv"
    FFMPEG_CODEC_ARGS=""

### noVNC

We are now using https://github.com/kanaka/noVNC instead of guacamole so you can open a browser at [localhost:6080](http://localhost:6080/vnc.html) if you don't want to use your own vnc client. Note Safari Browser comes with a built-in one, just navigate to vnc://localhost:5920

If the VNC password was randomly generated find out with

    docker exec ch grep "was generated for you:" /var/log/sele/vnc-stdout.log
    #=> a VNC password was generated for you: ooGhai0aesaesh

## Grid
## Hub

You can lunch a grid only container via environment variables:

    docker run --rm --name=hub -p 4444:24444 -p 5930:25900 -p 2223:22222 \
      -p=6081:26080 -e CHROME=false -e FIREFOX=false \
      elgalu/selenium:v2.46.0-03

The important part above is `-e CHROME=false -e FIREFOX=false` which tells the docker image not run run default chorme and firefox nodes turning the container into a grid-only one.

## Node

You can lunch a node only container via environment variables:

    docker run --rm --name=node -p=5940:25900 -p=2224:22222 -p=6082:26080 \
      -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" -e VIDEO=true \
      -e SELENIUM_HUB_HOST=10.161.128.170 \
      -e SELENIUM_HUB_PORT=4444 \
      -e SELENIUM_NODE_HOST=10.161.131.6 \
      -p 25550:25550 -p 25551:25551 \
      -e GRID=false -e CHROME=true -e FIREFOX=true \
      -v $(pwd)/videos:/videos \
      elgalu/selenium:v2.46.0-03

The important part above is `-e GRID=false` which tells the container to be a node-only node, this this case with 2 browsers `-e CHROME=true -e FIREFOX=true` but could be just 1.

## Security

A file [scm-source.json](./scm-source.json) is included at the root directory of the generated image with information that helps to comply with auditing requirements to trace the creation of this docker image.

Note [scm-source.json](./scm-source.json) file will always be 1 commit outdated in the repo but will be correct inside the container.

This is how the file looks like:

```
cat scm-source.json #=> { "url": "https://github.com/elgalu/docker-selenium",
                          "revision": "8d2e03d8b4c45c72e0c73481d5141850d54122fe",
                          "author": "lgallucci",
                          "status": "" }
```

There are also additional steps you can take to ensure you're using the correct image:

### Option 1 - Use immutable image digests
Given docker.io currently allows to push the same tag image twice this represent a security concern but since docker >= 1.6.2 is possible to fetch the digest sha256 instead of the tag so you can be sure you're using the exact same docker image every time:

    # e.g. sha256 for tag v2.46.0-03
    export SHA=TBD
    docker pull elgalu/selenium@sha256:${SHA}

### Option 2 - Check the Full Image Id

Verify that image id is indeed correct

    # e.g. full image id for tag v2.46.0-03
    export IMGID=TBD
    if docker inspect -f='{{.Id}}' elgalu/selenium:v2.46.0-03 |grep ${IMGID} &> /dev/null; then
        echo "Image ID tested ok"
    else
        echo "Image ID doesn't match"
    fi

You can find all digests sha256 and image ids per tag in the [CHANGELOG](./CHANGELOG.md) so as of now you just need to trust the sha256 in the CHANGELOG. Bullet proof is to fork this project and build the images yourself if security is a big concern.

### Using Xephyr to redirect X to the docker host
Note the below method gives full access to the docker container to the host machine.
Host machine, terminal 1:

    sudo apt-get install xserver-xephyr
    export XE_DISP_NUM=12 SCREEN_WIDTH=2000 SCREEN_HEIGHT=1500
    Xephyr -ac -br -noreset -resizeable \
        -screen ${SCREEN_WIDTH}x${SCREEN_HEIGHT} :${XE_DISP_NUM}

Host machine, terminal 2:

    docker run --rm --name=ch -p=4470:24444 \
      -e SCREEN_WIDTH -e SCREEN_HEIGHT -e XE_DISP_NUM \
      -v /tmp/.X11-unix/X${XE_DISP_NUM}:/tmp/.X11-unix/X${XE_DISP_NUM} \
      elgalu/selenium:v2.46.0-03

Now when you run your tests instead of connecting. If docker run fails try `xhost +`

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
    -e SSH_AUTH_KEYS="$(cat ~/.ssh/id_rsa.pub)" elgalu/selenium:v2.46.0-03

# -- Option 2.docker run- Running docker on remote docker server like in the cloud
# Useful if the docker server is running in the cloud. Establish free local ports
REMOTE_DOCKER_SRV=some.docker.server.com
ssh ${REMOTE_DOCKER_SRV} #get into the remote docker provider somehow
# Note in remote server I'm using authorized_keys instead of id_rsa.pub given
# it acts as a jump host so my public key is already on that server
CONTAINER=$(docker run -d -p=0.0.0.0:${ANYPORT}:22222 -e SCREEN_HEIGHT=1110 \
    -e VNC_PASSWORD=hola -e SSH_AUTH_KEYS="$(cat ~/.ssh/authorized_keys)" \
    elgalu/selenium:v2.46.0-03

# -- Common: Wait for the container to start
./host-scripts/wait-docker-selenium.sh ch 7s
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

### Step by step build

#### 1. Build this image

If you git clone this repo locally, i.e. cd into where the Dockerfile is, you can:

    docker build -t="elgalu/docker-selenium:local" .

If you prefer to download the final built image from docker you can pull it, personally I always prefer to build them manually except for the base images like Ubuntu 14.04.2:

    docker pull elgalu/selenium:v2.46.0-03

#### 2. Use this image

##### e.g. Spawn a container for Chrome testing:

    CH=$(docker run --rm --name=ch -p=127.0.0.1::24444 -p=127.0.0.1::25900 \
        -v /e2e/uploads:/e2e/uploads elgalu/docker-selenium:local)

Note `-v /e2e/uploads:/e2e/uploads` is optional in case you are testing browser uploads on your webapp you'll probably need to share a directory for this.

The `127.0.0.1::` part is to avoid binding to all network interfaces, most of the time you don't need to expose the docker container like that so just *localhost* for now.

I like to remove the containers after each e2e test with `--rm` since this docker container is not meant to preserve state, spawning a new one is less than 3 seconds. You need to think of your docker container as processes, not as running virtual machines if case you are familiar with vagrant.

A dynamic port will be binded to the container ones, i.e.

    # Obtain the selenium port you'll connect to:
    docker port $CH 4444
    #=> 127.0.0.1:49155

    # Obtain the VNC server port in case you want to look around
    docker port $CH 25900
    #=> 127.0.0.1:49160

In case you have RealVNC binary `vnc` in your path, you can always take a look, view only to avoid messing around your tests with an unintended mouse click or keyboard.

    ./bin/vncview.sh 127.0.0.1:49160

##### e.g. Spawn a container for Firefox testing:

This command line is the same as for Chrome, remember that the selenium running container is able to launch either Chrome or Firefox, the idea around having 2 separate containers, one for each browser is for convenience plus avoid certain `:focus` issues you web app may encounter during e2e automation.

    FF=$(docker run --rm --name=ff -p=127.0.0.1::24444 -p=127.0.0.1::25900 \
        -v /e2e/uploads:/e2e/uploads elgalu/docker-selenium:local)

##### How to get docker internal IP through logs

    CONTAINER_IP=$(docker logs sele10 2>&1 | grep "Container docker internal IP: " | sed -e 's/.*IP: //' -e 's/<.*$//')
    echo ${CONTAINER_IP} #=> 172.17.0.34

##### Look around

    docker images
    #=>

    REPOSITORY               TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    elgalu/docker-selenium   local               eab41ff50f72        About an hour ago   931.1 MB
    ubuntu                   14.04.2             d0955f21bf24        4 weeks ago         188.3 MB

### Who is using docker-selenium?

    * [Shoov](http://www.gizra.com/content/phantomjs-chrome-docker-selenium-standalone/)

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
