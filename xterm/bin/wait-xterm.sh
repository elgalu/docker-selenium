#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Waiting for docker-selenium to finish starting..."
while ! grep 'Container docker internal IP' \
             /var/log/sele/xterm-stdout.log > /dev/null 2>&1; do
  echo -n '.'
  sleep 0.2;
done

echo "Done wait-xterm.sh"
