## Build

    docker build -t="elgalu/selenium:v2.45.0-ssh3" . ;echo $?;beep

## Run with shared dir

    docker run --rm --name=ch -p=127.0.0.1:4460:4444 -p=127.0.0.1:5910:5900 -v /e2e/uploads:/e2e/uploads elgalu/selenium:v2.45.0-ssh3

    docker run --rm --name=ff -p=127.0.0.1:4461:4444 -p=127.0.0.1:5911:5900 -v /e2e/uploads:/e2e/uploads elgalu/selenium:v2.45.0-ssh3

## Run without shared dir and bind ports to all network interfaces

    docker run -d --name=ch -p=0.0.0.0:4444:4444 -p=0.0.0.0:5900:5900 elgalu/selenium:0.1

## Opening tunnels

    export SELE_INST_IP=172.17.17.17
    export SOPTS="-o StrictHostKeyChecking=no"
    export TUNLOCOPTS="-v -N $SOPTS -L"
    export TUNREVOPTS="-v -N $SOPTS -R"
    # to use selenium at localhost:
    ssh ${TUNLOCOPTS} localhost:4455:${SELE_INST_IP}:4444 -p 2222 application@${SELE_INST_IP}
    # to expose local ports 3000/2525/4545/4546 inside docker container
    ssh ${TUNREVOPTS} localhost:3000:localhost:3000 -p 2222 application@${SELE_INST_IP}
    ssh ${TUNREVOPTS} localhost:2525:localhost:2525 -p 2222 application@${SELE_INST_IP}
    ssh ${TUNREVOPTS} localhost:4545:localhost:4545 -p 2222 application@${SELE_INST_IP}
    ssh ${TUNREVOPTS} localhost:4546:localhost:4546 -p 2222 application@${SELE_INST_IP}

## Run without dir and bind to all interfaces
Note anything after the image will be taken as arguments for the cmd/entrypoint

    docker run --rm --name=ch -p=0.0.0.0:8813:8484 -p=0.0.0.0:2222:2222 -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 -e SCREEN_WIDTH=1800 -e SCREEN_HEIGHT=1110 -e VNC_PASSWORD=hola -e SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" -e WITH_GUACAMOLE=true elgalu/selenium:v2.45.0-ssh3

    docker run --rm --name=ch -p=4470:4444 -p=5920:5900 -e VNC_PASSWORD=hola elgalu/selenium:v2.45.0-ssh3
    docker run --rm --name=ch -p=4470:4444 -p=5920:5900 -e VNC_PASSWORD=hola elgalu/selenium@sha256:4f9d0d50a1f2f13c3b5fbbe19792dc826d0eb177f87384a9536418e26a6333c5
    docker run --rm --name=ch -p=4470:4444 -p=5920:5900 -e VNC_PASSWORD=hola docker.io/elgalu/selenium:v2.45.0-ssh3
    docker run --rm --name=ch -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 --add-host myserver.dev:172.17.42.1 elgalu/selenium:v2.45.0-ssh3

However adding a custom host IP to server-selenium.local (e.g. bsele ssh config) is more work:

    ssh bsele
    sudo sh -c 'echo "10.161.128.36  myserver.dev" >> /etc/hosts'

    vncv localhost:5920 -Scaling=60%  &

    docker run --rm --name=ff -p=0.0.0.0:4471:4444 -p=0.0.0.0:5921:5900 elgalu/selenium:v2.45.0-ssh3

Automatic builds not working for me right now, maybe there is an issue with docker registry v1 vs v2
https://registry.hub.docker.com/u/elgalu/docker-selenium/builds_history/31621/

## Push version

    docker login
    docker push docker.io/elgalu/selenium:v2.45.0-ssh3 ;echo $?;beep
    docker tag elgalu/selenium:v2.45.0-ssh3 elgalu/selenium:latest
    docker push docker.io/elgalu/selenium:latest

Not working maybe because it has automated builds enabled but then it fails in the cloud but works locally
https://registry.hub.docker.com/u/elgalu/selenium/tags/manage/

    docker push elgalu/selenium:v2.45.0-ssh3
    docker push elgalu/docker-selenium:v2.45.0-ssh3
    docker push docker.io/elgalu/docker-selenium:v2.45.0-ssh3

## Pulling

    docker pull registry.hub.docker.com/elgalu/selenium:v2.45.0-ssh3

## Pull

    docker run -d --name=max -p=0.0.0.0:4411:4444 -p=0.0.0.0:5911:5900 elgalu/selenium:v2.45.0-ssh3

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

## TODO: Fix:
> UnknownError: unknown error: session deleted because of page crash from tab crashed

 This only made pass a few tests but others keeps crashing the page:

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

## TODO R&D

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

## TODO docker NodeJS client for Protractor
https://github.com/apocas/dockerode#creating-a-container
https://github.com/apocas/dockerode/blob/master/examples/run_stdin.js
https://github.com/apocas/dockerode/blob/master/examples/external_volume.js#L14
https://github.com/apocas/dockerode/blob/master/test/docker.js#L182

### TODO A docker image that runs more dockers
https://www.happycloudsolutions.com.au/blog/amazon-container-service-preview-docker-on-aws/

#### TODO Taupage - understand policies
https://github.com/zalando/spilo/blob/master/etcd-cluster-appliance/etcd-cluster.yaml#L42
Report issue to enable configure reverse ssh tunneling options
https://github.com/zalando-stups/taupage/blob/master/runtime/opt/zalando/bin/configure-ssh
https://github.com/zalando-stups/taupage/blob/master/test-userdata.yaml
