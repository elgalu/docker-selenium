#!/usr/bin/env bash

# Remove lock files, thanks @garagepoort

file="/tmp/.X??-lock"

echo "Looking for lock file: $file"
if [ -f $file ] ; then
  echo "Lock file: $file FOUND"
  rm $file
  echo "Lock file: $file REMOVED"
fi
