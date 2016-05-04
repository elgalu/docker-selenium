#!/usr/bin/env bash

# echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&2;
}

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "1"
  errnum=${2-1}
  exit $errnum
}

# Example usage:
# exec java $(java-dynamic-memory-opts.sh) -jar myfatjar.jar

# JVM uses only 1/4 of system memory by default
# set at Dockerfile or via docker run: MEM_JAVA_PERCENT=80
# Required env vars validations
[ -z "${MEM_JAVA_PERCENT}" ] && die "Need to set env var MEM_JAVA_PERCENT"

MEM_TOTAL_KB=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
MEM_JAVA_KB=$((${MEM_TOTAL_KB} * ${MEM_JAVA_PERCENT} / 100))
[ -z "${MEM_JAVA}" ] && export MEM_JAVA="${MEM_JAVA_KB}k"

echo "-Xmx${MEM_JAVA}"
