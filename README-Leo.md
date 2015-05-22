## Build

    docker build -t="elgalu/selenium:v2.45.0-ssh1" . ;echo $?;beep

## Run with shared dir

    docker run --rm --name=ch -p=127.0.0.1:4460:4444 -p=127.0.0.1:5910:5900 -v /e2e/uploads:/e2e/uploads elgalu/selenium:v2.45.0-ssh1

    docker run --rm --name=ff -p=127.0.0.1:4461:4444 -p=127.0.0.1:5911:5900 -v /e2e/uploads:/e2e/uploads elgalu/selenium:v2.45.0-ssh1

## Run without shared dir and bind ports to all network interfaces

    docker run -d --name=ch -p=0.0.0.0:4444:4444 -p=0.0.0.0:5900:5900 elgalu/selenium:0.1

## Run without dir and bind to all interfaces
Note anything after the image will be taken as arguments for the cmd/entrypoint

    docker run --rm --name=ch -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 -e SCREEN_WIDTH=1800 -e SCREEN_HEIGHT=1110 -e VNC_PASSWORD=hola -e SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" elgalu/selenium:v2.45.0-ssh1
    docker run --rm --name=ch -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 registry.hub.docker.com/elgalu/selenium:v2.45.0-ssh1
    docker run --rm --name=ch -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 --add-host myserver.dev:172.17.42.1 elgalu/selenium:v2.45.0-ssh1

However adding a custom host IP to brands-selenium.dev is more work:

    ssh bsele
    sudo sh -c 'echo "10.161.128.36  myserver.dev" >> /etc/hosts'

    vncv localhost:5920 -Scaling=60%  &

    docker run --rm --name=ff -p=0.0.0.0:4471:4444 -p=0.0.0.0:5921:5900 elgalu/selenium:v2.45.0-ssh1

Automatic builds not working for me right now, maybe there is an issue with docker registry v1 vs v2
https://registry.hub.docker.com/u/elgalu/docker-selenium/builds_history/31621/

## Push version

    docker login
    docker push elgalu/selenium:v2.45.0-ssh1 ;echo $?;beep
    # doesn't work:
    docker push registry.hub.docker.com/elgalu/selenium:v2.45.0-ssh1

Another version

    docker tag elgalu/docker-selenium:v2.45.0-ssh1 elgalu/selenium:v2.45.0-ssh1
    docker push elgalu/selenium:v2.45.0-ssh1

Not working maybe because it has automated builds enabled but then it fails in the cloud but works locally
https://registry.hub.docker.com/u/elgalu/selenium/tags/manage/

    docker push elgalu/selenium:v2.45.0-ssh1
    docker push elgalu/docker-selenium:v2.45.0-ssh1
    docker push registry.hub.docker.com/elgalu/docker-selenium:v2.45.0-ssh1

## Pulling

    docker pull registry.hub.docker.com/elgalu/selenium:v2.45.0-ssh1

## Use pushed version

    docker run -d --name=anton  -p=0.0.0.0:4410:4444 -p=0.0.0.0:5910:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=max    -p=0.0.0.0:4411:4444 -p=0.0.0.0:5911:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=selina -p=0.0.0.0:4412:4444 -p=0.0.0.0:5912:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=leo    -p=0.0.0.0:4413:4444 -p=0.0.0.0:5913:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=michal -p=0.0.0.0:4414:4444 -p=0.0.0.0:5914:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=van    -p=0.0.0.0:4415:4444 -p=0.0.0.0:5915:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=nick   -p=0.0.0.0:4416:4444 -p=0.0.0.0:5916:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=slav   -p=0.0.0.0:4417:4444 -p=0.0.0.0:5917:5900 elgalu/selenium:v2.45.0-ssh1
    docker run -d --name=dima   -p=0.0.0.0:4418:4444 -p=0.0.0.0:5918:5900 elgalu/selenium:v2.45.0-ssh1

## Pull

    docker run -d --name=max -p=0.0.0.0:4411:4444 -p=0.0.0.0:5911:5900 elgalu/selenium:v2.45.0-ssh1

How to connect through vnc (need a vnc client)

    vnc-client.sh brands-selenium.local:{{vncPort}} -Scaling=60%  &

How to run ui:tests remotely on brands-selenium.local instead of your laptop.

    grunt ui:remote-test --browser=chrome --seleniumUrl="http://brands-selenium.local:{{seleniumPort}}/wd/hub" --appHost={{yourLaptopIPAddr}}

Note you may need to open firewall ports

    sudo ufw allow 3000
    sudo ufw allow 2525
    sudo ufw allow 4545

Check it works

    http://localhost:4470/wd/hub/static/resource/hub.html
