#!/usr/bin/env bash

# Remove lock files, thanks @garagepoort

file="/tmp/.X??-lock"

if [ -f ${file} ] ; then
  echo "-- INFO: Lock {file}: ${file} FOUND"
  rm -f ${file} || sudo rm -f ${file} || true
  echo "-- INFO: Lock {file}: ${file} REMOVED"
else
  echo "-- INFO: No lock files ${file} found"
fi
