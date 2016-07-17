#!/usr/bin/env bash

export VNC_PORT=$(cat VNC_PORT)

# Make it portable
[ -z "${VIDEO_PATH}" ] && export \
    VIDEO_PATH="${VIDEOS_DIR}/${VIDEO_FILE_NAME}.${VIDEO_FILE_EXTENSION}"

# record testing video using password file
# using sudo due to http://stackoverflow.com/questions/23544282/
sudo vnc2swf -P ${VNC_STORE_PWD_FILE} \
        -t ${VNC2SWF_ENCODING} \
        -r ${VNC2SWF_FRAMERATE} \
        -o ${VIDEO_PATH} \
        -n 127.0.0.1 ${VNC_PORT} 2>&1
