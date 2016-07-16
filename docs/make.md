# Make

## Setup
You should replace `mock` with your web service under test within the generated [docker-compose.yml][] file.

    wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/Makefile"
    make setup #first time

## Usage
Make sure to [setup](#setup) first.

### Run
Run spceifying how many nodes you need to run your tests, hopefully in parallel.

    make chrome=5 firefox=4

### VNC
This will open the VNC viewer.

    make see browser=chrome node=1
    make see browser=firefox node=1

### Test
The best way is to run your tests inside your web application under test, in this case is called `mock`

    docker exec -t grid_mock_1 \
      npm test --seleniumUrl="http://localhost:4444/wd/hub"

### Cleanup
When done, is convenient to shutdown all the containers.

    make cleanup


[docker-compose.yml]: ../docker-compose.yml
