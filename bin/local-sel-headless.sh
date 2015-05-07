#!/usr/bin/env bash

java $(java-dynamic-memory-opts.sh) -jar /opt/selenium/selenium-server-standalone.jar -port $SELENIUM_PORT 2>&1 | tee $SELENIUM_LOG
