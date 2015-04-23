#!/usr/bin/env bash

java -jar /opt/selenium/selenium-server-standalone.jar -port $SELENIUM_PORT 2>&1 | tee $SELENIUM_LOG
