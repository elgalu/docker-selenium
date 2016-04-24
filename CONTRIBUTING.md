# Contributing

## Local
For pull requests:

    ./test/before_install_build && ./test/install && ./test/script_scenario_1
    ./test/script_scenario_2 && ./test/script_archive && ./test/script_push
     ./test/after_script
    open ./images/grid_console.png #to verify the versions are correct
    git checkout ./images/grid_console.png && open ./videos/chrome/test.mkv
    travis lint #if you changed .travis.yml
    git checkout -b tmp-2.53.0i #name your branch according to your changes
    #git add ... git commit ... git push ... open pull request

For repository owners only:

    git commit -m "Upgrade Chrome major to 50.0.2661.86"
    git tag 2.53.0i && git push origin tmp-2.53.0i && git push --tags

-- Wait for Travis to pass OK
-- Make shure changes got merged into master by elgalubot
-- Duplicate section in CHANGELOG.md starting with TBD_DOCKER_TAG

    git checkout master && git pull && git branch -d tmp-2.53.0i && git push origin --delete tmp-2.53.0i

-- Upgrade release tag in github.com with latest CHANGELOG.md
-- If Chrome version changed upload:

    ~/docker/binaries/

### Chrome artifact
Keep certain bins if chrome version changed for example:

    VER="50.0.2661.86"
    wget -nv --show-progress -O binaries/google-chrome-stable_${VER}_amd64.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

## Retry
Failed in Travis? retry

    git tag -d 2.53.0i && git push origin :2.53.0i
    #git add ...
    git commit --amend && git tag 2.53.0i && git push --force origin tmp-2.53.0i && git push --tags

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
