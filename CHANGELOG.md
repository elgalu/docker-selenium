# Changelog

Note sha256 digests are generated after pushing the image to the registry therefore the last version of this docker-selenium will always have digest TBD (to be determined) but will be updated manually at [releases][]

Note image ids also change after scm-source.json has being updated which triggers a cyclic problem so value TBD will be set here and updated in the [release][] page by navigating into any release tag.

How to get container versions

    java -version && python --version && firefox -version
    chromedriver --version && echo "\n"
    google-chrome-stable --version && echo "\n"
    google-chrome-beta --version && echo "\n"
    google-chrome-unstable --version && echo "\n"
    sc | grep build && BrowserStackLocal -version

## 2.47.1h (2015-08-28)
 + Upgrade Firefox 40.0.3, Chrome flavors, chromedriver 2.19 (Leo Gallucci)
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: TBD
  + Digest: sha256:TBD

## 2.47.1g (2015-08-24)
 + Optionally do `sc --doctor` via SAUCE_TUNNEL_DOCTOR_TEST (Leo Gallucci)
 + Fix small tiny 64mb shm issue via SHM_SIZE and `--privileged` mode.
 + Upgrade Chrome stable to 44.0.2403.157 and also beta patch level.
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: dfa1cbfe9932e651e32d60b360cecada4dde289163fe0570d5814af24830ab63
  + Digest: sha256:50c14f27c7447cb83cff38736dc2f76033198c94cd80f513a3216b41689c73dd

## 2.47.1f (2015-08-19)
 + Upgrade chromedriver from 2.17 to 2.18 (Leo Gallucci)
 + Upgrade Sauce Connect version and add `sc --doctor`
 + Retry Sauce Connect via -e SAUCE_TUNNEL_MAX_RETRY_ATTEMPTS
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: fe93086c831942e4aac6f916db7a9221bcb205e654628a0421fed0ee725ff9de
  + Digest: sha256:9a21a268f6badecbba9033bb7eba50b9f6dc77c59370dec29f3fc6d3f38fd70d

## 2.47.1e (2015-08-14)
 + Upgrade from wily-20150731 to 20150807 (Leo Gallucci)
 + Add Firefox 40.0.2 and upgrade Chrome patch levels.
 + Include Sauce Connect tunneling support.
 + Include BrowserStack tunneling support.
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: b7f6f616de9feb402c81e1940ca8a90fc8f4e74cd0163cb530ef46b1cb99b990
  + Digest: sha256:60bdb382f19cca7caf1d541839fc98a0dec7b58ede684d1d4c3b5a82b84b2e41

## 2.47.1d (2015-08-07)
 + Upgrade from wily-20150708 to 20150731 (Leo Gallucci)
 + Upgrade Firefox from 39.0 to 39.0.3
 + Upgrade Chrome stable patch level from 125 to 130
 + Upgrade Java from 1.8.0_60 to 1.8.0_66
 + Include missed Firefox version 36.0.4
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: c59f0bd567cb40c4a97c9a7b040f2ecd25036a0eec4fe63bf2a8217ff9d0e6b9
  + Digest: sha256:cefeec6485e598f7ba8bde1533d4ecec79227fdd91a4de2823db1dd8996caa74

## 2.47.1c (2015-08-03)
 + Upgrade chromedriver from 2.16 to 2.17 (Leo Gallucci)
 + Upgrade chrome unstable from 45 to 46.0.2467.2
 + Include and improve host-scripts inside the docker image
 + Reorganize packages installation order
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: c627036423aa4fa4baea37b24a8ab6fa08e713935ff771f3e3a45881f4319b21
  + Digest: sha256:9a0df41fb5228ae6bf184c97b706aec33a453e3190a546cbb9e9fe00ac73128c

## 2.47.1a (2015-07-30)
 + Upgrade selenium from 2.46.0 to 2.47.1 (Leo Gallucci)
 + Upgrade chrome stable to 44.0.2403.125
 + Add -e MEM_JAVA to allow to pass custom values like "1024m".
 + Image tag details:
  + Selenium: v2.47.1 (411b314)
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
  + Image ID: 7189525fdd0bd4cc4492559f3fee1e58b7cd8c59eb6b692798cf537f2e084ef4
  + Digest: sha256:5df46e24ff6358d9f047adeae5e298a508011dd13baf9cd8093026d2a9357ee0

## 2.46.0-06 (2015-07-24)
 + Upgrade chrome stable to 44.0.2403.89. (Leo Gallucci)
 + Remove letter v from version tags due to github tarball issue.
 + Add +extension GLX to Xvfb in preparation for android emulators.
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
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
  + Image ID: 7d6df22491ed41ec6474b5bf9a48f453dc0d835ce257f39e02cd5fe356a2c1bb
  + Digest: sha256:fe49be13887bb390ca4f6d3617fd8f34c6a84bc08319bb4f18555ed7d6045f08

## v2.46.0-05 (2015-07-20)
 + Split video files through `-e VIDEO_CHUNK_SECS="00:10:00"`. (Leo Gallucci)
 + Lower down ffmpeg CPU usage considerable by using libx264 ultrafast.
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
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
  + Image ID: 7c279c889b6c2007b292070324a9109bf3a12b299721af948cf806cac9d62cd7
  + Digest: sha256:9de7c1db421c4b813bca60d148495ed155595b8ee6371f8f600d51a1e42b5782

