# Changelog

Note sha256 digests are generated after pushing the image to the registry therefore the last version of this docker-selenium will always have digest TBD (to be determined) but will be updated manually at [releases][]

Note image ids also change after scm-source.json has being updated which triggers a cyclic problem so value TBD will be set here and updated in the [releases][] page by navigating into any release tag.

###### To get container versions
    docker exec grid versions

## 3.0.1-p1
 + Date: 2016-12-13
 + Upgrade Chrome patch to 55.0.2883.87
 + Chore: GA: Add screen resolution, depth and user language
 + Add Security.md
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  55.0.2883.87
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.26.436382 (70eb799287ce4c2208441fc057053a5b07ceabac)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161121
  + Python: 2.7.12
  + Sauce Connect 4.4.2, build 3154 c8dd102-dirty
  + BrowserStack Local version 6.7
  + Tested on kernel dev host: 4.4.0-53-generic x86_64
  + Tested on kernel CI  host: 4.4.0-51-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.4, build 1564f02
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.283 GB
  + Digest: sha256:0c1937b99cc16f5e39788750397ff92d378209006ef055d4008c74d7e61a399a
  + Image ID: sha256:3aa6cafec3be812067b4886b56344938648f2435a166f8bd8c0a0ead4e9c2930

## 3.0.1-p0
 + Date: 2016-12-12
 + Upgrade Chrome major to 55.0.2883.75 @seangerhardt-wf
 + Upgrade Chromedriver minor from 2.25 to 2.26
 + Chore: Add some images to upload at /home/seluser/images
 + Add Google Analytics anonymous usage statistics tracking see Analytics.md
 + Support restart docker container for selenium 3 @aituganov
 + Chore: Fix typo at PICK_ALL_RANDOM_PORTS
 + Upgrade BrowserStack minor to 6.7 (was 6.5)
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  55.0.2883.75
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.26.436382 (70eb799287ce4c2208441fc057053a5b07ceabac)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161121
  + Python: 2.7.12
  + Sauce Connect 4.4.2, build 3154 c8dd102-dirty
  + BrowserStack Local version 6.7
  + Tested on kernel dev host: 4.4.0-53-generic x86_64
  + Tested on kernel CI  host: 4.4.0-51-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.283 GB
  + Digest: sha256:1772b492320fe100d3fb9aaf613d37349e77e10c463a3e6667af51d0f24e7b87
  + Image ID: sha256:cd732e9af050904eb66d1725ed4e85fc368a8010e9a0ecb56bfe3d6c2d04289e

