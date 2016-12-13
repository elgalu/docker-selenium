# Security notes on Docker-Selenium

The docker images are built and pushed from [TravisCI](https://travis-ci.org/elgalu/docker-selenium/builds/123103275) for full traceability.

Using `VNC_PASSWORD=no` will make it VNC passwordless accessible, leave it empty to get a randomly generated one or if you don't use VNC simply deactivate it via `docker run ... -e VNC_START=false` but VNC is currently set to not use encryption. This should be irrelevant as the VNC should only be accessible within your Docker host machine, if you choose to expose VNC to the outside world

## Important

Do **NOT** expose your selenium grid to the outside world (e.g. in AWS), because Selenium does not provide authentication. Therefore, if the ports are not firewalled malicious users will use [your selenium grid as a bot net](https://github.com/SeleniumHQ/docker-selenium/issues/147).

There are also additional steps you can take to ensure you're using the correct image:

### Option 1 - Check the Full Image Id

You can simply verify that image id is indeed the correct one.

    # e.g. full image id for some specific tag version
    export IMGID="<<Please see CHANGELOG.md>>"
    if docker inspect -f='{{.Id}}' elgalu/selenium:latest |grep ${IMGID} &> /dev/null; then
        echo "Image ID tested ok"
    else
        echo "Image ID doesn't match"
    fi

### Option 2 - Use immutable image digests

Given docker.io currently allows to push the same tag image twice this represent a security concern but since docker >= 1.6.2 is possible to fetch the digest sha256 instead of the tag so you can be sure you're using the exact same docker image every time:

    # e.g. sha256 for some specific tag
    export SHA=<<Please see CHANGELOG.md>>
    docker pull elgalu/selenium@sha256:${SHA}

You can find all digests sha256 and image ids per tag in the [CHANGELOG](./CHANGELOG.md) so as of now you just need to trust the sha256 in the CHANGELOG. Bullet proof is to fork this project and build the images yourself if security is a big concern.
