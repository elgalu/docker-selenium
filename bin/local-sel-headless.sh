#!/usr/bin/env bash

JAVA_OPTS="$(java-dynamic-memory-opts.sh)"
echo INFO: JAVA_OPTS are "$JAVA_OPTS"

java $JAVA_OPTS \
    -jar /opt/selenium/selenium-server-standalone.jar \
    -port $SELENIUM_PORT 2>&1 | tee $SELENIUM_LOG
