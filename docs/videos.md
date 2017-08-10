# Video Recording

## Step by step

### Pull
Pull image

    docker pull elgalu/selenium

### Run
Run a new grid

    docker run --rm --name=grid -p 4444:24444 -p 5920:25900 \
      --shm-size=1g -e VNC_PASSWORD=hola \
      -e VIDEO=true elgalu/selenium

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
    docker exec grid stop
    docker stop grid

### View
Check your video, note it may be splitted in many files if is too long

    vlc videos/test.mp4

## Customizations

### Start
Start and stop on-demand

    docker exec grid start-video

Now run your tests

Then stop. Follow the steps in the [Stop](#stop) section
