# Changelog

## v2.45.0-ssh1 (in progress)
 + Add sshd so can tunnel to test local apps remotely (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.65
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: TBD

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

## v2.44.0 (2014-11-02)
 + Upgrade to selenium v2.44.0 (Leo Gallucci)
 + Upgrade chromedriver to 2.12 (Leo Gallucci)

## v2.43.1 (2014-09-25)
 + Upgrade to selenium v2.43.1 (Leo Gallucci)
 + Upgrade chromedriver to 2.10 (Leo Gallucci)
 + /etc/hosts hack no longer necessary since docker >= 1.2.0 (Leo Gallucci)
 + Specify exact base image from ubuntu:14.04 to ubuntu:14.04.1 (Leo Gallucci)

## v2.42.2 (2014-07-11)
 + Initial working version (Leo Gallucci)
