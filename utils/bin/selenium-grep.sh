#!/usr/bin/env bash

grep -v "webSocketsHandshake" /var/log/sele/* | \
  grep -v "errors, etc) it may be disabled" | \
  grep "rror" -B 3 -A 5
