#!/usr/bin/env bash

# Note: In OSX use docker.for.mac.localhost

cat /tmp/hosts >> /etc/hosts

if [ "${DOCKER_HOST_IP}" != "" ]; then
  echo "${DOCKER_HOST_IP}  docker.host"        >> /etc/hosts
  echo "${DOCKER_HOST_IP}  docker.host.dev"    >> /etc/hosts
  echo "${DOCKER_HOST_IP}  d.host.loc.dev"     >> /etc/hosts
  echo "${DOCKER_HOST_IP}  host.docker.local"  >> /etc/hosts
  echo "${DOCKER_HOST_IP}  host.docker"        >> /etc/hosts
fi

if [ "${CONTAINER_IP}" != "" ]; then
  echo "${CONTAINER_IP}    docker.guest"       >> /etc/hosts
  echo "${CONTAINER_IP}    docker.guest.dev"   >> /etc/hosts
  echo "${CONTAINER_IP}    guest.docker.local" >> /etc/hosts
  echo "${CONTAINER_IP}    d.guest.loc.dev"    >> /etc/hosts
  echo "${CONTAINER_IP}    guest.docker"       >> /etc/hosts
fi
