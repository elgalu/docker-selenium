#!/usr/bin/env bash

sudo -E sh -c 'cat /tmp/hosts >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  docker.host"        >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    docker.guest"       >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  docker.host.dev"    >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  d.host.loc.dev"     >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    docker.guest.dev"   >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  host.docker.local"  >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    guest.docker.local" >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    d.guest.loc.dev"    >> /etc/hosts'
sudo -E sh -c 'echo "$DOCKER_HOST_IP  host.docker"        >> /etc/hosts'
sudo -E sh -c 'echo "$CONTAINER_IP    guest.docker"       >> /etc/hosts'
