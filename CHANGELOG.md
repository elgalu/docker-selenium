# Changelog

## v2.45.0-oracle1 (2015-06-04)
 + Include urandom fix that hangs selenium start up (Matthew Smith)
 + Switch to Oracle Java 8 to test it out (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45 HotSpot(TM) 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:TBD
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
