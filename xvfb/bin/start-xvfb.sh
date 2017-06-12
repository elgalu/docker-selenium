#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# Open a new file descriptor that redirects to stdout:
exec 3>&1

function get_free_display() {
  local selected_disp_num="-1"
  local find_display_num=-1

  # Get a list of socket DISPLAYs already used
  netstat -nlp 2>/dev/null | grep -Po '(?<=\/tmp\/\.X11-unix\/X)([0-9]+)' | sort -u > /tmp/netstatX11.log
  # [ ! -s /tmp/netstatX11.log ] && echo "-- INFO: Emtpy file /tmp/netstatX11.log" 1>&3

  # important: while loops are executed in a subshell
  #  var assignments will be lost unless using <<<
  # using 11.0 12.3 1.8 and so on didn't work, left as a reference
  #  local pythonCmd="from random import shuffle;list1 = list(range($MAX_DISPLAY_SEARCH));shuffle(list1);list2 = [x/10 for x in list1];str_res = ' '.join(str(e) for e in list2);print (str_res)"
  local pythonCmd="from random import shuffle;list1 = list(range($MAX_DISPLAY_SEARCH));shuffle(list1);print (' '.join(str(e) for e in list1))"
  local displayNums=$(python -c "${pythonCmd}")
  # Always find a free DISPLAY port starting with current DISP_N if it was provided
  [ "${DISP_N}" != "-1" ] && displayNums="${DISP_N} ${displayNums}"
  IFS=' ' read -r -a arrayDispNums <<< "$displayNums"
  for find_display_num in ${arrayDispNums[@]}; do
    # read -r Do not treat a backslash character in any special way.
    #         Consider each backslash to be part of the input line.
    # -s  file is not zero size
    if [ -s /tmp/netstatX11.log ]; then
      while read read_disp_num ; do
        if [ "${read_disp_num}" = "${find_display_num}" ]; then
          echo "-- WARN: DISPLAY=:${find_display_num} is taken, searching for another..." 1>&3
          selected_disp_num="-1"
          break
        elif [ "${selected_disp_num}" = "-1" ]; then
          selected_disp_num="${find_display_num}"
          echo "-- INFO: Possible free DISPLAY=:${find_display_num}" 1>&3
          # echo "-- DEBUG: Updated selected_disp_num=$selected_disp_num" 1>&3
          # echo "-- DEBUG: WAS read_disp_num=$read_disp_num" 1>&3
        fi
      done <<< "$(cat /tmp/netstatX11.log)"
    else
      # echo "-- INFO: Emtpy file /tmp/netstatX11.log" 1>&3
      # selected_disp_num="${DEFAULT_DISP_N}"
      selected_disp_num="${find_display_num}"
    fi
    if [ "${selected_disp_num}" != "-1" ]; then
      # If we can already use that display it means there is already some
      # Xvfb there which means we need to keep looking for a free one.
      export DISPLAY=":${find_display_num}"
      echo "${DISPLAY}" > DISPLAY
      echo "${DISP_N}" > DISP_N
      if xsetroot -cursor_name left_ptr -fg white -bg black > /dev/null 2>&1; then
        echo "-- WARN: DISPLAY=:${find_display_num} is already being used, skip it..." 1>&3
        selected_disp_num="-1"
      fi
    fi
    if [ "${selected_disp_num}" != "-1" ]; then
      break
    elif [ ${find_display_num} -gt ${MAX_DISPLAY_SEARCH} ]; then
      echo "-- ERROR: Entered in an infinite loop at $0 after netstat" 1>&2 1>&3
      selected_disp_num="-1"
      break
    fi
  done
  [ "${selected_disp_num}" = "-1" ] #|| echo "-- INFO: Found free DISPLAY=:${selected_disp_num}" 1>&3

  export DISPLAY=":${selected_disp_num}"
  echo "${DISPLAY}" > DISPLAY
  echo "${DISP_N}" > DISP_N
  echo ${selected_disp_num}
}

function start_xvfb() {
  # Start the X server that can run on machines with no real display
  # using Xvfb instead of Xdummy
  # echo "-- INFO: Will try to start Xvfb at DISPLAY=${DISPLAY}" 1>&3
  # if DEBUG = true ...
  # echo "Will use the following values for Xvfb"
  # echo "  screen=${SCREEN_NUM} geometry=${GEOMETRY}"
  # echo "  XVFB_CLI_OPTS_TCP=${XVFB_CLI_OPTS_TCP}"
  # echo "  XVFB_CLI_OPTS_BASE=${XVFB_CLI_OPTS_BASE}"
  # echo "  XVFB_CLI_OPTS_EXT=${XVFB_CLI_OPTS_EXT}"
  Xvfb ${DISPLAY} -screen ${SCREEN_NUM} ${GEOMETRY} \
    ${XVFB_CLI_OPTS_TCP} ${XVFB_CLI_OPTS_BASE} ${XVFB_CLI_OPTS_EXT} \
    1> "${LOGS_DIR}/xvfb-tryouts-stdout.log" \
    2> "${LOGS_DIR}/xvfb-tryouts-stderr.log" &
}

if [ ! -z "${XE_DISP_NUM}" ]; then
  echo "INFO: XE_DISP_NUM '${XE_DISP_NUM}' was provided so switching to that DISPLAY"
  echo "INFO:   and skipping virtual framebuffer startup in favor of remote."
  export DISP_N="${XE_DISP_NUM}"
  export DISPLAY=":${DISP_N}"
  start_xvfb
# elif [ "${PICK_ALL_RANDOM_PORTS}" = "true" ] || [ "${DISP_N}" = "-1" ]; then
else
  # Find a free DISPLAY port starting with current DISP_N if any
  i=0
  while true ; do
    let i=${i}+1
    export DISP_N=$(get_free_display)
    export DISPLAY=":${DISP_N}"
    echo "${DISPLAY}" > DISPLAY
    echo "${DISP_N}" > DISP_N
    export XEPHYR_DISPLAY=":${DISP_N}"
    if ! start_xvfb; then
      echo "-- WARN: start_xvfb() failed!" 1>&3
    fi
    if timeout --foreground "${WAIT_FOREGROUND_RETRY}" wait-xvfb.sh &> "${LOGS_DIR}/wait-xvfb-stdout.log"; then
      break
    else
      echo "-- WARN: wait-xvfb.sh failed! for DISPLAY=${DISPLAY}" 1>&3
    fi
    if [ ${i} -gt ${MAX_DISPLAY_SEARCH} ]; then
      echo "-- ERROR: Failed to start Xvfb at $0 after many retries." 1>&2 1>&3
      break
    fi
  done
fi

# Validations
if [ ":$DISP_N" != "${DISPLAY}" ]; then
  echo "FATAL: DISP_N '${DISP_N}' doesn't match DISPLAY '${DISPLAY}'" 1>&2
  exit 122
fi
