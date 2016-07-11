# Compose
Scale up and down the nodes by using [docker-compose](https://docs.docker.com/compose/).

For using it by sharing the host (localhost) network interface see [share-host](./share-host.md)

For requirements check [README#requisites](../README.md#requisites)

## Usage
Either clone this repository or download the file [docker-compose.yml][] using `wget`

    wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/master/docker-compose.yml"
    docker-compose -p selenium down #ensure is not already running

### Run
Start it with `docker-compose up` then **scale** it:
You should replace `adwords_mock` with your web service under test within the [docker-compose.yml][] file.

    export SELENIUM_HUB_PORT=4444 NODES=3
    docker-compose -p selenium up -d
    docker-compose -p selenium scale chrome=${NODES} firefox=${NODES}

Wait until the grid starts properly before starting the tests _(Optional but recommended)_

    docker exec selenium_hub_1 wait_all_done 30s
    for ((i=1; i<=${NODES}; i++)); do
      docker-compose -p selenium exec -T --index=$i chrome wait_all_done 30s
      docker-compose -p selenium exec -T --index=$i firefox wait_all_done 30s
    done

### Test
You can now run your tests by using the `--seleniumUrl="http://localhost:4444/wd/hub"`.

However if your web application under test is running in localhost, e.g. `--appHost=localhost` or is publicly not accessible
you should instead either dockerize your application as shown in the example [adwords_mock](https://github.com/elgalu/google_adwords_mock) within the [docker-compose.yml][]. Its there shown as another [service](https://docs.docker.com/compose/compose-file/#/service-configuration-reference). Another option (if you don't want to dockerize your app yet) is to somehow replace `--appHost=localhost` with `--appHost=d.host.loc.dev` in the config file of your testing framework. The string `d.host.loc.dev` is a place holder inside the docker container that points to the IP of your localhost.

### Cleanup
Once your tests are done you can clean up:

    docker-compose -p selenium down

The `down` compose command stops and remove containers, networks, volumes, and images created by `up` or `scale`

[docker-compose.yml]: ../docker-compose.yml
