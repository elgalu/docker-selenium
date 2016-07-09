# Share the host
Scale up and down the nodes locally in Linux by using sharing the host (localhost) network interface [docker-compose](https://docs.docker.com/compose/).

For using it non-Linux machines or, in general, by not sharing the host (localhost) network interface see [docker-compose](./docker-compose.md)

For requirements check [README#requisites](../README.md#requisites)

## Usage
Either clone this repository or download the file [docker-compose-host.yml](../docker-compose-host.yml) using `wget`

    wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/master/docker-compose-host.yml"
    mv -f docker-compose-host.yml docker-compose.yml
    docker-compose -p selenium down #ensure is not already running

### Run
Either start with `docker-compose ... scale` as shown in below example or you can also use `docker-compose up` and scale after in a second command.

    export SELENIUM_HUB_PORT=4444 NODES=3
    docker-compose -p selenium scale hub=1 chrome=${NODES} firefox=${NODES}

Wait until the grid starts properly before starting the tests _(Optional but recommended)_

    docker exec selenium_hub_1 wait_all_done 30s
    for ((i=1; i<=${NODES}; i++)); do
      docker-compose -p selenium exec -T --index=$i chrome wait_all_done 30s
      docker-compose -p selenium exec -T --index=$i firefox wait_all_done 30s
    done

### Test
You can now run your tests by using the `--seleniumUrl="http://localhost:4444/wd/hub"`.
Because we use the `network_mode: host` feature everything will run in `localhost` so is transparent to use at a networking level and you don't need to worry about it just run test web application under test in localhost, a.k.a. `127.0.0.1`

### Cleanup
Once your tests are done you can clean up:

    docker-compose -p selenium down

The `down` compose command stops and remove containers, networks, volumes, and images created by `up` or `scale`
