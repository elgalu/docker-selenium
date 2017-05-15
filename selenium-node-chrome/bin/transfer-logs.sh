#!/usr/bin/env bash

if [ -z "${CHROME}" ]; then
    if [ -f CHROME ]; then
        export CHROME="$(cat CHROME)"
    else
        # fallback guard
        export CHROME="true"
    fi
fi

# This is currently not working well
# if [ "${CHROME}" == "true" ]; then
#     # Try to retrieve Chrome Browser console logs when using this image through Zalenium
#     cp /home/seluser/chrome-user-data-dir/chrome_debug.log /var/log/cont/chrome_browser.log
# fi
