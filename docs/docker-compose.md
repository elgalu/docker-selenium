# Compose
Scale up and down the nodes by using [docker-compose](https://docs.docker.com/compose/). Install the tooling by following that link and make sure you have latest stable versions of both tools, docker and docker-compose:

    docker --version         #=> 1.11.2
    docker-compose --version #=> 1.7.1

## Usage
Either clone this repository or download the file [docker-compose.yml](../docker-compose.yml) using `wget`

    wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/master/docker-compose.yml"

### Run
Either start with `docker-compose ... scale` as shown in below example or you can also use `docker-compose up` and scale after in a second command.

    SELENIUM_HUB_PORT=4444 docker-compose -p selenium scale hub=1 chrome=3 firefox=3

Wait until the grid starts properly before starting the tests _(Optional but recommended)_

    docker-compose -p selenium exec -T --index=3 chrome wait_all_done 30s

### Cleanup
The `down` compose command stops and remove containers, networks, volumes, and images created by `up` or `scale`

    docker-compose -p selenium down
