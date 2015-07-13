# Changelog

Note sha256 digests are generated after pushing the image to the registry therefore the last version of this docker-selenium will always have digest TBD (to be determined) but will be updated manually at [releases][]

Note image ids also change after scm-source.json has being updated which triggers a cyclic problem so value TBD will be set here and updated in the [release][] page by navigating into any release tag.

## v2.46.0-sup (2015-07-13)
 + Switched to supervidord for process management, closes #24 (Leo Gallucci)
 + Extracted guacamole (with tomcat) into elgalu/guaca-docker.
 + Refactored code and directory structure.
 + Renamed SSH_PUB_KEY to SSH_AUTH_KEYS to reflect the true meaning.
 + Fixed scm-source date validation.
 + Moved all ports above 2k to mitigate changes of ssh -R port conflicts
 + IMPORTANT: Breaking changes in this release, read the docs again.
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
  + Chrome: 43.0.2357.132
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 39.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.0, build 0baf609
  + Python: 2.7.10
  + Digest: sha256:TBD
  + Image ID: TBD

## v2.46.0-ff39 (2015-07-08)
 + Upgrade Firefox from 38.0.5 to 39.0 and Chrome patch level from 130 to 132  (Leo Gallucci)
 + Minor improvement to mozdownload and mozInstall for Firefox download
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
  + Chrome: 43.0.2357.132
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 39.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.0, build 0baf609
  + Python: 2.7.9
  + Digest: sha256:311e42f1253868dd10208e4153b2a9419dadf8e6ce4ef31cbf200604ac9e22b8
  + Image ID: 9a8d735a5e1ed22728426fb5cdd696215f382c74487f9616cfa3b67f31e735dc

## v2.46.0-x11 (2015-06-24)
 + Ability to pass extra params to the selenium server via SELENIUM_PARAMS (Rogov Viktor)
 + Allow to set -e XE_DISP_NUM so X11 can be redirect to the host (Leo Gallucci)
 + Add README note on how to use Xephyr to redirect X to the docker host
 + Upgrade from ubuntu:vivid-20150528 to ubuntu:vivid-20150611
 + Upgrade guacamole from 0.9.6 to 0.9.7
 + Start using pip-based alternate script to get more up-to-date Firefox version
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
  + Chrome: 43.0.2357.130
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 38.0.5
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.0, build 0baf609
  + Python: 2.7.9
  + Digest: sha256:8d67d3d15dfd449e94433de46c352ff135f38678ebd6e217b613e7f1770d5490
  + Image ID: 247b69cbd53ef323b117362fd8bb7510276c5e9a702d15e8573223b0467538fb

