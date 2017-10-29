#!/usr/bin/env bash

set +e

# After transferring the logs: Kill unclosed browsers, if any
killall --ignore-case --quiet --regexp "chrome.*"
killall --ignore-case --quiet --regexp "geckodriver.*"
killall --ignore-case --quiet --regexp "firefox.*"
# Kill any open notifications so the next test does not see them
killall --ignore-case --quiet --regexp "xfce4-notifyd.*"

# After transferring the logs: reset them for the next test
for filename in /var/log/cont/*.log; do
  truncate -s 0 ${filename} || echo "WARN: Failed to truncate ${filename}"
done
