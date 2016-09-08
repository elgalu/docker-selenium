# Contributing

## Local
For pull requests or local commits:

    time (./test/bef && ./test/install && ./test/script_start && ./test/script_end) ; beep
    docker exec grid versions && ./test/after_script
    open ./images/grid_console.png #to verify the versions are correct
    git checkout ./images/grid_console.png && open ./videos/chrome/*.mkv
    travis lint #if you changed .travis.yml
    git checkout -b tmp-2.53.1u #name your branch according to your changes
    #git add ... git commit ... git push ... open pull request

For repository owners only:

    git commit -m "Upgrade Chrome patch to 53.0.2785.101"
    git tag -d latest && git tag 2.53.1u && git push origin tmp-2.53.1u && git push --tags

-- Wait for Travis to pass OK
-- Make sure changes got merged into master by elgalubot

    git checkout master && git pull && git branch -d tmp-2.53.1u && git push origin --delete tmp-2.53.1u

-- Re-add TBD_* section in CHANGELOG.md starting with TBD_DOCKER_TAG
-- If Chrome version changed upload:

    ~/docker/binaries/

### Chrome artifact
Keep certain bins if chrome version changed for example:

    cd binaries && wget -O stable_updates.html "http://googlechromereleases.blogspot.de/search/label/Stable%20updates"
    VER=$(grep -Po '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' stable_updates.html | head -1)
    echo $VER; VER="53.0.2785.101"
    NAME="google-chrome-stable_${VER}_amd64" && echo ${NAME}
    wget -nv --show-progress -O ${NAME}.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    md5sum ${NAME}.deb > ${NAME}.md5 && shasum ${NAME}.deb > ${NAME}.sha
    rm -f stable_updates.html && cd ..

## Retry
Failed in Travis? retry

    git tag -d 2.53.1u && git push origin :2.53.1u
    #git add ...
    git commit --amend && git tag 2.53.1u && git push --force origin tmp-2.53.1u && git push --tags

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
