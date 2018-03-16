#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
# set -u: treat unset variables as an error and exit immediately
# set -x: print each command right before it is executed
set -ex

echoerr() { printf "%s\n" "$*" >&2; }

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# Required params
[ -z "${USER}" ] && die "Need env var USER"

# Add yourself to the libvirtd group
sudo usermod -a -G libvirtd ${USER}
# Update your current session to apply the group change
# newgrp libvirtd

## Minishift binary
mkdir -p /tmp/minishift
cd /tmp/minishift
wget -nv -O minishift.tgz \
  "https://github.com/minishift/minishift/releases/download/v1.6.0/minishift-1.6.0-linux-amd64.tgz"
tar xzf minishift.tgz
./minishift version

sudo virt-manager

# sudo service libvirtd start
# sudo libvirtd

## docker-machine-driver-kvm
wget -nv -O dmdkvm \
  "https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04"
chmod +x dmdkvm
# (./dmdkvm 2>&1 | grep "invoked directly") || ./dmdkvm || echo "WARN: dmdkvm won't work"
(./dmdkvm 2>&1 | grep "invoked directly") || ./dmdkvm || true

sudo mv minishift /usr/bin/
sudo mv dmdkvm /usr/local/bin/docker-machine-driver-kvm
rm -rf /tmp/minishift/

# Start will also wget minishift-b2d.iso
# (Memory: 2GB, vCPUs: 2, Disk size: 20 GB)
sudo kvm-ok
# TravisCI: INFO: Your CPU does not support KVM extensions

# Starts a local OpenShift cluster
minishift start
minishift status | grep -i "Running"

eval $(minishift oc-env)


## Zalenium
oc login -u system:admin
