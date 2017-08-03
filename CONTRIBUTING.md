# Contributing

## Local
For pull requests or local commits:

    git checkout -b tmp-`cat VERSION`
    time (./test/bef && ./test/install && ./test/script_start && ./test/script_end)
    open ./images/grid3_console.png && open ./videos/mobile_emulation/*.mp4
    docker exec grid versions && ./test/after_script && travis lint
    git checkout ./images/grid3_console.png scm-source.json
    #git add ... git commit ... git push ... open pull request

For repository owners only:

    git commit -m "Upgrade Chrome patch to 60.0.3112.90"
    git tag -d latest; git tag -d `cat VERSION`; git push origin :`cat VERSION`; git tag `cat VERSION` && git push --force origin tmp-`cat VERSION` && git push --tags

-- Wait for Travis to pass OK
-- Make sure changes got merged into master by elgalubot

    git checkout master && git pull && git branch -d tmp-`cat VERSION` && git push origin --delete tmp-`cat VERSION`

-- Re-add TBD_* section in CHANGELOG.md starting with TBD_DOCKER_TAG
-- If Chrome version changed upload:

    ~/tmp_binaries

### Chrome artifact
Keep certain bins if chrome version changed for example:

    cd ~/tmp_binaries && VER="60.0.3112.90" && NAME="google-chrome-stable_${VER}_amd64" && echo ${NAME}
    wget -nv --show-progress -O ${NAME}.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    md5sum ${NAME}.deb > ${NAME}.md5 && shasum ${NAME}.deb > ${NAME}.sha && cp ${NAME}.md5 ${NAME}.sha ~/dosel/binaries

## Docker push from Travis CI
Travis [steps](https://docs.travis-ci.com/user/docker/#Pushing-a-Docker-Image-to-a-Registry) involve `docker login` and docker credentials encryptions.

### Requirements

* Ruby
* `gem install travis --no-rdoc --no-ri`
* `travis login --user elgalu`
* Encrypt environment variables with travis cli

### Encrypt
    travis env set DOCKER_EMAIL me@example.com
    travis env set DOCKER_USERNAME elgalubot
     travis env set DOCKER_PASSWORD secretsecret #1st space in purpose
     travis env set GH_TOKEN secretsecret

### Bot setup
#### github.com
- bot: Fork the repo
- owner: Add bot as collaborator
- bot: Accept collaborator invitation
- bot: Generate personal token

#### hub.docker
- owner: Add bot as collaborator

#### travis-ci.org
- owner: Enable the project
- owner: Run all the required `travis env set`
