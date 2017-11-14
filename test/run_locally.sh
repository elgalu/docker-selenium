#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

run_sequence() {
  ./test/bef
  ./test/script_run_all_tests
  ./test/script_archive
}

# Not all environments have the `time` command installed
if which time >/dev/null 2>&1; then
  time (run_sequence)
else
  run_sequence
fi

git checkout scm-source.json