## 3.0.1j
 + Date: 2016-12-01
 + Upgrade Firefox patch to 50.0.2
 + Upgrade Ubuntu xenial date from 20161114 to 20161121
 + Upgrade Sauce Connect patch to 4.4.2 (was 4.4.1)
 + [#136] Remove saucelabs in /etc/hosts (#137)
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.100
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161121
  + Python: 2.7.12
  + Sauce Connect 4.4.2, build 3154 c8dd102-dirty
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-51-generic x86_64
  + Tested on kernel CI  host: 4.4.0-47-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.267 GB
  + Digest: sha256:c547c53c31e108bcdc968007f40167cb057f7c020bee7eeb50439178e432f479
  + Image ID: sha256:34a4d540614fcaa1858f4bafd6af3af734b67bdb2d39a2429f017b346e96527e

## 3.0.1i
 + Date: 2016-11-24
 + Add WAIT_TIME_OUT_VIDEO_STOP="20s"
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.100
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161114
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-47-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.267 GB
  + Digest: sha256:05c67433ac12aa2edb0063ca6dec83120b228c98989d8abce94d5d9e1ea74c59
  + Image ID: sha256:1c89bc44f93b516f04cdcebad5832d78c3e342848a8cfce002546009b810e0a0

## 3.0.1h
 + Date: 2016-11-24
 + Pick random ports from a range to avoid collisions
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.100
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161114
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-47-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.267 GB
  + Digest: sha256:78c49f1a7b5f16ab262c6600f522673a02bee968c06839ff15a59901d3c862ce
  + Image ID: sha256:a7c86c061a166299b43bc013d6ea39f1c5aac70f0fbe5f4232192f4bbc06b71c

## 3.0.1g
 + Date: 2016-11-18
 + NoVNC new defaults: autoconnect=true, view_only=true, resize=scale
 + NoVNC add index.html to shorten the url
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.100
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161114
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-47-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.267 GB
  + Digest: sha256:c9d58399bf386bc5e718fdbda03199e0b41352608f1466970ed16b568aa3eab0
  + Image ID: sha256:6a0209e0ae2d045603cf5b18170149baba8581b8d809f696d537f2bce603f3c4

## 3.0.1f
 + Date: 2016-11-18
 + Upgrade Firefox major from 49.0.2 to 50.0 (only for selenium 3)
 + Upgrade Ubuntu xenial date from 20161010 to 20161114
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.100
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 50.0
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161114
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-47-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.9.0, build 2585387
  + Built at CI  host with: Docker Compose version 1.9.0, build 2585387
  + Image size: 1.267 GB
  + Digest: sha256:383a7c68d2864e782021db3fd37d181378986d5ed9341bdedb48aa62834f3cec
  + Image ID: sha256:072f0740c957b996ad7e0034d8b731bc7417533a5298349d4813f22cdf15cf84

## 3.0.1e
 + Date: 2016-11-11
 + Upgrade Chrome patch 54.0.2840.100
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.100
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161010
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-47-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 1.275 GB
  + Digest: sha256:4707ee4314b6a63a2342140d324e50647a1cd514860d94596f66de754a9d6b92
  + Image ID: sha256:052632875d18ff42529af0d8a4e5837ddbcdf793c869575562b6bac4facd59f9

## 3.0.1d
 + Date: 2016-11-07
 + Reduce image size by 55%
 + Upgrade Chrome patch 54.0.2840.90
 + Remove openbox as we are only using fluxbox
 + Use OpenJDK as is a lot smaller than Oracle Java
 + Remove unnecessary installed misc packages
 + Remove video package (to be added in another image)
 + Remove big fonts (TBD if this will break someone)
 + Remove swf unused video stuff
 + Remove XDummy xorg unused X stuff
 + Remove OpenSSH as is not needed
 + Stop using user `application` and use shorter `seluser` instead
 + Remove SEL_HOME and simply write /home/seluser
 + Add libstderred.so & libpolyfill.so
 + Use printf instead of awk in echoerr()
 + Do not swallow errors on *_version scripts
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.90
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: OpenJDK Java 1.8.0_111-8u111-b14-2ubuntu0.16.04.2-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161010
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-45-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 1.273 GB
  + Digest: sha256:74ff4000c8f35b42c616f28ceeff218e6bea99b9f0700e226128e2b8fde6f3bc
  + Image ID: sha256:06db6439f1fe49fb0b1e7bc4c6ba15779a6ba92d9cf6a3349579bebf9c0967e3

## 3.0.1c
 + Date: 2016-10-30
 + Add FLUXBOX_START_MAX_RETRIES
 + Increase WAIT_FOREGROUND_RETRY
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.71
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: Oracle Java 1.8.0_111-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161010
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-45-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 2.94 GB
  + Digest: sha256:5e02a134c5488a836ab285b094f38b6dc6fed0fa3fd8e9d4e3314377b7fcce5c
  + Image ID: sha256:ad6c346e555ea49fd281c19772e9d2514468ba4515a3726b73c133a55a859c52

## 3.0.1b
 + Date: 2016-10-28
 + Upgrade Chromedriver to 2.25 (was 2.24)
 + Move back from Java 9 to Java 8 to save space
 + Added option -e VIDEO_STOP_SLEEP_SECS="1"
 + Upgrade BrowserStack minor to 6.5 (was 6.4)
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.71
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.25.426924 (649f9b868f6783ec9de71c123212b908bf3b232e)
  + Java: Oracle Java 1.8.0_111-b14
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161010
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.5
  + Tested on kernel dev host: 4.4.0-45-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.3, build 6b644ec
  + Built at CI  host with: Docker version 1.12.3, build 6b644ec
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 2.94 GB
  + Digest: sha256:d1069a3ce5d644c36aaaa0fbd054bb09fe4450cdc43d5008d802d700439419da
  + Image ID: sha256:b470ab400f544e6ecc580898848542e4b2811a80130a31976420c80f85d8f6c5

## 3.0.1a
 + Date: 2016-10-24
 + Upgrade Selenium 3 patch 3.0.1 (was 3.0.0)
 + Upgrade Chrome patch to 54.0.2840.71
 + Upgrade Firefox patch to 49.0.2
 + Upgrade Sauce Connect patch to 4.4.1 (was 4.4.0)
 + Upgrade BrowserStack minor to 6.4 (was 6.3)
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.1 (1969d75)
  + Chrome stable:  54.0.2840.71
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.2
  + Geckodriver: 0.11.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+140
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161010
  + Python: 2.7.12
  + Sauce Connect 4.4.1, build 2976 c1c1e98
  + BrowserStack Local version 6.4
  + Tested on kernel dev host: 4.4.0-45-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.2, build bb80604
  + Built at CI  host with: Docker version 1.12.2, build bb80604
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 3.063 GB
  + Digest: sha256:dc372096d8dc14fced081167293aa7ae81447304758c8ec9f3395772a8389212
  + Image ID: sha256:8f8afe9a90bc0a0ade77130da6bfc8fd12fdb64db055ec9ac45fbf7550e19a20

## 3.0.0c
 + Date: 2016-10-16
 + Upgrade Selenium to stable 3.0.0 (was beta)
 + Upgrade Chrome major to 54.0.2840.59
 + Upgrade Geckodriver from 0.10.0 to 0.11.1
 + Upgrade Ubuntu xenial to 20161010
 + Fix #124 Incorrect screen resolution
 + Fix #125 Through requirements-sele-2.txt and requirements-sele-3.txt
 + Upgrade supervisord 4.0.0 commit to 2015-10-09
 + Remove /usr/bin/wires as is no longer used
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.0 (350cf60)
  + Chrome stable:  54.0.2840.59
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.1
  + Geckodriver: 0.11.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20161010
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.3
  + Tested on kernel dev host: 4.4.0-43-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.2, build bb80604
  + Built at CI  host with: Docker version 1.12.2, build bb80604
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 3.066 GB
  + Digest: sha256:4de2b4c1b9c9ea792bdf5ccc8bb8157aee0f1b92f2ca6b45b090eb3bca068b68
  + Image ID: sha256:d470c117991393cf4d29fd79a25857fe8c3c8a706c1e3008d6cca0256a008833

## 3.0.0b4b
 + Date: 2016-10-07
 + Support Selenium IDE tests
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.0-beta4 (3169782)
  + Chrome stable:  53.0.2785.143
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.1
  + Geckodriver: 0.10.0
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160923.1
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.3
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 3.084 GB
  + Digest: sha256:2009929d4a89f9def44283e9eab443317b83610fea1f4fda7ea8ebc46ffb57aa
  + Image ID: sha256:172594ca5699ed482d5df208af6092b6d58e0aa057ff4c1aaee55546345c70b9

## 3.0.0b4a
 + Date: 2016-10-06
 + Selenium 3 and Selenium 2 will both be provided
 + Support Mobile Emulation https://goo.gl/pqa7cn
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.0-beta4 (3169782)
  + Chrome stable:  53.0.2785.143
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.1
  + Geckodriver: 0.10.0
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160923.1
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 3.085 GB
  + Digest: sha256:5975afd35e934e0c3c7cc3110b05883c77d260cdfdacd2d6f6f06a87179244c1
  + Image ID: sha256:1fb34dba4a4c8f2c83104c86be165d04e5386638ab733310c7e4113418aea071

## 3.0.0b4
 + Date: 2016-09-30
 + Include Selenium 3 (3.0.0-beta4) and enable via `-e USE_SELENIUM=3`
 + Allow to choose Selenium 2 or Selenium 3 via `USE_SELENIUM=2` (default) or `USE_SELENIUM=3`
 + Provide Firefox 49.0.1 for Selenium 3
 + Provide Firefox 47.0.1 for Selenium 2
 + Upgrade Chrome patch to 53.0.2785.143
 + Bug: Removed config option that didn't belong to the hub (is node-only) `-nodePolling`
 + Bug: Java CLI required all system `-D` args to be before the `-jar` argument
 + Removed future supported option `-trustAllSSLCertificates`
 + Add `--disable-gpu` to CHROME_ARGS to avoid the single GPU thread error message
 + Re-add geckodriver 0.10.0
 + Image tag details:
  + Selenium 2: 2.53.1 (a36b8b1)
  + Selenium 3: 3.0.0-beta4 (3169782)
  + Chrome stable:  53.0.2785.143
  + Firefox for Selenium 2: 47.0.1
  + Firefox for Selenium 3: 49.0.1
  + Geckodriver: 0.10.0
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160923.1
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 3.084 GB
  + Digest: sha256:18151e5ce43096191ca29d48ee07b74ad4f89448fd68eeb10a756c1ca199122e
  + Image ID: sha256:9209b1a8bb308cd506c0722402708914a37e7ad5b49833c0d2aa4d56f18ab2a1

## 2.53.1z
 + Date: 2016-09-29
 + Remove geckodriver as is not being used yet
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.116
  + Firefox stable: 47.0.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160923.1
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 2.576 GB
  + Digest: sha256:6c4bdb751fe15ebcec8b5a6dc120dd9ccee7f0883fcd24c82e187320e57beda6
  + Image ID: sha256:c301bc76361f55cb27c602f87b5790474ba6e38dbab88827eeb47e2b5bf7722c

## 2.53.1y
 + Date: 2016-09-27
 + Set chromedriver --log-path='/var/log/cont/chromedriver.log'
 + Add geckodriver for Firefox >= 48 (future releases)
 + Upgrade Ubuntu xenial to 20160923
 + Perhaps fixed DBUS mistery. See `entry.sh`
 + Client side: docker-compose from 1.8.0 to 1.8.1
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.116
  + Firefox stable: 47.0.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160923.1
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.1, build 878cff1
  + Built at CI  host with: Docker Compose version 1.8.1, build 878cff1
  + Image size: 2.562 GB
  + Digest: sha256:8bff17c78931b805dd99e62d93a920af3ea4c492d310b669c2dfd46dbe79f525
  + Image ID: sha256:fc282eb5b7b7120cdcb23f8a45aeddef3128bf2de3595493d2806cb799e02883

## 2.53.1x
 + Date: 2016-09-15
 + Upgrade Chrome stable patch 53.0.2785.116
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.116
  + Firefox stable: 47.0.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160818
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 2.576 GB
  + Digest: sha256:8706c84dafb513e327ea26d63457f68946ae4c972e7a64894f8f7252322ba9e1
  + Image ID: sha256:efeca54f615f09d696af4544704665c1f2b23acfb9b07740eb63213e414002de

## 2.53.1w
 + Date: 2016-09-14
 + Upgrade Chrome (stable) 53.0.2785.113
 + Upgrade Sauce Connect (minor) 4.4.0
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.113
  + Firefox stable: 47.0.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160818
  + Python: 2.7.12
  + Sauce Connect 4.4.0, build 2863 e8cba87
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 2.558 GB
  + Digest: sha256:3ad61734fa59bcfc9471f24574d950b8404f9607206bcb0315f435156b0e88ab
  + Image ID: sha256:accc3b1141f9cf95b0b8ec444c6da0438838eaada972cb162fad552d8dfcc106

## 2.53.1v
 + Date: 2016-09-10
 + Upgrade Chromedriver from 2.23 to 2.24
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.101
  + Firefox stable: 47.0.1
  + Chromedriver: 2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160818
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-38-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 2.553 GB
  + Digest: sha256:a30839bfbd71e9baa526fafa13af4b2dfcfaa6737467362a1590f93fcd567f15
  + Image ID: sha256:ee0960027149affc69ed41a8a4097581657bcf6a8a859daba1131ee2ccbca46b

## 2.53.1u
 + Date: 2016-09-08
 + Upgrade Chrome patch to 53.0.2785.101
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.101
  + Firefox stable: 47.0.1
  + Chromedriver: 2.23.409687 (c46e862757edc04c06b1bd88724d15a5807b84d1)
  + Java: Oracle Java 9-ea+134
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160818
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-37-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 2.553 GB
  + Digest: sha256:f0ea76484c9f50f20fa0a2fac9af2e2a47f83cd66aca9410d3d38d9973b415ae
  + Image ID: sha256:0eb466e3d2277fe127658daaafc917074012a37f9438526e2867c034a67629d7

## 2.53.1t
 + Date: 2016-09-03
 + Upgrade Chrome patch to 53.0.2785.92
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.92
  + Firefox stable: 47.0.1
  + Chromedriver: 2.23.409687 (c46e862757edc04c06b1bd88724d15a5807b84d1)
  + Java: Oracle Java 9-ea+130
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160818
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-37-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 2.551 GB
  + Digest: sha256:97696ad3194f3e6f85f159aa61fa6dea48527bc25bde11280d409847c78baf0e
  + Image ID: sha256:e8a8156e798da518d4db488937c1dd2c622a20dc4cd28734270cd6b4658e2622

## 2.53.1s
 + Date: 2016-09-01
 + Upgrade Chrome major to 53.0.2785.89
 + Upgrade Ubuntu xenial to 20160818
 + Upgrade BrowserStack Local 6.1
 + Chore: "to finish starting" => "to be ready"
 + Chore: Add missing apt-key 3B4FE6ACC0B21F32
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  53.0.2785.89
  + Firefox stable: 47.0.1
  + Chromedriver: 2.23.409687 (c46e862757edc04c06b1bd88724d15a5807b84d1)
  + Java: Oracle Java 9-ea+130
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160818
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 6.1
  + Tested on kernel dev host: 4.4.0-37-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.1, build 23cf638
  + Built at CI  host with: Docker version 1.12.1, build 23cf638
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.8.0, build f3628c7
  + Image size: 2.552 GB
  + Digest: sha256:817f4dc7fa8ace57ea9ea51bea3a6d0342ddf52bfe8a4ee4fa12bbf2cb207a94
  + Image ID: sha256:174d7bcc73d6a1d68609ca59963bd5f182c0c91b94c97756427d2e1963ef07c3

## 2.53.1r
 + Date: 2016-08-09
 + Upgrade Chrome patch to 52.0.2743.116
 + Upgrade Chromedriver from 2.22 to 2.23
 + Upgrade BrowserStack Local 5.8
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  52.0.2743.116
  + Firefox stable: 47.0.1
  + Chromedriver: 2.23.409687 (c46e862757edc04c06b1bd88724d15a5807b84d1)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160713
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.8
  + Tested on kernel dev host: 4.4.0-32-generic x86_64
  + Tested on kernel CI  host: 3.19.0-66-generic x86_64
  + Built at dev host with: Docker version 1.12.0, build 8eab29e
  + Built at CI  host with: Docker version 1.12.0, build 8eab29e
  + Built at dev host with: Docker Compose version 1.8.0, build f3628c7
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.554 GB
  + Digest: sha256:87ccaadb7495977174f465e7c84517715d33f2d4bcdf4b57c15f53d77ec7615f
  + Image ID: sha256:c214869edc14962304ed7883595d92504307eefed4f998c1035fb14ec2dbd748

## 2.53.1q
 + Date: 2016-07-22
 + Upgrade Chrome major from 51 to 52.0.2743.82
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  52.0.2743.82
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160713
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-32-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.548 GB
  + Digest: sha256:a926ffdbbbfa87e625fe129208cfa7f0a09f42530f6ae2aa8e9077f922d81ada
  + Image ID: sha256:afdddb9318db7c246529ba6a5f4e0af7212f07b5b43d714b977ff04ad4903f7f

## 2.53.1p
 + Date: 2016-07-19
 + Upgrade Ubuntu xenial to 20160713
 + Chore: Start xterm with a random geometry to differentiate nodes
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160713
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-31-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.548 GB
  + Digest: sha256:d6d2528cf56235ad8326f905e1b8c7aa1359c70a714a2b79c44e2a33fd7a37c4
  + Image ID: sha256:52763c9c89237976c279e365d4e2613b5de13029de017c969efc8b62dad84d5a

## 2.53.1n
 + Date: 2016-07-18
 + Fix OSX seq: illegal option -- -
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-31-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.532 GB
  + Digest: sha256:ff6bbb6a65091e571c29fb285dce3e932d8294b39504d7aeb343b7d5b9dd3801
  + Image ID: sha256:ea98789b81fd265c0aaa3445a7c28d8388df8858345ef149c0cb9e9be53e579c

## 2.53.1m
 + Date: 2016-07-18
 + Bugs: Makefile OSX fixes & discourage wmctrl
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-31-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.532 GB
  + Digest: sha256:8c54df153c7a058fa214dc3a4be35ca4c589d7754f01694bf7b3a0ce882929c4
  + Image ID: sha256:4337cb6fd63cc2a350c3ad27eeb1252933c9a5c23ec5f38a71ff16adaf42b909

## 2.53.1l
 + Date: 2016-07-17
 + OSX Makefile fixes
 + Add VNC_FROM_PORT & VNC_TO_PORT range
 + Easily gather video artifacts with `make videos`
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-31-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.531 GB
  + Digest: sha256:6281358d8b5e6a1811b38fdd724b164166b67b65845ec49c76fb82cee9c5dca2
  + Image ID: sha256:12f3ca7bbb73c8749a1a1a08385353b052a78ba589bc792c94ef7eefc6dfd935

## 2.53.1k
 + Date: 2016-07-16
 + Upgrade dockertoolbox cask to 1.12.0-rc4
 + Add Makefile support to stay DRY
 + Upgrade Python from 2.7.11 to 2.7.12
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-31-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.531 GB
  + Digest: sha256:2f2de54ffc84f905bba123cbd97bb53f63e886f1943659c9829cf813beaffb3b
  + Image ID: sha256:3f7bd2c90aa9e6068e3bf90dfe650eead1a26cc8fabe957888c7c1afa146f1ec

## 2.53.1i
 + Date: 2016-07-13
 + Upgrade Docker beta from 1.12.0-rc3 to 1.12.0-rc4
 + Add -e SEL_UNREGISTER_IF_STILL_DOWN_AFTER and default to 2500 ms
 + Add capabilities.json
 + Make `VNC_PASSWORD=no` passwordless accessible
 + Chore: get rid of `supervisord: no process found`
 + Chore: Use mock server at port 8080
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+126
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.12
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-30-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc4, build e4a0dbc
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.531 GB
  + Digest: sha256:2ea76cb1d6d6f4f2d0125f245d0d21b5caa0317055f96c992b955497cfc33607
  + Image ID: sha256:813f18b876122f4f9d139cb905f96536e83f842ee0f71a7f8651982c81190174

## 2.53.1h
 + Date: 2016-07-12
 + New default SELENIUM_NODE_REGISTER_CYCLE=1000
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-30-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc3, build 91e29e8
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.875 GB
  + Digest: sha256:dd5767eb4dc823a0826379fa2027ad98d46848c8b2d67daf904d149581b989b5
  + Image ID: sha256:f4d8c38e1ddd58046792b20a03f7cdc57c45b0dc659e77f33905a87fa22e9cb2

## 2.53.1g
 + Date: 2016-07-12
 + Add OSX support closes #111 #110
 + Upgrade Ubuntu xenial date to 20160706
 + Upgrade Supervisor 4 dev commit date to 20160628
 + Add docs/share-host.md and docs/jenkins.md (WIP)
 + Chore: Add `WORKDIR ${NORMAL_USER_HOME}`
 + Chore: Add `docker exec grid cat HUB_PORT #=> 24444`
 + Chore: Test offline site (mocked http server)
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160706
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-30-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc3, build 91e29e8
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.876 GB
  + Digest: sha256:1eeeebe62c99cae25cb10863dcb3a8bb4377ab583c2484265e45b0734dc7c4d9
  + Image ID: sha256:7fa7689f005be39a0f367eff5445893fb31f5974927b363c22227dc3d315b2d4

## 2.53.1f
 + Date: 2016-07-08
 + Add node -registerCycle customization via SELENIUM_NODE_REGISTER_CYCLE
 + Suicide nodes on selenium exited node.
 + WIP to add OSX support #111 #110
 + Upgrade BrowserStack Local 5.7
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160629
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.7
  + Tested on kernel dev host: 4.4.0-30-generic x86_64
  + Tested on kernel CI  host: 3.19.0-33-generic x86_64
  + Built at dev host with: Docker version 1.12.0-rc3, build 91e29e8
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.8.0-rc2, build c72c966
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.883 GB
  + Digest: sha256:9e152ece62791b1b7ec8f52cb9e255d6831d71f81e42b8f1e5b1681197959d93
  + Image ID: sha256:c35c6d2d2d5e983f3e2e5d8e363178c831b0dc70bb9915217dacd52208e7126c

## 2.53.1d
 + Date: 2016-07-05
 + Add (fixed) node -proxy customization via SELENIUM_NODE_PROXY_PARAMS
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160629
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.6
  + Tested on kernel dev host: 4.4.0-30-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.7.1, build 0a9ab35
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.883 GB
  + Digest: sha256:e5f537059ab9566eaf8b210a812ea1a5e95610cbb59649934a49e359eb370d65
  + Image ID: sha256:fbc0982d95f175f3a83bda6c26e754086afa5025fe2e33071ae244609156e91e

## 2.53.1b
 + Date: 2016-07-01
 + Fix race conditions while using many nodes with docker-compose
 + Image tag details:
  + Selenium: 2.53.1 (a36b8b1)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160629
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.6
  + Tested on kernel dev host: 4.4.0-29-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.7.1, build 0a9ab35
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.883 GB
  + Digest: sha256:e25853bfbd857bf351ba168bc5b7b28300326e88caad0529a21b345d79593bc4
  + Image ID: sha256:9e666b7765d47a3caec538f5bcec90455cbabf41271a1d202f18ec225ac76717

## 2.53.1a
 + Date: 2016-06-30
 + Upgrade Selenium to 2.53.1
 + Upgrade Firefox patch to 47.0.1
 + Add docker-compose support
 + Upgrade Ubuntu xenial date to 20160629
 + Fix signaling issue by replacing `CMD "entry.sh"` with `CMD ["entry.sh"]`
 + Image tag details:
  + Selenium: 2.53.0 (3da6b38)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 47.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160629
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.6
  + Tested on kernel dev host: 4.4.0-29-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Built at dev host with: Docker Compose version 1.7.1, build 0a9ab35
  + Built at CI  host with: Docker Compose version 1.7.1, build 0a9ab35
  + Image size: 2.883 GB
  + Digest: sha256:f9b256adaaa939b35975af0fedf5c35ad4bb01568de5478e391391d939a77dfa
  + Image ID: sha256:b90e486cdf19620183a68f473cdf5efe5f953faad1c41685dbcd859932afc543

## 2.53.0t
 + Date: 2016-06-24
 + Upgrade Chrome stable patch 51.0.2704.106
 + Fix bug when running Firefox only selenium node.
 + Add ./docs/hub_and_nodes.md
 + Allow to pick all unused ports via `-e PICK_ALL_RANDOM_PORTS=true`
 + Allow to pick individual unused unprivileged ports via `0` e.g. VNC_PORT=0
 + Fix bug that x11vnc was always assigning port 5900 for tcp6 IPv6 (missing `-rfbportv6`)
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  51.0.2704.106
  + Firefox stable: 46.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+123
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160525
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.6
  + Tested on kernel dev host: 4.4.0-27-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Image size: 2.872 GB
  + Digest: sha256:28e57a51b122e6d53bf2f1d6ebf8b7a58aecb70a59edfe494809f762b23065a8
  + Image ID: sha256:719c81b57a87ede52b6d8e7bfd6f0e0f29c1d63418edbfc5dfa00ce6104bed67

## 2.53.0s
 + Date: 2016-06-17
 + Upgrade Chrome stable patch 51.0.2704.103
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  51.0.2704.103
  + Firefox stable: 46.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+122
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160525
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.6
  + Tested on kernel dev host: 4.4.0-25-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Image size: 2.578 GB
  + Digest: sha256:32492e553b0cf7cdde156e8344e3080c4877a0d4376e4dcc2f878f6a4b3028d1
  + Image ID: sha256:4640c1947342c4d7d7e5cca892a55c0638388adb466407bddf3f94b7c74da2a9

## 2.53.0r
 + Date: 2016-06-07
 + Upgrade Chromedriver from 2.21 to 2.22
 + Upgrade Chrome stable patch 51.0.2704.84
 + Upgrade BrowserStack Local 5.6
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  51.0.2704.84
  + Firefox stable: 46.0.1
  + Chromedriver: 2.22.397932 (282ed7cf89cf0053b6542e0d0f039d4123bbb6ad)
  + Java: Oracle Java 9-ea+119
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160525
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.6
  + Tested on kernel dev host: 4.4.0-23-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Image size: 2.512 GB
  + Digest: sha256:f9d2de6e1a3af2c3ac343feb0ba962007c093c75a7cfbc68c0bc68bf0dc13f92
  + Image ID: sha256:7e9230cf8f9415af920860953e13610333d0abae8ceb8d983be4b570ba9e6a99

## 2.53.0q
 + Date: 2016-06-02
 + Upgrade Chrome stable patch 51.0.2704.79
 + Upgrade Sauce Connect to 4.3.16
 + Upgrade Ubuntu xenial date to 20160525
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  51.0.2704.79
  + Firefox stable: 46.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+119
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160525
  + Python: 2.7.11
  + Sauce Connect 4.3.16, build 2396 39e807b
  + BrowserStack Local version 5.5
  + Tested on kernel dev host: 4.4.0-23-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Image size: 2.511 GB
  + Digest: sha256:62a65592c7b7623a7ef20785fb315cefe37fc136cb278f6cfbf4434eaf87a052
  + Image ID: sha256:69b3147778dc9c0a4fc162d4c14aba060b811926330c66704fc210898ab87ffd

## 2.53.0p
 + Date: 2016-05-26
 + Upgrade Chrome stable major 51.0.2704.63
 + Upgrade Sauce Connect to 4.3.15
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  51.0.2704.63
  + Firefox stable: 46.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+119
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160503
  + Python: 2.7.11
  + Sauce Connect 4.3.15, build 2346 f0b0656
  + BrowserStack Local version 5.5
  + Tested on kernel dev host: 4.4.0-23-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.1, build 5604cbe
  + Built at CI  host with: Docker version 1.11.1, build 5604cbe
  + Image size: 2.522 GB
  + Digest: sha256:d7211a572db239e5091e94c544c2265ce8552f6b4dfd04021223d13132cba50e
  + Image ID: sha256:f52546cbc14ed9488cc0e41d84f585ee1ba59ccbd2614a9016bd31e22da651c1

## 2.53.0o
 + Date: 2016-05-13
 + Upgrade Chrome patch to 50.0.2661.102
 + Add mp4 playback ability in firefox for html5 @Z3r0Sum
 + Travis skip tmp branches
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  50.0.2661.102
  + Firefox stable: 46.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+116
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160503
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.5
  + Tested on kernel dev host: 4.4.0-22-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.1, build 5604cbe
  + Built at CI  host with: Docker version 1.11.1, build 5604cbe
  + Image size: 2.86 GB
  + Digest: sha256:5cba1f7f0a748e27453e619d3a249e49ae085bb7ec701c7cfde00fceca00f0b4
  + Image ID: sha256:1a039619599248d375e138a68584885af3c4ab2ca242ee16b947b64648d22521

## 2.53.0l
 + Date: 2016-05-04
 + Upgrade Firefox patch to 46.0.1
 + Upgrade Ubuntu xenial date to 20160503
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  50.0.2661.94
  + Firefox stable: 46.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+114
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160503
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.4
  + Tested on kernel dev host: 4.4.0-22-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.1, build 5604cbe
  + Built at CI  host with: Docker version 1.11.1, build 5604cbe
  + Image size: 2.815 GB
  + Digest: sha256:8d0b8c08fddc293aae7cf0fc063e218765888e418ec8aaf9e14a783754851ec1
  + Image ID: sha256:b8a337e68fb28119f1248d38c7d9d609770adcd9ed44b94369f19e7ba488e1b1

## 2.53.0k
 + Date: 2016-04-29
 + Upgrade Chrome patch to 50.0.2661.94
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  50.0.2661.94
  + Firefox stable: 46.0
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+114
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160422
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.4
  + Tested on kernel dev host: 4.4.0-22-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.1, build 5604cbe
  + Built at CI  host with: Docker version 1.11.1, build 5604cbe
  + Image size: 2.814 GB
  + Digest: sha256:de1cf160aff739f189001aa603a5ea3feba0f6672e3ef1fe73222fdae1673789
  + Image ID: sha256:fc166d873c90af983cade5a91918d11e8f2333be11a0b04916eb20a050466613

## 2.53.0j
 + Date: 2016-04-27
 + Upgrade Firefox major to 46.0
 + Upgrade Ubuntu xenial date to 20160422
 + Fix bug #83 on `docker restart`
 + Bump supervisor commit
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  50.0.2661.86
  + Firefox stable: 46.0
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+114
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160422
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.4
  + Tested on kernel dev host: 4.4.0-22-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.0, build 4dc5990
  + Built at CI  host with: Docker version 1.11.1, build 5604cbe
  + Image size: 2.814 GB
  + Digest: sha256:7b1e9ac1455df6d10b8ddda1447fbc81a039dc0e55d3bf88b39948792bba7b0f
  + Image ID: sha256:7f4e566de70d43047ab249e4a6e73624e0880e6547742adc33721fef9bfec48e

## 2.53.0i
 + Date: 2016-04-24
 + Upgrade Chrome patch to 50.0.2661.86
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  50.0.2661.86
  + Firefox stable: 45.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+112
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160331.1
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.4
  + Tested on kernel dev host: 4.4.0-21-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.0, build 4dc5990
  + Built at CI  host with: Docker version 1.11.0, build 4dc5990
  + Image size: 2.838 GB
  + Digest: sha256:15520122bd8f44301035de2d76584beef94dc9623cdc1989f44e52706cd53395
  + Image ID: sha256:1c6ae03c6cf1d905ebbc10d0e2837c3328c88c684d0ccc8222928952ed1bca70

## 2.53.0h
 + Date: 2016-04-14
 + Upgrade Chrome major to 50.0.2661.75
 + Chore: modularize script_push a bit
 + Chore: Update more changelog versions from Travis
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  50.0.2661.75
  + Firefox stable: 45.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9-ea+112
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160331.1
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.3
  + Tested on kernel dev host: 4.2.0-35-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.0, build 4dc5990
  + Built at CI  host with: Docker version 1.11.0, build 4dc5990
  + Image size: 2.823 GB
  + Digest: sha256:d46c66873d6233e847727096bd23bb4c486630b09a62914e83ebe8a6041ded1b
  + Image ID: sha256:2be6935eacf03c6e69958763be4b4c146d378c4c5f601574454dd694d7e4e587

## 2.53.0g
 + Date: 2016-04-12
 + Upgrade Firefox to 45.0.2
 + Upgrade BrowserStack local to 5.3
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.112
  + Firefox stable: 45.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+112
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160331.1
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.3
  + Tested on kernel dev host..: 4.2.0-35-generic x86_64
  + Tested on kernel CI host...: 3.19.0-30-generic x86_64
  + Built with: Docker version 1.10.3, build 20f81dd
  + Image size: 2.823 GB
  + Digest: sha256:074de644f4284809258f0c2a1f515f9ef2fbc4fb7d0b17c3cea5e55ed2e04d5d
  + Image ID: sha256:5cbb206f212033f3a01b8afbceecea72d2e98c74fd28dd7f8566498caab6eefe

## 2.53.0f
 + Date: 2016-04-08
 + Fix & chores to travis-ci build. Show Travis CI badges
 + Fixing clear_x_locks.sh
 + Upgrade Ubuntu xenial to 20160331.1
 + Upgrade Java 9 build 9-ea+112 patch level
 + Upgrade BrowserStack local to 5.2
 + Upgrade Chrome patch to 49.0.2623.112
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.112
  + Firefox stable: 45.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+112
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160331.1
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 5.2
  + Tested on kernel dev host..: 4.2.0-35-generic x86_64
  + Tested on kernel CI host...: 3.19.0-30-generic x86_64
  + Built with: Docker version 1.10.3, build 20f81dd
  + Image size: 2.822 GB
  + Digest: sha256:27d9fdf65ce887392e275b9077e0c88a60f2f91e3d6e29a7d26f43218f9fa4be
  + Image ID: sha256:3274cc68bc6800b6e507fc329dc2021a6bda8463fbbc91794750534501d84be9

## 2.53.0e
 + Date: 2016-03-30
 + Upgrade Chrome to 49.0.2623.110
 + Include basic python selenium tests inside the image
 + Begin travis-ci support on the project
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.110
  + Firefox stable: 45.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+110
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.3, build 20f81dd
  + Tested on kernel host: 4.2.0-35-generic x86_64 GNU/Linux
  + Image size: 2.613 GB
  + FROM ubuntu:xenial-20160317
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 4.9
  + Digest: sha256:49d82c9263c11caa28ccacac62ce3521b365d552df198baa43e3ee215285d33d
  + Image ID: sha256:10743036f2b887b0aac457852bee5c89582d79b497197d4ac8ced948c2092b85

## 2.53.0d
 + Date: 2016-03-23
 + Safer defaults on sshd_config, fix ssh docs
 + Disable ssh by default, now use -e SSHD=true
 + Bump noVNC updates from last ~ 10 months
 + Add https to selenium download base url
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.87
  + Firefox stable: 45.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+110
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.3, build 20f81dd
  + Tested on kernel host: 4.2.0-35-generic x86_64 GNU/Linux
  + Image size: 2.613 GB
  + FROM ubuntu:xenial-20160317
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 4.9
  + Digest: sha256:b123425dea23fd3d74e03a17d45f3b20c7f882d4ae16a17871c1d94d2ff27d79
  + Image ID: sha256:db32aef05b9e6ac893b5c84538f3dff9fed21fef44c4d4c8a8e6f5bd10e02833

## 2.53.0c
 + Date: 2016-03-22
 + Added noVNC back for @vvo
 + Added Algolia and Nvidia to README.md#who
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.87
  + Firefox stable: 45.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+110
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.3, build 20f81dd
  + Tested on kernel host: 4.2.0-35-generic x86_64 GNU/Linux
  + Image size: 2.614 GB
  + FROM ubuntu:xenial-20160317
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 4.9
  + Digest: sha256:34192fcef49d763110e52316552808a4d812675210d0c9e3ad0d93597cf009c2
  + Image ID: sha256:9e8ffad64276aa2130901946f24a853f48a8865fdcaf171b16c774424d3720ff

## 2.53.0b
 + Date: 2016-03-21
 + Upgrade Firefox to 45.0.1
 + Upgrade Ubuntu xenial to 20160317
 + Upgrade Sauce Connect to 4.3.14
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.87
  + Firefox stable: 45.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+110
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Tested on kernel host: 4.2.0-35-generic x86_64 GNU/Linux
  + Image size: 2.577 GB
  + FROM ubuntu:xenial-20160317
  + Python: 2.7.11
  + Sauce Connect 4.3.14, build 2010 d6099dc
  + BrowserStack Local version 4.9
  + Digest: sha256:730f39ec26caf28ecfc3c7ecec5e76f555d9335c0b8f890395a9a4e1460c87d6
  + Image ID: sha256:08f3de51344bd4c058fcc8bcd311565b3ab4301e3f39706362d598e73203a08c

## 2.53.0a
 + Date: 2016-03-16
 + Upgrade Selenium to 2.53.0
 + Upgrade Ubuntu xenial to 20160314.4
 + Upgrade Java 9 build 9-ea+109-2016-03-09-204305.javare.4620.nc
 + Upgrade BrowserStack Local to 4.9
 + Upgrade Supervisor to 2016-03-06
 + Image tag details:
  + Selenium: 2.53.0 (35ae25b)
  + Chrome stable:  49.0.2623.87
  + Firefox stable: 45.0
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+109-2016-03-09-204305.javare.4620.nc
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.3, build 20f81dd
  + Tested on kernel host: 4.2.0-34-generic x86_64 GNU/Linux
  + Image size: 2.620 GB
  + FROM ubuntu:xenial-20160314.4
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.9
  + Digest: sha256:36fa83fb95ff31d80249a4f57a3e41c1c06d808f15c7a9917b2f40c187c237d1
  + Image ID: sha256:e5c425e12e3eb65d0ae13aa0ac021d98942a05856c83b0428b68fd93f4cb589e

## 2.52.0g
 + Date: 2016-03-09
 + Upgrade Ubuntu xenial to 20160303.1
 + Upgrade Firefox (major) to 45.0
 + Upgrade Chrome (patch) to 49.0.2623.87
 + Remove/comment noVNC as is not being used
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  49.0.2623.87
  + Firefox stable: 45.0
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+102-2016-01-21-001533.javare.4316.nc
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Tested on kernel host: 4.2.0-32-generic x86_64 GNU/Linux
  + Image size: 2.611 GB
  + FROM ubuntu:xenial-20160303.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.8
  + Digest: sha256:f3e10e6719cc7ef2325d0286f475ee869afe390765f53f3dee53351ded53dde4
  + Image ID: 15ad97dda77d426ccacaa37f5ae126010c90069cf6c61d0872b68e67b62d0595

## 2.52.0f
 + Date: 2016-03-02
 + Upgrade Chrome to 49.0.2623.75
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  49.0.2623.75
  + Firefox stable: 44.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+102-2016-01-21-001533.javare.4316.nc
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Tested on kernel host: 4.2.0-32-generic x86_64 GNU/Linux
  + Image size: 2.603 GB
  + FROM ubuntu:xenial-20160226
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.8
  + Digest: sha256:51f821e16cb8e629d22db582459a63c77edce67a3e726e78303a890f78ad242e
  + Image ID: 476b64f55b3949533be530297240c864864d72a82907214a5ab7aa6fcc651bbc

## 2.52.0e
 + Date: 2016-02-29
 + Upgrade Ubuntu xenial to 20160226
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  48.0.2564.116
  + Firefox stable: 44.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+102-2016-01-21-001533.javare.4316.nc
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Image size: 2.603 GB
  + Tested on kernel host: 4.2.0-32-generic x86_64 GNU/Linux
  + FROM ubuntu:xenial-20160226
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.8
  + Digest: sha256:530e2740f1878323d1ade36bf3db53039eeb2edb501b24af9b6ef2f213c2164e
  + Image ID: 88168cb23dde90e9633bc7ac74bab7bae55e53880cd995908183410e77a23bc7

## 2.52.0d
 + Date: 2016-02-20
 + Switched OpenJDK 8 to Oracle Java 9
 + Upgrade BrowserStack to 4.8
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  48.0.2564.116
  + Firefox stable: 44.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: Oracle Java 9 build 9-ea+102-2016-01-21-001533.javare.4316.nc
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Image size: 2.548 GB
  + Tested on kernel host: 4.2.0-29-generic x86_64 GNU/Linux
  + FROM ubuntu:xenial-20160217.2
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.8
  + Digest: sha256:63d674ed8e11a2678d1f56b2b9e6c6e923447739dcec0cc6690d4a23261c9f0f
  + Image ID: 5bbcfb2f5d97013137717aa3a98f40e8e1ce407dc079a09bb8ef3811f74da78a

## 2.52.0c
 + Date: 2016-02-19
 + Upgrade Chrome to 48.0.2564.116
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  48.0.2564.116
  + Firefox stable: 44.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_03-internal OpenJDK 64-Bit 1.8.0_03-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Image size: 2.243 GB
  + Tested on kernel host: 4.2.0-29-generic x86_64 GNU/Linux
  + FROM ubuntu:xenial-20160217.2
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.7
  + Digest: sha256:4bb9601402bf53ca4eba09b6e2e92fd31eb888c32cc37e26e0a6c4d5e036363c
  + Image ID: 64d867660ad824c3cd3fb8263f173d5d15c0ba055cf6103d34e3003a6e90f791

## 2.52.0b
 + Date: 2016-02-18
 + Upgrade Ubuntu xenial to 20160217.2
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  48.0.2564.109
  + Firefox stable: 44.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_03-internal OpenJDK 64-Bit 1.8.0_03-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + Tested on kernel host: 4.2.0-29-generic x86_64 GNU/Linux
  + FROM ubuntu:xenial-20160217.2
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.7
  + Digest: sha256:05296caa1f1afeda8bafb0c14b8707eccb5a8b486d421e727bce6398360ecb10
  + Image ID: ff1b1567ab1cc8663c2bf88937b051f1527bb90413220c645fade9a6436d9b0b

## 2.52.0a
 + Date: 2016-02-16
 + Upgrade Firefox to 44.0.2
 + Upgrade Selenium to 2.52.0
 + Image tag details:
  + Selenium: 2.52.0 (4c2593c)
  + Chrome stable:  48.0.2564.109
  + Firefox stable: 44.0.2
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.1, build 9e83765
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.7
  + Digest: sha256:d30709c36514d5fc92671f3c1f5aa0befdb84d84a05771fe76b68ee54492a482
  + Image ID: sha256:0c9c729f25f13fc2d8efddd0552fe888bd489708a6c429b29039c833cb508377

## 2.51.0b
 + Date: 2016-02-10
 + Upgrade Chrome to 48.0.2564.109
 + Image tag details:
  + Selenium: 2.51.0 (1af067d)
  + Chrome stable:  48.0.2564.109
  + Firefox stable: 44.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.0, build 590d5108
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.7
  + Digest: sha256:5ae90e9da84c6e6fbcb4e65ed887b5ff374206407307e544a14b62ec09f695d6
  + Image ID: sha256:c64a141e312e727e12a17ae2e2cac483be0a320106702beff086df511a6458de

## 2.51.0a
 + Date: 2016-02-09
 + Upgrade Selenium to 2.51.0
 + Upgrade Firefox to 44.0.1
 + Upgrade BrowserStack to 4.7
 + Allow Chrome `--no-sandbox` mode through `$CHROME_ARGS`
 + Image tag details:
  + Selenium: 2.51.0 (1af067d)
  + Chrome stable:  48.0.2564.103
  + Firefox stable: 44.0.1
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.10.0, build 590d5108
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.7
  + Digest: sha256:5df788eb6487b4f3b34fc4289b9838bccadd2d117e1f03659b6969f7d6adcc2a
  + Image ID: sha256:fe3401222d9f85cabae6c2e16b918d85f1887b213142c0953b3294e800cfd7f3

## 2.50.1b
 + Date: 2016-02-04
 + Upgrade Chrome to 48.0.2564.103 and log chores
 + Image tag details:
  + Selenium: 2.50.1 (d7fc91b)
  + Chrome stable:  48.0.2564.103
  + Firefox stable: 44.0
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.5
  + Digest: sha256:8acb9184d340038aaef048a66238207bdff4e703868a7306864f7a338af52ab7
  + Image ID: 232aaf4662bb586aa7b7629231c7defbbd6dd60729f6c3891cdf2047745e2021

## 2.50.1a
 + Date: 2016-02-01
 + Upgrade Selenium to 2.50.1
 + Upgrade Firefox to 44.0
 + Upgrade BrowserStack to 4.5
 + Upgrade Supervisor 4 dev from 2015-08-24 to 2016-02-01
 + Image tag details:
  + Selenium: 2.50.1 (d7fc91b)
  + Chrome stable:  48.0.2564.97
  + Firefox stable: 44.0
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.5
  + Digest: sha256:bae990943a9864effce4cd45941bb87ad259f76594869cf869d4f47a7c2faa01
  + Image ID: 1efc89f6c6f485f60afbdfbd565b8c8951e8acd3bec595d04ce0b45a6bbf39d0

## 2.50.0b
 + Date: 2016-01-29
 + Upgrade Chromedriver from 2.20 to 2.21
 + Image tag details:
  + Selenium: 2.50.0 (1070ace)
  + Chrome stable:  48.0.2564.97
  + Firefox stable: 43.0.4
  + Chromedriver: 2.21.371461 (633e689b520b25f3e264a2ede6b74ccc23cb636a)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.4
  + Digest: sha256:dbb43ee4089a41de5fadd8dc07bd8d3ff91b194f194dd99a4d2f6a8723c024f0
  + Image ID: 42cfa329497e6c2346d0e67037ba8ac253a7babc5c6a211630ee5effcf9275da

## 2.50.0a
 + Date: 2016-01-28
 + Upgrade Selenium to 2.50.0
 + Upgrade Chrome to 48.0.2564.97
 + Image tag details:
  + Selenium: 2.50.0 (1070ace)
  + Chrome stable:  48.0.2564.97
  + Firefox stable: 43.0.4
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.4
  + Digest: sha256:6da83608280a0f2331af13aa50c5987a69180b8bd5f21570d507e3b00462f51a
  + Image ID: fa1da96f1db1cd7aad504ffad10422caea95eba7a07e0542a2d3d3f393814c50

## 2.49.1b
 + Date: 2016-01-26
 + Upgrade ubuntu:xenial-20160119.1 to 20160125
 + Upgrade OpenJDK 1.8.0_72-b05 to b15
 + Image tag details:
  + Selenium: 2.49.1 (7203e46)
  + Chrome stable:  48.0.2564.82
  + Firefox stable: 43.0.4
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b15
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160125
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.4
  + Digest: sha256:eee029f4d890d7f70ed1ed195d2d027e312d5fb01cddde8087de5b1788889d65
  + Image ID: 58051b8f8d4088875459410730fe8cde86a301d699191cb85e0df8661761a8dd

## 2.49.1a
 + Date: 2016-01-21
 + Upgrade Selenium to 2.49.1
 + Upgrade Chrome to 48.0.2564.82
 + Image tag details:
  + Selenium: 2.49.1 (7203e46)
  + Chrome stable:  48.0.2564.82
  + Firefox stable: 43.0.4
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160119.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.4
  + Digest: sha256:fe5db3edb22bb9f55c57954b6c8ec8c809721cc439138cb21ec0145b58468181
  + Image ID: 38a113670a468ec7daaca513140d1019a24925f3a3da0bd4e17d3169ba9239e0

## 2.49.0b
 + Date: 2016-01-20
 + Upgrade from ubuntu:xenial-20151218.1 to 20160119.1
 + Upgrade BrowserStack to 4.4
 + Image tag details:
  + Selenium: 2.49.0 (365eeb4)
  + Chrome stable:  47.0.2526.111
  + Firefox stable: 43.0.4
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20160119.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.4
  + Digest: sha256:6e9ba524f771aebacd6399b936c01c52651daec9247fa9ead5b2d92c95a4740d
  + Image ID: 89f2fe717c0b4579adcf8fbe33a6fcfcb4100c64f59d905564bf2ae2c0ecd356

## 2.49.0a
 + Date: 2016-01-13
 + Upgrade Selenium to 2.49.0
 + Upgrade Chrome to 47.0.2526.111
 + Image tag details:
  + Selenium: 2.49.0 (365eeb4)
  + Chrome stable:  47.0.2526.111
  + Firefox stable: 43.0.4
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20151218.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.3
  + Digest: sha256:3b1ee16d2e8b12cd6846f1ad07930cb4a72d60dac1b168d5b73e78436545422b
  + Image ID: dffa647d4f05d6bcb976222795d23575b684de4fc0e48e1320e13fc73f4cad9d

## 2.48.2k
 + Date: 2016-01-08
 + Upgrade Firefox to 43.0.4
 + Upgrade BrowserStack to 4.3
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.106
  + Firefox stable: 43.0.4
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20151218.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.3
  + Digest: sha256:8954936340069f026a62926a102caf99ef627c526faf8339b2e75b229ed116e3
  + Image ID: 46da8e57154b6c18915354cb391a4b9cba6d400eba20f68ed082d621cb3e883b

## 2.48.2j
 + Date: 2015-12-28
 + Upgrade Firefox to 43.0.3
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.106
  + Firefox stable: 43.0.3
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20151218.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.2
  + Digest: sha256:4cf6f3beab1e339ee4c4add8eed4257148e7473247a42c63a84bf19cec7749d7
  + Image ID: 3df56d671c587ade181b17104998945142b932d85b1928ac6874b6310feb7b7c

## 2.48.2i
 + Date: 2015-12-23
 + Upgrade Firefox to 43.0.2
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.106
  + Firefox stable: 43.0.2
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20151218.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.2
  + Digest: sha256:36b94a0e70ff811adfb4371db3aaeb93854c51bc426545c280f52442d887e87c
  + Image ID: 1b1313ca0b837c75cdd72773f6505c4fa6f9d83e365d8554256537539bee4862

## 2.48.2h
 + Date: 2015-12-20
 + Upgrade Ubuntu from 15.10 (wily) to 16.04 (xenial)
 + Upgrade Java from 1.8.0_66-b01 to 1.8.0_72-b05
 + Upgrade Python from 2.7.10 to 2.7.11
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.106
  + Firefox stable: 43.0.1
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_72-internal OpenJDK 64-Bit 1.8.0_72-b05
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:xenial-20151218.1
  + Python: 2.7.11
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.2
  + Digest: sha256:8ea9f381839880a46524318b8fb97fc677bfc095c81efc79f85c47d0e7ee28a3
  + Image ID: 0c4cd2c838997b5d97bc2d0e859a799560c09b3efe6e0057df4384a440293b18

## 2.48.2g
 + Date: 2015-12-19
 + Upgrade Firefox to 43.0.1
 + Upgrade Chrome to 47.0.2526.106
 + Upgrade Sauce Connect to 4.3.13
 + Upgrade BrowserStack to 4.2
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.106
  + Firefox stable: 43.0.1
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:wily-20151208
  + Python: 2.7.10
  + Sauce Connect 4.3.13, build 1877 d9e5947
  + BrowserStack Local version 4.2
  + Digest: sha256:6204c54673d29117b32f336fe10aec966c3046af90dfc25436fd44d9dc0c4341
  + Image ID: 14efe64babd2b700b632f87b2872ded72fb0a6884fe5047a16a11fac8921a18f

## 2.48.2f
 + Date: 2015-12-09
 + Upgrade Ubuntu wily from 20151019 to 20151208
 + Upgrade Chrome to 47.0.2526.80
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.80
  + Firefox stable: 42.0
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:wily-20151208
  + Python: 2.7.10
  + Sauce Connect 4.3.12, build 1788 abd6986
  + BrowserStack Local version 4.1
  + Digest: sha256:7315ec9539b27d158a7455d13c0425874a55eca00f5e125086ef46017a48607b
  + Image ID: d0bc6966224236f74e8cdcbdf4ba24026bdf988083852ffa454778a3df9be98d

## 2.48.2e
 + Date: 2015-12-02
 + Upgrade Chrome to 47.0.2526.73
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  47.0.2526.73
  + Firefox stable: 42.0
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:wily-20151019
  + Python: 2.7.10
  + Sauce Connect 4.3.12, build 1788 abd6986
  + BrowserStack Local version 4.1
  + Digest: sha256:94a3cab15c784dafd3e915235d6b5369e7a6aeb1e99cf934002583bde12a5291
  + Image ID: 830fb301e6fdac663bc56049ddcf84b8758e3643db9d82e65a951dac83065b0a

## 2.48.2d
 + Date: 2015-11-27
 + Upgrade Sauce Connect to 4.3.12
 + Upgrade BrowserStack to 4.1
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  46.0.2490.86
  + Firefox stable: 42.0
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.1, build a34a1d5
  + FROM ubuntu:wily-20151019
  + Python: 2.7.10
  + Sauce Connect 4.3.12, build 1788 abd6986
  + BrowserStack Local version 4.1
  + Digest: sha256:0635e19d4e97e862451c5f7efaf421027f039aeb825d88f105da602755556a56
  + Image ID: e88ea57afb7cde1d64f439fc69b044704f0ee0b14a1c094ce7eb2cf980e58a29

## 2.48.2c
 + Date: 2015-11-11
 + Upgrade to Chrome to 46.0.2490.86
 + Increase wait timeout and other minor chores
 + Improve video transfer artifacts through `docker cp`
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  46.0.2490.86
  + Firefox stable: 42.0
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.0, build 76d6bc9
  + FROM ubuntu:wily-20151019
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 4
  + Digest: sha256:8640b744b4ce63a67081f3a74a094d5a2aa425b594cd83fbbcbc8e8aa2c8005c
  + Image ID: 838fd1a3e07bb1c38cb50bd5115100831863a0e53f382203d2736c5cb6f0175b

## 2.48.2b
 + Date: 2015-11-04
 + Upgrade to Chrome to 46.0.2490.80
 + Upgrade to Firefox to 42.0 and fix mozilla.org => firefox ftp links
 + Upgrade to ubuntu:wily-20151019
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  46.0.2490.80
  + Firefox stable: 42.0
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.9.0, build 76d6bc9
  + FROM ubuntu:wily-20151019
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 4
  + Digest: sha256:156b394b944203b95d7d813e1f82022c8cf7714da3c8196fd6833033e10ac13f
  + Image ID: 4e3f3d0129a13bef199e336493bc1edaf321a4d388acac3abbc33600f70471d6

## 2.48.2a
 + Date: 2015-10-20
 + Upgrade to Selenium 2.48.2
 + Upgrade to chromedriver 2.20
 + Upgrade to Firefox to 41.0.2
 + Upgrade to Chrome to 46.0.2490.71
 + Upgrade to ubuntu:wily-20151009
 + Image tag details:
  + Selenium: 2.48.2 (41bccdd)
  + Chrome stable:  46.0.2490.71
  + Firefox stable: 41.0.2
  + Chromedriver: 2.20.353124 (035346203162d32c80f1dce587c8154a1efa0c3b)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.3, build f4bf5c7
  + FROM ubuntu:wily-20151009
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.9
  + Digest: sha256:38897dc92e131bce6608316560f89567e884eb9d7bc115e8c64aaffac60ed0b6
  + Image ID: 84caf3003c9471ec3103033cf2e9ccda8e30555e78f495e27187967312daf6d8

## 2.47.1n
 + Date: 2015-10-06
 + Remove older Firefox and Chrome beta/dev as they are not being used.
 + Upgrade BrowserStack Local version 3.9
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:  45.0.2454.101
  + Firefox stable: 41.0.1
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.2, build 0a8c2e3
  + FROM ubuntu:wily-20150829
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.9
  + Digest: sha256:00e1f7f63c58bfe16ae5a1152c6a93efa5952044d66d6c067e06fed8a4572b02
  + Image ID: 3ae90ecda33f70fde3d8a89c1a229654a5c76b9bb9934b291f4e145a93347bcd

## 2.47.1m
 + Date: 2015-10-04
 + Upgrade Firefox to 41.0.1, Chrome 45.0.2454.101 and other flavors.
 + Minor improvements by using SIGTERM instead of SIGKILL.
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         45.0.2454.101
  + Chrome beta:           46.0.2490.52
  + Chrome dev (unstable): 47.0.2522.1
  + Firefox versions in this image:
      41.0.1  40.0.3  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.2, build 0a8c2e3
  + FROM ubuntu:wily-20150829
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.8
  + Digest: sha256:a863819c0b0754c849a09e7d3704c6ccd286da141f4bc8dfc58f79bcdd2a5014
  + Image ID: e24f8fa942c6d9fcdcd4c0ee8a263d70550dd71d8c5ab5ef967fe3aeca89582e

## 2.47.1l
 + Date: 2015-09-23
 + Upgrade Firefox to 41.0, Chrome 45.0.2454.99 and other flavors.
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         45.0.2454.99
  + Chrome beta:           46.0.2490.33
  + Chrome dev (unstable): 47.0.2516.0
  + Firefox versions in this image:
      41.0    40.0.3  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.2, build 0a8c2e3
  + FROM ubuntu:wily-20150829
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.8
  + Digest: sha256:158b215f055011d9de0d5783de08e111a3fec9acdbf4a9f75570eb60d92a9a44
  + Image ID: c8be1422d08f6a84f78f866a4c0827c2efd5d88efe11dfbd245bc3ca21288e84

## 2.47.1k
 + Date: 2015-09-16
 + Upgrade Chrome patch level to 45.0.2454.93 and other flavors.
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         45.0.2454.93
  + Chrome beta:           46.0.2490.22
  + Chrome dev (unstable): 47.0.2508.0
  + Firefox versions in this image:
              40.0.3  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.2, build 0a8c2e3
  + FROM ubuntu:wily-20150829
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.8
  + Digest: sha256:8d8a588e0bbc48b53e9fa159b74331eea4a5c7784c40d7562c3eb569b1bc1f24
  + Image ID: 2279fc0820b5a4d7c82f661b521916ba57da47efc13641205e90b5ffc4982c15

## 2.47.1j
 + Date: 2015-09-09
 + Upgrade from wily-20150807 to wily-20150829 (Leo Gallucci)
 + Make noVNC service only start with `-e NOVNC=true`
 + Upgrade supervisor 4.0.0.dev0 from 2015-06-24 commit to 2015-08-24.
 + Fix race condition after docker pull and run the image the first time.
 + Fix SSH_AUTH_KEYS detected issue
 + Fix grid-hub registration issues
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         45.0.2454.85
  + Chrome beta:           46.0.2490.13
  + Chrome dev (unstable): 47.0.2503.0
  + Firefox versions in this image:
              40.0.3  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.1, build d12ea79
  + FROM ubuntu:wily-20150829
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.7
  + Digest: sha256:3a1cda55d920a64d1ad892c65b543b48a8a86fac572e3f2eefce11862107579a
  + Image ID: 07d8bd8ca179de2125f27113bdcebf969c250b150150d2977c637c64c15ef936

## 2.47.1i
 + Date: 2015-09-04
 + Upgrade Chrome stable to 45.0.2454.85 and beta/dev (Leo Gallucci)
 + Document how to share the host dns via --net=host --pid=host
 + Only umount/mount /dev/shm if -e SHM_TRY_MOUNT_UNMOUNT=true
 + Allow to use a network interface different from "eth0" like "em1"
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         45.0.2454.85
  + Chrome beta:           46.0.2490.13
  + Chrome dev (unstable): 47.0.2498.0
  + Firefox versions in this image:
              40.0.3  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.1, build d12ea79
  + FROM ubuntu:wily-20150807
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.7
  + Digest: sha256:d3e6b627463598bd59cc9b6201d1f471df122632f9413f69fa5dcd9c7f03c0cc
  + Image ID: 66be67ad7da61893b2341b03afd34bc18da9031fa70df823375cab680a28c2a5

## 2.47.1h
 + Date: 2015-08-28
 + Upgrade Firefox 40.0.3, Chrome flavors, chromedriver 2.19 (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.157
  + Chrome beta:           45.0.2454.78
  + Chrome dev (unstable): 46.0.2490.6
  + Firefox versions in this image:
              40.0.3  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + Chromedriver: 2.19.346067 (6abd8652f8bc7a1d825962003ac88ec6a37a82f1)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.1, build d12ea79
  + FROM ubuntu:wily-20150807
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.7
  + Digest: sha256:b906385e2e14d2ff642de9c1c01e353fc50e0345d5f04c934586cc0c4951fd03
  + Image ID: 4c83c4d2b3261531ae874e873f56a32af7e9836db77d2b8020e7de25b2b21b66

## 2.47.1g
 + Date: 2015-08-24
 + Optionally do `sc --doctor` via SAUCE_TUNNEL_DOCTOR_TEST (Leo Gallucci)
 + Fix small tiny 64mb shm issue via SHM_SIZE and `--privileged` mode.
 + Upgrade Chrome stable to 44.0.2403.157 and also beta patch level.
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.157
  + Chrome beta:           45.0.2454.46
  + Chrome dev (unstable): 46.0.2486.0
  + Firefox versions in this image:
              40.0.2  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.18.343837 (52eb4041461e46a6b73308ebb19e85787ced4281)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.1, build d12ea79
  + FROM ubuntu:wily-20150807
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.7
  + Digest: sha256:50c14f27c7447cb83cff38736dc2f76033198c94cd80f513a3216b41689c73dd
  + Image ID: dfa1cbfe9932e651e32d60b360cecada4dde289163fe0570d5814af24830ab63

## 2.47.1f
 + Date: 2015-08-19
 + Upgrade chromedriver from 2.17 to 2.18 (Leo Gallucci)
 + Upgrade Sauce Connect version and add `sc --doctor`
 + Retry Sauce Connect via -e SAUCE_TUNNEL_MAX_RETRY_ATTEMPTS
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.155
  + Chrome beta:           45.0.2454.37
  + Chrome dev (unstable): 46.0.2486.0
  + Firefox versions in this image:
              40.0.2  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.18.343837 (52eb4041461e46a6b73308ebb19e85787ced4281)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.1, build d12ea79
  + FROM ubuntu:wily-20150807
  + Python: 2.7.10
  + Sauce Connect 4.3.11, build 1757 2b421bb
  + BrowserStack Local version 3.7
  + Digest: sha256:9a21a268f6badecbba9033bb7eba50b9f6dc77c59370dec29f3fc6d3f38fd70d
  + Image ID: fe93086c831942e4aac6f916db7a9221bcb205e654628a0421fed0ee725ff9de

## 2.47.1e
 + Date: 2015-08-14
 + Upgrade from wily-20150731 to 20150807 (Leo Gallucci)
 + Add Firefox 40.0.2 and upgrade Chrome patch levels.
 + Include Sauce Connect tunneling support.
 + Include BrowserStack tunneling support.
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.155
  + Chrome beta:           45.0.2454.37
  + Chrome dev (unstable): 46.0.2478.0
  + Firefox versions in this image:
              40.0.2  39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.17.340116 (2557bebb9de060c37c1a5d8d51ef72bb91106af6)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.8.1, build d12ea79
  + FROM ubuntu:wily-20150807
  + Python: 2.7.10
  + Sauce Connect 4.3.10, build 1731 2bab8b6
  + BrowserStack Local version 3.7
  + Digest: sha256:60bdb382f19cca7caf1d541839fc98a0dec7b58ede684d1d4c3b5a82b84b2e41
  + Image ID: b7f6f616de9feb402c81e1940ca8a90fc8f4e74cd0163cb530ef46b1cb99b990

## 2.47.1d
 + Date: 2015-08-07
 + Upgrade from wily-20150708 to 20150731 (Leo Gallucci)
 + Upgrade Firefox from 39.0 to 39.0.3
 + Upgrade Chrome stable patch level from 125 to 130
 + Upgrade Java from 1.8.0_60 to 1.8.0_66
 + Include missed Firefox version 36.0.4
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.130
  + Chrome beta:           45.0.2454.26
  + Chrome dev (unstable): 46.0.2471.2
  + Firefox versions in this image:
                      39.0.3  38.0.6  37.0.2  36.0.4
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.17.340116 (2557bebb9de060c37c1a5d8d51ef72bb91106af6)
  + Java: 1.8.0_66-internal OpenJDK 64-Bit 1.8.0_66-b01
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:wily-20150731
  + Python: 2.7.10
  + Digest: sha256:cefeec6485e598f7ba8bde1533d4ecec79227fdd91a4de2823db1dd8996caa74
  + Image ID: c59f0bd567cb40c4a97c9a7b040f2ecd25036a0eec4fe63bf2a8217ff9d0e6b9

## 2.47.1c
 + Date: 2015-08-03
 + Upgrade chromedriver from 2.16 to 2.17 (Leo Gallucci)
 + Upgrade chrome unstable from 45 to 46.0.2467.2
 + Include and improve host-scripts inside the docker image
 + Reorganize packages installation order
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.125
  + Chrome beta:           45.0.2454.15
  + Chrome dev (unstable): 46.0.2467.2
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.17.340116 (2557bebb9de060c37c1a5d8d51ef72bb91106af6)
  + Java: 1.8.0_60-internal OpenJDK 64-Bit 1.8.0_60-b22
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Digest: sha256:9a0df41fb5228ae6bf184c97b706aec33a453e3190a546cbb9e9fe00ac73128c
  + Image ID: c627036423aa4fa4baea37b24a8ab6fa08e713935ff771f3e3a45881f4319b21

## 2.47.1a
 + Date: 2015-07-30
 + Upgrade selenium from 2.46.0 to 2.47.1 (Leo Gallucci)
 + Upgrade chrome stable to 44.0.2403.125
 + Add -e MEM_JAVA to allow to pass custom values like "1024m".
 + Image tag details:
  + Selenium: 2.47.1 (411b314)
  + Chrome stable:         44.0.2403.125
  + Chrome beta:           45.0.2454.15
  + Chrome dev (unstable): 45.0.2454.15
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_60-internal OpenJDK 64-Bit 1.8.0_60-b22
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Digest: sha256:5df46e24ff6358d9f047adeae5e298a508011dd13baf9cd8093026d2a9357ee0
  + Image ID: 7189525fdd0bd4cc4492559f3fee1e58b7cd8c59eb6b692798cf537f2e084ef4

## 2.46.0-06
 + Date: 2015-07-24
 + Upgrade chrome stable to 44.0.2403.89. (Leo Gallucci)
 + Remove letter v from version tags due to github tarball issue.
 + Add +extension GLX to Xvfb in preparation for android emulators.
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome stable:         44.0.2403.89
  + Chrome beta:           44.0.2403.89
  + Chrome dev (unstable): 45.0.2454.7
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_60-internal OpenJDK 64-Bit 1.8.0_60-b22
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Digest: sha256:fe49be13887bb390ca4f6d3617fd8f34c6a84bc08319bb4f18555ed7d6045f08
  + Image ID: 7d6df22491ed41ec6474b5bf9a48f453dc0d835ce257f39e02cd5fe356a2c1bb

## v2.46.0-05
 + Date: 2015-07-20
 + Split video files through `-e VIDEO_CHUNK_SECS="00:10:00"`. (Leo Gallucci)
 + Lower down ffmpeg CPU usage considerable by using libx264 ultrafast.
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome stable:         43.0.2357.134
  + Chrome beta:           44.0.2403.89
  + Chrome dev (unstable): 45.0.2454.7
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_60-internal OpenJDK 64-Bit 1.8.0_60-b22
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Digest: sha256:9de7c1db421c4b813bca60d148495ed155595b8ee6371f8f600d51a1e42b5782
  + Image ID: 7c279c889b6c2007b292070324a9109bf3a12b299721af948cf806cac9d62cd7

## v2.46.0-04
 + Date: 2015-07-18
 + Fix bug openbox X manager not waiting for Xvfb. (Leo Gallucci)
 + Fix entry.sh exiting immediately and not checking DISABLE_ROLLBACK.
 + Allow to choose X manager flavor via `-e XMANAGER=openbox|fluxbox`
 + Fix bug in wait-docker-selenium.sh
 + Fix bug while docker stop $NAME; supervisor not getting SIGINT properly.
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome stable:         43.0.2357.134
  + Chrome beta:           44.0.2403.89
  + Chrome dev (unstable): 45.0.2454.7
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_60-internal OpenJDK 64-Bit 1.8.0_60-b22
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Digest: sha256:6f525fa015e3b815da968a998c58757892955f195cee286b4c39fe15035d01d3
  + Image ID: e7ceeaf7ab0adf758a1f2f5e21fe53db9aa2eff7b55b01af1c7fe2620a9f309b

## v2.46.0-02
 + Date: 2015-07-17
 + Add DISABLE_ROLLBACK so when true users can troubleshoot. (Leo Gallucci)
 + Add ./host-scripts/wait-docker-selenium.sh to know when to start tests.
 + Improve log output when container startup fails.
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome stable:         43.0.2357.134
  + Chrome beta:           44.0.2403.81
  + Chrome dev (unstable): 45.0.2454.6
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:trusty-20150630
  + Python: 2.7.6
  + Digest: sha256:939b5ede408a85c38384af794bcfa335f4e253fe446bfd612bfdaa904b1ffab4
  + Image ID: ef0decd768c36075904192d0b306f1de9cf859a7472c8dba040dcc368ea4894b

## v2.46.0-01
 + Date: 2015-07-16
 + Launch as grid only, firefox node only, chrome node only. (Leo Gallucci)
 + Start services via env vars VIDEO=false GRID=true CHROME=true FIREFOX=true
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome stable:         43.0.2357.134
  + Chrome beta:           44.0.2403.81
  + Chrome dev (unstable): 45.0.2454.6
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:trusty-20150630
  + Python: 2.7.6
  + Digest: sha256:29766e276918fd39ec679fe9ad208d3aa04deeb7e22171aaaa5877ab6f732616
  + Image ID: 049e6178f83f6abe4230211e0f1116ccdda92083b3f81038a1a7fc1d5325f26b

## v2.46.0-00
 + Date: 2015-07-15
 + Make selenium maxInstances & maxSession configurable. (Leo Gallucci)
 + MAJOR: turned docker-selenium into 1 hub N nodes localhost setup.
 + MAJOR: Provide last 15 versions and select via -e FIREFOX_VERSION.
 + Provide chrome stable, beta and unstable via -e CHROME_FLAVOR.
 + Mutated SELENIUM_PARAMS into SELENIUM_HUB_PARAMS & SELENIUM_NODE_PARAMS
 + Record videos via `-e VIDEO=true` or start-video/stop-video scripts.
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome stable:         43.0.2357.134
  + Chrome beta:           44.0.2403.81
  + Chrome dev (unstable): 45.0.2454.6
  + Firefox versions in this image:
                      39.0    38.0.6  37.0.2
      35.0.1  34.0.5  33.0.3  32.0.3  31.0    30.0
      29.0.1  28.0    27.0.1  26.0    25.0.1  24.0
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.1, build 786b29d
  + FROM ubuntu:trusty-20150630
  + Python: 2.7.6
  + Digest: sha256:94c0e3992501db24a5a07cba516d8e7e32ac419ea7accae915275eb58dd389d5
  + Image ID: a8bc01890482646e82188ecd84b799fb2e7a1588f7627779b16735ed55d4f40c

## v2.46.0-sup
 + Date: 2015-07-13
 + Switched to supervidord for process management, closes #24 (Leo Gallucci)
 + Extracted guacamole (with tomcat) into elgalu/guaca-docker.
 + Switched from guacamole to noVNC.
 + Refactored code and directory structure.
 + Renamed SSH_PUB_KEY to SSH_AUTH_KEYS to reflect the true meaning.
 + Fixed scm-source date validation.
 + Moved all ports above 2k to mitigate changes of ssh -R port conflicts
 + IMPORTANT: Breaking changes in this release, read the docs again.
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome: 43.0.2357.132
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 39.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.0, build 0baf609
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Image ID: 27b1674c981927123538e809d33cb7c9644da4c0f2cca85a655792d2cf57d698
  + Digest: sha256:1cd291d278d888cf566e0c7ca95377407b568ca3fb05aedb11f9781277e1ecb7

## v2.46.0-ff39
 + Date: 2015-07-08
 + Upgrade Firefox from 38.0.5 to 39.0 and Chrome patch level from 130 to 132  (Leo Gallucci)
 + Minor improvement to mozdownload and mozInstall for Firefox download
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome: 43.0.2357.132
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 39.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.0, build 0baf609
  + FROM ubuntu:vivid-20150611
  + Python: 2.7.9
  + Image ID: 9a8d735a5e1ed22728426fb5cdd696215f382c74487f9616cfa3b67f31e735dc
  + Digest: sha256:311e42f1253868dd10208e4153b2a9419dadf8e6ce4ef31cbf200604ac9e22b8

## v2.46.0-x11
 + Date: 2015-06-24
 + Ability to pass extra params to the selenium server via SELENIUM_PARAMS (Rogov Viktor)
 + Allow to set -e XE_DISP_NUM so X11 can be redirect to the host (Leo Gallucci)
 + Add README note on how to use Xephyr to redirect X to the docker host
 + Upgrade from ubuntu:vivid-20150528 to ubuntu:vivid-20150611
 + Upgrade guacamole from 0.9.6 to 0.9.7
 + Start using pip-based alternate script to get more up-to-date Firefox version
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome: 43.0.2357.130
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 38.0.5
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Built with: Docker version 1.7.0, build 0baf609
  + FROM ubuntu:vivid-20150611
  + Python: 2.7.9
  + Image ID: 247b69cbd53ef323b117362fd8bb7510276c5e9a702d15e8573223b0467538fb
  + Digest: sha256:8d67d3d15dfd449e94433de46c352ff135f38678ebd6e217b613e7f1770d5490

## v2.46.0-base1
 + Date: 2015-06-09
 + Upgrade selenium from 2.45.0 to 2.46.0
 + Upgrade chromedriver from 2.15 to 2.16
 + Add Xdummy (Xorg config) driver as an alternative to Xvfb (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.46.0 (87c69e2)
  + Chrome: 43.0.2357.124
  + chromedriver: 2.16.333243 (0bfa1d3575fc1044244f21ddb82bf870944ef961)
  + Firefox: 38.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Image ID: 4f827cfc7317413d2e73ef17c6da6216f92d60d080b70fffc15058543e820b93
  + Digest: sha256:dc7568c79355b6bde63706165b07f3c22e64e5749e12ab3591e5160776e09b1b

## v2.45.0-oracle1
 + Date: 2015-06-04
 + Include urandom fix that hangs selenium start up (Matthew Smith)
 + Switch to Oracle Java 8 to test it out (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45 HotSpot(TM) 64-Bit 1.8.0_45-b14
  + Timezone: Europe/Berlin
  + Image ID: fcaf12794d4311ae5c511cbc5ebc500ff01782b4eac18fe28f994557ebb401fe
  + Digest: sha256:e7698b35ca2bbf51caed32ffbc26d1a653ba4a4d26adbbbaab98fb5d02f92fbf

## v2.45.0-ssh4
 + Date: 2015-06-04
 + Add option to disable wait for selenium to start (Leo Gallucci)
 + Add jq tool for json querying (Leo Gallucci)
 + Make possible to docker run -v /var/run/docker.sock (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Image ID: 34cffc685e12a021b720c2ea19fe1a48c7d438c129f7859bbae43473e4afc95a
  + Digest: sha256:def2d462d0224382c8ac5709ee2b468287d88e6973eb14089925631db8065fbd

## v2.45.0-ssh3
 + Date: 2015-06-03
 + Upgrade Ubuntu from vivid-20150427 to vivid-20150528 (Leo Gallucci)
 + Document how to use this docker image securely via sha256 and image ids (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Image ID: 7edb56ee8ec7aaa6e8e95cc762a80392b662aa75a3c45e97868ad5018f710dc2
  + Digest: sha256:4f9d0d50a1f2f13c3b5fbbe19792dc826d0eb177f87384a9536418e26a6333c5

## v2.45.0-ssh2
 + Date: 2015-05-27
 + Make ssh server optional and default to true (Leo Gallucci)
 + Allow -e TOMCAT_PORT to be changed from new default port 8484 #15 (Leo Gallucci)
 + Stop exposing unsecure tcp ports (selenium, vnc, tomcat) and only expose sshd (Leo Gallucci)
 + Document how to do tunneling in the secured container (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Image ID: 4b411d30788bbe0bb8e64eaf21af03250388e700d60e1064c93ef5499809ff73
  + Digest: sha256:b12e6710b7f8b44721f2c1248df2f41d57a0fb8586314651b126390e1721bf68

## v2.45.0-ssh1
 + Date: 2015-05-26
 + Add sshd so can tunnel to test local apps remotely (Leo Gallucci)
 + Add guacamole server (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 43.0.2357.81
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Image ID: 92400bcf07af7fee256c782596aaa65c7f66d41508ce729a8b1cb6a7b72ef05f
  + Digest: sha256:023e36054783629a1d36f74c2abc70f281041aa9f830e13ed8ec79e215f433f5

## v2.45.0-openbox1
 + Date: 2015-05-22
 + Send selenium output to stdout so can be picked up by docker logs (Leo Gallucci)
 + Added this file: CHANGELOG.md (Leo Gallucci)
 + No matter what always use non-root user "application" (Leo Gallucci)
 + Switching to openjdk-8-jre-headless (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 43.0.2357.65
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 38.0
  + Java: 1.8.0_45-internal OpenJDK 1.8.0_45-internal-b14
  + Timezone: Europe/Berlin
  + Digest: sha256:bc374296275ad125848a4ba11c052f30efd99dd7ebdc1d1a21e2a92c1245b186

## v2.45.0-berlin5
 + Date: 2015-05-08
 + Make image resilient to docker run -u UID or Username (Leo Gallucci)
 + Allow internal container VNC_PORT to be changed at run time (Leo Gallucci)
 + Generate random VNC password when no VNC_PASSWORD supplied (default) (Leo Gallucci)
 + Image tag details:
  + Selenium: 2.45.0 (5017cb8)
  + Chrome: 42.0.2311.135
  + chromedriver: 2.15.322448 (52179c1b310fec1797c81ea9a20326839860b7d3)
  + Firefox: 37.0.2
  + Java: 1.7.0_79 OpenJDK 7u79-2.5.5-0ubuntu1
  + Timezone: Europe/Berlin

## v2.45.0-berlin2
 + Date: 2015-05-07
 + Bump vivid (Leo Gallucci)
 + Added active waits and removed sleeps (Leo Gallucci)
 + Allow VNC password to be set via env var (Leo Gallucci)

## v2.45.0-berlin
 + Date: 2015-04-28
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
