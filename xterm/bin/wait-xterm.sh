#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echo "Waiting for docker-selenium to finish starting..."
while ! grep 'Container docker internal IP' \
             /var/log/cont/xterm-stdout.log > /dev/null 2>&1; do
  echo -n '.'
  sleep 0.2;
done
