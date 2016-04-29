# Contributing

## Local
For pull requests:

    ./test/before_install_build && ./test/install
    #or: ./test/script
     ./test/script_scenario_1 && ./test/script_scenario_2
     ./test/script_archive && ./test/script_push
    ./test/after_script #or: docker exec grid versions
    open ./images/grid_console.png #to verify the versions are correct
    git checkout ./images/grid_console.png && open ./videos/chrome/test.mkv
    travis lint #if you changed .travis.yml
    git checkout -b tmp-2.53.0k #name your branch according to your changes
    #git add ... git commit ... git push ... open pull request

For repository owners only:

    git commit -m "Upgrade Chrome patch to 50.0.2661.94"
    git tag -d latest #tag latest will be updated from TravisCI
    git tag 2.53.0k && git push origin tmp-2.53.0k && git push --tags

-- Wait for Travis to pass OK
-- Make sure changes got merged into master by elgalubot

    git checkout master && git pull && git branch -d tmp-2.53.0k && git push origin --delete tmp-2.53.0k

-- Re-add TBD_* section in CHANGELOG.md starting with TBD_DOCKER_TAG
-- Upgrade release tag in github.com with latest CHANGELOG.md
-- If Chrome version changed upload:

    ~/docker/binaries/

### Chrome artifact
Keep certain bins if chrome version changed for example:

    VER="50.0.2661.94"
    wget -nv --show-progress -O binaries/google-chrome-stable_${VER}_amd64.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

## Retry
Failed in Travis? retry

    git tag -d 2.53.0k && git push origin :2.53.0k
    #git add ...
    git commit --amend && git tag 2.53.0k && git push --force origin tmp-2.53.0k && git push --tags

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
