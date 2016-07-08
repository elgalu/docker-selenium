# Compose
Scale up and down the nodes by using [docker-compose](https://docs.docker.com/compose/).
For requirements check [docker-compose#requisites](./docker-compose.md#requisites)

## Usage
Either clone this repository or download the file [docker-compose-host.yml](../docker-compose-host.yml) using `wget`

    wget -nv -O docker-compose.yml "https://raw.githubusercontent.com/elgalu/docker-selenium/master/docker-compose-host.yml"

### Run
Either start with `docker-compose ... scale` as shown in below example or you can also use `docker-compose up` and scale after in a second command.

    SELENIUM_HUB_PORT=4444 docker-compose -p selenium scale hub=1 chrome=3 firefox=3

Wait until the grid starts properly before starting the tests _(Optional but recommended)_

    docker-compose -p selenium exec -T --index=3 chrome wait_all_done 30s

### Cleanup
The `down` compose command stops and remove containers, networks, volumes, and images created by `up` or `scale`

    docker-compose -p selenium down
