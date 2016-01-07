# Video Recording

## Step by step

### Pull
Pull image

    docker pull elgalu/selenium:2.48.2k

### Run
Run a new grid

    docker run --rm --name=grid -p 4444:24444 -p 5920:25900 \
      -v /dev/shm:/dev/shm -e VNC_PASSWORD=hola \
      -e VIDEO=true elgalu/selenium:2.48.2k

### Wait
Wait for the grid to start

    docker exec grid wait_all_done 30s

## Check
Check your grid has Chrome and Firefox.
OSX: replace `localhost` with `boot2docker ip` or `docker-machine ip default`.

    open http://localhost:4444/grid/console

### Test
Run your tests

    #at http://localhost:4444/wd/hub

### Stop
Stopping the grid will also stop video recording and close the file properly.
However is better to stop the video service first then copy the videos to the host machine.

    docker exec grid stop-video
    mkdir -p ./videos
    docker cp grid:/videos/. videos

### Finalize
    docker stop grid

### View
Check your video, note it may be splitted in many files if is too long

    vlc videos/test.mkv

## Customizations

### Split videos
By default is 10 mins but can be changed through `-e VIDEO_CHUNK_SECS="00:10:00"`
