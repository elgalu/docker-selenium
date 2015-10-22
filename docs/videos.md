# Video Recording
Step by step

1) Pull image

    docker pull elgalu/selenium:2.48.2a

2) Run a new grid

    docker run --rm --name=grid -p 4444:24444 -p 5920:25900 \
      -v /dev/shm:/dev/shm -e VNC_PASSWORD=hola \
      -e VIDEO=true -v $(pwd)/videos:/videos elgalu/selenium:2.48.2a

3) Wait for the grid to start

    docker exec grid wait_all_done 30s

4) Check your grid has Chrome and Firefox

    open http://localhost:4444/grid/console

5) Run your tests

    #at http://localhost:4444/wd/hub

6) Stop the grid so video recording also stops and the file is properly closed

    docker stop grid

7) Check your video, note it may be splitted in many files if is too long

    vlc videos/test.mkv

## Customizations

### Split videos
By default is 10 mins but can be changed through `-e VIDEO_CHUNK_SECS="00:10:00"`
