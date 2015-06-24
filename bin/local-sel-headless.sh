#!/usr/bin/env bash

JAVA_OPTS="$(java-dynamic-memory-opts.sh) ${JAVA_OPTS}"
echo "INFO: JAVA_OPTS are '${JAVA_OPTS}'"

java ${JAVA_OPTS} \
    -jar ${SEL_HOME}/selenium-server-standalone.jar \
    -port ${SELENIUM_PORT} ${SELENIUM_PARAMS}
