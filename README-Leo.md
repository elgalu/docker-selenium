## Build

    docker build -t="elgalu/docker-selenium:flux" .

## Run with shared dir

    docker run --rm --name=ch -p=127.0.0.1:4460:4444 -p=127.0.0.1:5910:5900 -v /e2e/uploads:/e2e/uploads elgalu/docker-selenium:flux

    docker run --rm --name=ff -p=127.0.0.1:4461:4444 -p=127.0.0.1:5911:5900 -v /e2e/uploads:/e2e/uploads elgalu/docker-selenium:flux

## Run without dir and bind to all interfaces

    docker run --rm --name=ch -p=0.0.0.0:4470:4444 -p=0.0.0.0:5920:5900 elgalu/docker-selenium:flux

    vncv localhost:5920

    docker run --rm --name=ff -p=0.0.0.0:4471:4444 -p=0.0.0.0:5921:5900 elgalu/docker-selenium:flux
