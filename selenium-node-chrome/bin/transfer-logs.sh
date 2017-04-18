#!/usr/bin/env bash

# Try to retrieve Chrome Browser console logs when using this image through Zalenium
cp /home/seluser/chrome-user-data-dir/chrome_debug.log /var/log/cont/chrome_browser.log
