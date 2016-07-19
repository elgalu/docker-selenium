# Make

## Setup
This is only necessary the first time:

    wget -nv https://git.io/vKrBP -O Makefile
    make get setup

If you want VNC helpers support _(optional)_

    make install_vnc

You should now replace the `mock` example service with your web service under test within the generated [docker-compose.yml][] file.

### OSX
In OSX is convenient to increase the Docker service CPUs and Memory specially if you plan to run more than one Chrome and Firefox at the same time:

<img id="cpu" width="260" src="../images/Docker_Mac_CPUs_Memory.png" />

## Usage
Make sure to [setup](#setup) first.

### Run
Run specifying how many nodes you need to run your tests.

    make chrome=2 firefox=2

The idea of having *N* Chrome nodes and *N* Firefox nodes is to be able to run tests in parallel. Note *N* is `2` in this arbitrary example.

### VNC
This will open the VNC viewer.

    make see browser=chrome node=1
    make see browser=firefox node=1

### Test
The best way is to run your tests inside your web application under test, in this case is called `mock`

    docker exec -t grid_mock_1 \
      npm test --seleniumUrl="http://localhost:4444/wd/hub"

### Videos
Gather the videos artifacts easily

    export chrome=2 firefox=2
    make videos

### Cleanup
When done, is convenient to shutdown all the containers.

    make down

## Update
To update latest version of this docker image either `docker pull elgalu/selenium` or simply:

    make pull

Every now and then you will want to upgrade the script files [.env](../.env), [docker-compose.yml][], [mk/](../mk) and so on.
But given the upgrades are destructive is better to git clone this repository and do `git pull` from time to time.
If you make changes to these config files locally git will advise how to merge latest changes and you will be safe of losing your customizations.

### Git setup
    git clone https://github.com/elgalu/docker-selenium.git

### Git upgrades
    git pull
    make pull

[docker-compose.yml]: ../docker-compose.yml
