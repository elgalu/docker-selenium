# Grouce.io
From a git repository history to [video visualization](https://youtu.be/OU7IdCSB_0E).

[![video visualization](https://i.ytimg.com/vi/OU7IdCSB_0E/hqdefault.jpg)](https://youtu.be/OU7IdCSB_0E)

## Requirements
Tested on Ubuntu 15.10

    sudo apt-get -qyy install ffmpeg libsdl2-dev libsdl2-image-dev \
      libpcre3-dev libfreetype6-dev libglew-dev libglm-dev \
      libboost-filesystem-dev libpng12-dev libtinyxml-dev

## Prepare

    wget "https://github.com/acaudwell/Gource/releases/download/gource-0.43/gource-0.43.tar.gz"
    tar xvzf gource-0.43.tar.gz
    cd gource-0.43
    ./configure && make

## Install

    sudo make install
    
## Usage

    gource -s 1 -c 2.0 -1280x720 -o gource.ppm
    ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i gource.ppm \
      -vcodec libx264 -preset medium -pix_fmt yuv420p \
      -crf 1 -threads 0 -bf 0 gource.mp4
