# Contributing

## Local
    ./test/before_install_build && ./test/install
    ./test/script_scenario_1 && ./test/script_scenario_2
    ./test/script_archive && ./test/script_push && ./test/after_script
    open ./videos/chrome/test.mkv
    travis lint
    git checkout -b tmp-2.53.0f
    git commit -m "Only docker login when needed in travis-ci"
    git tag 2.53.0f && git push origin tmp-2.53.0f && git push --tags
    #if Travis passes OK and changes got merged into master by elgalubot
    git push origin --delete tmp-2.53.0f

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
