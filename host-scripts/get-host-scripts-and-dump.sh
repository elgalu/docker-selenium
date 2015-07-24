#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

BASEURL="https://github.com/elgalu/docker-selenium"
CURVERSION="2.46.0-06"
HSVERDIR="docker-selenium-${CURVERSION}/host-scripts"

if [ ! -f "${CURVERSION}.zip" ]; then
  wget -nv "${BASEURL}/archive/${CURVERSION}.zip"
fi

if [ ! -d "${HSVERDIR}" ]; then
  unzip ${CURVERSION}.zip "${HSVERDIR}/*"
fi

ln -sf ${HSVERDIR} host-scripts

if [ -f "${CURVERSION}.zip" ]; then
  rm ${CURVERSION}.zip
fi

for i in $(seq 0 3); do
  FILENAME="${CURVERSION}.tar--part0${i}"
  DOWNPART="${BASEURL}/releases/download/${CURVERSION}/${FILENAME}"
  if [ ! -f "${FILENAME}" ]; then
    echo "Downloading '${FILENAME}' ..."
    wget -nv "${DOWNPART}"
  fi
done

# Join
if [ ! -f "${CURVERSION}.tar" ]; then
  echo "Joining ${CURVERSION}.tar parts..."
  cat ${CURVERSION}.tar--part* > ${CURVERSION}.tar
fi