## v2.46.0-04 (2015-07-18)
 + Fix bug openbox X manager not waiting for Xvfb. (Leo Gallucci)
 + Fix entry.sh exiting immediately and not checking DISABLE_ROLLBACK.
 + Allow to choose X manager flavor via `-e XMANAGER=openbox|fluxbox`
 + Fix bug in wait-docker-selenium.sh
 + Fix bug while docker stop $NAME; supervisor not getting SIGINT properly.
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
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
  + Image ID: e7ceeaf7ab0adf758a1f2f5e21fe53db9aa2eff7b55b01af1c7fe2620a9f309b
  + Digest: sha256:6f525fa015e3b815da968a998c58757892955f195cee286b4c39fe15035d01d3

## v2.46.0-02 (2015-07-17)
 + Add DISABLE_ROLLBACK so when true users can troubleshoot. (Leo Gallucci)
 + Add ./host-scripts/wait-docker-selenium.sh to know when to start tests.
 + Improve log output when container startup fails.
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
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
  + Image ID: ef0decd768c36075904192d0b306f1de9cf859a7472c8dba040dcc368ea4894b
  + Digest: sha256:939b5ede408a85c38384af794bcfa335f4e253fe446bfd612bfdaa904b1ffab4

## v2.46.0-01 (2015-07-16)
 + Launch as grid only, firefox node only, chrome node only. (Leo Gallucci)
 + Start services via env vars VIDEO=false GRID=true CHROME=true FIREFOX=true
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
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
  + Image ID: 049e6178f83f6abe4230211e0f1116ccdda92083b3f81038a1a7fc1d5325f26b
  + Digest: sha256:29766e276918fd39ec679fe9ad208d3aa04deeb7e22171aaaa5877ab6f732616

## v2.46.0-00 (2015-07-15)
 + Make selenium maxInstances & maxSession configurable. (Leo Gallucci)
 + MAJOR: turned docker-selenium into 1 hub N nodes localhost setup.
 + MAJOR: Provide last 15 versions and select via -e FIREFOX_VERSION.
 + Provide chrome stable, beta and unstable via -e CHROME_FLAVOR.
 + Mutated SELENIUM_PARAMS into SELENIUM_HUB_PARAMS & SELENIUM_NODE_PARAMS
 + Record videos via `-e VIDEO=true` or start-video/stop-video scripts.
 + Image tag details:
  + Selenium: v2.46.0 (87c69e2)
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
  + Image ID: a8bc01890482646e82188ecd84b799fb2e7a1588f7627779b16735ed55d4f40c
  + Digest: sha256:94c0e3992501db24a5a07cba516d8e7e32ac419ea7accae915275eb58dd389d5

## v2.46.0-sup (2015-07-13)
 + Switched to supervidord for process management, closes #24 (Leo Gallucci)
 + Extracted guacamole (with tomcat) into elgalu/guaca-docker.
 + Switched from guacamole to noVNC.
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
  + FROM ubuntu:wily-20150708
  + Python: 2.7.10
  + Image ID: 27b1674c981927123538e809d33cb7c9644da4c0f2cca85a655792d2cf57d698
  + Digest: sha256:1cd291d278d888cf566e0c7ca95377407b568ca3fb05aedb11f9781277e1ecb7

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
  + FROM ubuntu:vivid-20150611
  + Python: 2.7.9
  + Image ID: 9a8d735a5e1ed22728426fb5cdd696215f382c74487f9616cfa3b67f31e735dc
  + Digest: sha256:311e42f1253868dd10208e4153b2a9419dadf8e6ce4ef31cbf200604ac9e22b8

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
  + FROM ubuntu:vivid-20150611
  + Python: 2.7.9
  + Image ID: 247b69cbd53ef323b117362fd8bb7510276c5e9a702d15e8573223b0467538fb
  + Digest: sha256:8d67d3d15dfd449e94433de46c352ff135f38678ebd6e217b613e7f1770d5490

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
  + Image ID: 4f827cfc7317413d2e73ef17c6da6216f92d60d080b70fffc15058543e820b93
  + Digest: sha256:dc7568c79355b6bde63706165b07f3c22e64e5749e12ab3591e5160776e09b1b

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
  + Image ID: fcaf12794d4311ae5c511cbc5ebc500ff01782b4eac18fe28f994557ebb401fe
  + Digest: sha256:e7698b35ca2bbf51caed32ffbc26d1a653ba4a4d26adbbbaab98fb5d02f92fbf

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
  + Image ID: 34cffc685e12a021b720c2ea19fe1a48c7d438c129f7859bbae43473e4afc95a
  + Digest: sha256:def2d462d0224382c8ac5709ee2b468287d88e6973eb14089925631db8065fbd

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
  + Image ID: 7edb56ee8ec7aaa6e8e95cc762a80392b662aa75a3c45e97868ad5018f710dc2
  + Digest: sha256:4f9d0d50a1f2f13c3b5fbbe19792dc826d0eb177f87384a9536418e26a6333c5

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
  + Image ID: 4b411d30788bbe0bb8e64eaf21af03250388e700d60e1064c93ef5499809ff73
  + Digest: sha256:b12e6710b7f8b44721f2c1248df2f41d57a0fb8586314651b126390e1721bf68

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
  + Image ID: 92400bcf07af7fee256c782596aaa65c7f66d41508ce729a8b1cb6a7b72ef05f
  + Digest: sha256:023e36054783629a1d36f74c2abc70f281041aa9f830e13ed8ec79e215f433f5

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
