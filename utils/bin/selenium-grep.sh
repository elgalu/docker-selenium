#!/usr/bin/env bash

grep -v "webSocketsHandshake" /var/log/sele/* | \
  grep -v "errors, etc) it may be disabled" | \
  grep -i "error" -B 3 -A 3