## v2.46.0-base1 (2015-06-09)
 + Upgrade selenium from 2.45.0 to 2.46.0
 + Upgrade chromedriver from 2.15 to 2.16
 + Add Xdummy (Xorg config) driver as an alternative to Xvfb (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
  + Chrome: 43.0.2357.124
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 38.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:dc7568c79355b6bde63706165b07f3c22e64e5749e12ab3591e5160776e09b1b
  + Image ID: 4f827cfc7317413d2e73ef17c6da6216f92d60d080b70fffc15058543e820b93

## v2.45.0-oracle1 (2015-06-04)
 + Include urandom fix that hangs selenium start up (Matthew Smith)
 + Switch to Oracle Java 8 to test it out (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:e7698b35ca2bbf51caed32ffbc26d1a653ba4a4d26adbbbaab98fb5d02f92fbf
  + Image ID: fcaf12794d4311ae5c511cbc5ebc500ff01782b4eac18fe28f994557ebb401fe

## v2.45.0-ssh4 (2015-06-04)
 + Add option to disable wait for selenium to start (Leo Gallucci)
 + Add jq tool for json querying (Leo Gallucci)
 + Make possible to docker run -v /var/run/docker.sock (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:def2d462d0224382c8ac5709ee2b468287d88e6973eb14089925631db8065fbd
  + Image ID: 34cffc685e12a021b720c2ea19fe1a48c7d438c129f7859bbae43473e4afc95a

## v2.45.0-ssh3 (2015-06-03)
 + Upgrade Ubuntu from vivid-20150427 to vivid-20150528 (Leo Gallucci)
 + Document how to use this docker image securely via sha256 and image ids (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:4f9d0d50a1f2f13c3b5fbbe19792dc826d0eb177f87384a9536418e26a6333c5
  + Image ID: 7edb56ee8ec7aaa6e8e95cc762a80392b662aa75a3c45e97868ad5018f710dc2

## v2.45.0-ssh2 (2015-05-27)
 + Make ssh server optional and default to true (Leo Gallucci)
 + Allow -e TOMCAT_PORT to be changed from new default port 8484 #15 (Leo Gallucci)
 + Stop exposing unsecure tcp ports (selenium, vnc, tomcat) and only expose sshd (Leo Gallucci)
 + Document how to do tunneling in the secured container (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:b12e6710b7f8b44721f2c1248df2f41d57a0fb8586314651b126390e1721bf68
  + Image ID: 4b411d30788bbe0bb8e64eaf21af03250388e700d60e1064c93ef5499809ff73

## v2.45.0-ssh1 (2015-05-26)
 + Add sshd so can tunnel to test local apps remotely (Leo Gallucci)
 + Add guacamole server (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:023e36054783629a1d36f74c2abc70f281041aa9f830e13ed8ec79e215f433f5
  + Image ID: 92400bcf07af7fee256c782596aaa65c7f66d41508ce729a8b1cb6a7b72ef05f

## v2.45.0-openbox1 (2015-05-22)
 + Send selenium output to stdout so can be picked up by docker logs (Leo Gallucci)
 + Added this file: CHANGELOG.md (Leo Gallucci)
 + No matter what always use non-root user "application" (Leo Gallucci)
 + Switching to openjdk-8-jre-headless (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.65
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:bc374296275ad125848a4ba11c052f30efd99dd7ebdc1d1a21e2a92c1245b186

## v2.45.0-berlin5 (2015-05-08)
 + Make image resilient to docker run -u UID or Username (Leo Gallucci)
 + Allow internal container VNC_PORT to be changed at run time (Leo Gallucci)
 + Generate random VNC password when no VNC_PASSWORD supplied (default) (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 42.0.2311.135
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 37.0.2
  + Java: 1.7.0_79 OpenJDK 7u79-2.5.5-0ubuntu1
  + Timezone: Europe/Berlin

## v2.45.0-berlin2 (2015-05-07)
 + Bump vivid (Leo Gallucci)
 + Added active waits and removed sleeps (Leo Gallucci)
 + Allow VNC password to be set via env var (Leo Gallucci)

## v2.45.0-berlin (2015-04-28)
 + Upgrade to selenium v2.44.0 (Leo Gallucci)
 + Upgrade chromedriver to always use LATEST, current 2.14 (Leo Gallucci)
 + Stops using root for selenium and vnc access (Leo Gallucci)
 + Upgrade Ubuntu from 14.04 (trusty) to 15.04 (vivid) (Leo Gallucci)
 + Switch timezone from US/Pacific to Europe/Berlin (Leo Gallucci)
 + Switched from Fluxbox to Openbox to allow copy-paste to work with VNC (Leo Gallucci)
 + Including selenium logs in stdout (Matthew Smith)
 + No need to expose port 5555 (Leo Gallucci)
 + Removed the need to set --no-sandbox for Chrome (Matthew Smith)

## v2.44.0 (2014-11-02) - alpha
 + Upgrade to selenium v2.44.0 (Leo Gallucci)
 + Upgrade chromedriver to 2.12 (Leo Gallucci)

## v2.43.1 (2014-09-25) - alpha
 + Upgrade to selenium v2.43.1 (Leo Gallucci)
 + Upgrade chromedriver to 2.10 (Leo Gallucci)
 + /etc/hosts hack no longer necessary since docker >= 1.2.0 (Leo Gallucci)
 + Specify exact base image from ubuntu:14.04 to ubuntu:14.04.1 (Leo Gallucci)

## v2.42.2 (2014-07-11) - alpha
 + Initial working version (Leo Gallucci)


[releases]: https://github.com/elgalu/docker-selenium/releases/
