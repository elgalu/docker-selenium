# selenium-test [![Build Status](https://travis-ci.org/elgalu/selenium-test.svg?branch=master)](https://travis-ci.org/elgalu/selenium-test)

Hello world selenium test.

If you want to see this running inside a docker container visit [selenium-test-dockerized][] or scroll down to the *Docker* section.

## Requisistes
Add `sudo` only if you get permission denied.

    pip install --upgrade -r requirements.txt

It needs a selenium server, for example [docker-selenium][]

    docker run -d --name=myselenium elgalu/selenium:latest
    docker exec myselenium wait_all_done 30s
    export SELENIUM_HUB_HOST=$(docker inspect -f='{{.NetworkSettings.IPAddress}}' myselenium)
    export SELENIUM_HUB_PORT=24444

## Run

    python python_test.py

Sample output

    Will connect to selenium at http://172.17.0.6:24444/wd/hub
    Opening page http://www.google.com/adwords
    Current title: Google AdWords | Pay-per-Click-Onlinewerbung auf Google (PPC)
    Asserting 'Google Adwords' in driver.title
    Opening page http://www.python.org
    Asserting 'Python' in driver.title
    Finding element by name: q
    Sending keys 'pycon'
    Sending RETURN key
    Ensure no results were found
    Close driver and clean up
    All done. SUCCESS!

## Docker
### Build

    docker build -t elgalu/selenium-test .

### Run

    export SELENIUM_HUB_HOST=$(docker inspect -f='{{.NetworkSettings.IPAddress}}' myselenium)
    docker run --rm --name=test1 -ti -e SELENIUM_HUB_HOST elgalu/selenium-test


[selenium-test-dockerized]: https://github.com/elgalu/selenium-test-dockerized
[docker-selenium]: https://github.com/elgalu/docker-selenium
