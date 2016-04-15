# Changelog

Note sha256 digests are generated after pushing the image to the registry therefore the last version of this docker-selenium will always have digest TBD (to be determined) but will be updated manually at [releases][]

Note image ids also change after scm-source.json has being updated which triggers a cyclic problem so value TBD will be set here and updated in the [release][] page by navigating into any release tag.

###### To get container versions
    docker exec grid versions

## 2.53.0h
 + Date: 2016-04-14
 + Upgrade Chrome major to 50.0.2661.75
 + Chore: modularize script_push a bit
 + Chore: Update more changelog versions from Travis
 + Image tag details:
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.53.0 (35ae25b)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.52.0 (4c2593c)
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
  + Selenium: v2.51.0 (1af067d)
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
  + Selenium: v2.51.0 (1af067d)
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
  + Selenium: v2.50.1 (d7fc91b)
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
  + Selenium: v2.50.1 (d7fc91b)
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
  + Selenium: v2.50.0 (1070ace)
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
  + Selenium: v2.50.0 (1070ace)
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
  + Selenium: v2.49.1 (7203e46)
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
  + Selenium: v2.49.1 (7203e46)
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
  + Selenium: v2.49.0 (365eeb4)
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
  + Selenium: v2.49.0 (365eeb4)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.48.2 (41bccdd)
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
  + Selenium: v2.47.1 (411b314)
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
  + Selenium: v2.47.1 (411b314)
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
  + Selenium: v2.47.1 (411b314)
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
  + Selenium: v2.47.1 (411b314)
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
  + Selenium: v2.47.1 (411b314)
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
  + Selenium: v2.47.1 (411b314)
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
  + Digest: sha256:b906385e2e14d2ff642de9c1c01e353fc50e0345d5f04c934586cc0c4951fd03
  + Image ID: 4c83c4d2b3261531ae874e873f56a32af7e9836db77d2b8020e7de25b2b21b66

## 2.47.1g
 + Date: 2015-08-24
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
  + Digest: sha256:50c14f27c7447cb83cff38736dc2f76033198c94cd80f513a3216b41689c73dd
  + Image ID: dfa1cbfe9932e651e32d60b360cecada4dde289163fe0570d5814af24830ab63

## 2.47.1f
 + Date: 2015-08-19
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
  + Digest: sha256:9a21a268f6badecbba9033bb7eba50b9f6dc77c59370dec29f3fc6d3f38fd70d
  + Image ID: fe93086c831942e4aac6f916db7a9221bcb205e654628a0421fed0ee725ff9de

## 2.47.1e
 + Date: 2015-08-14
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
  + Digest: sha256:cefeec6485e598f7ba8bde1533d4ecec79227fdd91a4de2823db1dd8996caa74
  + Image ID: c59f0bd567cb40c4a97c9a7b040f2ecd25036a0eec4fe63bf2a8217ff9d0e6b9

## 2.47.1c
 + Date: 2015-08-03
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
  + Digest: sha256:9a0df41fb5228ae6bf184c97b706aec33a453e3190a546cbb9e9fe00ac73128c
  + Image ID: c627036423aa4fa4baea37b24a8ab6fa08e713935ff771f3e3a45881f4319b21

## 2.47.1a
 + Date: 2015-07-30
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
  + Digest: sha256:5df46e24ff6358d9f047adeae5e298a508011dd13baf9cd8093026d2a9357ee0
  + Image ID: 7189525fdd0bd4cc4492559f3fee1e58b7cd8c59eb6b692798cf537f2e084ef4

## 2.46.0-06
 + Date: 2015-07-24
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
  + Digest: sha256:fe49be13887bb390ca4f6d3617fd8f34c6a84bc08319bb4f18555ed7d6045f08
  + Image ID: 7d6df22491ed41ec6474b5bf9a48f453dc0d835ce257f39e02cd5fe356a2c1bb

## v2.46.0-05
 + Date: 2015-07-20
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
  + Digest: sha256:6f525fa015e3b815da968a998c58757892955f195cee286b4c39fe15035d01d3
  + Image ID: e7ceeaf7ab0adf758a1f2f5e21fe53db9aa2eff7b55b01af1c7fe2620a9f309b

## v2.46.0-02
 + Date: 2015-07-17
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
  + Digest: sha256:939b5ede408a85c38384af794bcfa335f4e253fe446bfd612bfdaa904b1ffab4
  + Image ID: ef0decd768c36075904192d0b306f1de9cf859a7472c8dba040dcc368ea4894b

## v2.46.0-01
 + Date: 2015-07-16
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

## v2.46.0-ff39
 + Date: 2015-07-08
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

## v2.46.0-x11
 + Date: 2015-06-24
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

## v2.46.0-base1
 + Date: 2015-06-09
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

## v2.45.0-oracle1
 + Date: 2015-06-04
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

## v2.45.0-ssh4
 + Date: 2015-06-04
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

## v2.45.0-ssh3
 + Date: 2015-06-03
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

## v2.45.0-ssh2
 + Date: 2015-05-27
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

## v2.45.0-ssh1
 + Date: 2015-05-26
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

## v2.45.0-openbox1
 + Date: 2015-05-22
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

## v2.45.0-berlin5
 + Date: 2015-05-08
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
