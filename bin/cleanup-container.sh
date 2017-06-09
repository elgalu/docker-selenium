#!/usr/bin/env bash

set +e

# if [ -z "${CHROME}" ]; then
#     if [ -f CHROME ]; then
#         export CHROME="$(cat CHROME)"
#     else
#         # fallback guard
#         export CHROME="true"
#     fi
# fi

# This is currently not working well
# if [ "${CHROME}" == "true" ]; then
#     # Try to retrieve Chrome Browser console logs when using this image through Zalenium
#     cp /home/seluser/chrome-user-data-dir/chrome_debug.log /var/log/cont/chrome_browser.log
# fi

# After transferring the logs: Kill unclosed browsers, if any
killall --ignore-case --quiet --regexp "chrome.*"
killall --ignore-case --quiet --regexp "geckodriver.*"
killall --ignore-case --quiet --regexp "firefox.*"
# killall --ignore-case --quiet --regexp "firefox.*" -9

# After transferring the logs: reset them for the next test
for filename in /var/log/cont/*.log; do
  truncate -s 0 $filename
done
