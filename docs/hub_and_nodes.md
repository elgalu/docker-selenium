## Grid
You can launch a grid only container via environment variables.

## Hub
Port numbers are completely arbitrary, SELENIUM_HUB_PORT port will be `4444`.

    docker run -d --name=hub -e GRID=true -e CHROME=false -e FIREFOX=false \
      -e SELENIUM_HUB_PORT=4444 -p 4444:4444 \
      elgalu/selenium && docker exec hub wait_all_done 30s

The important part above is `-e CHROME=false -e FIREFOX=false` which tells the docker image not run run default chorme and firefox nodes turning the container into a grid-only one.

This is how it should look like so far:

![docker-empty-selenium-grid](../images/empty_grid_console.png)

## Node
You can launch a node only container via environment variables.
To enable remote networking access is important to set `SELENIUM_NODE_HOST` as this is the way the Hub (aka Grid) is able to find the node IP addresses.

### Chrome
Port numbers are completely arbitrary, VNC port will be `5940` and Selenium node port will be `25550` in this example.

    docker run -d --name=node_ch -e GRID=false -e CHROME=true -e FIREFOX=false \
      -e SELENIUM_NODE_CH_PORT=25550 -p 25550:25550 \
      -e VNC_PORT=5940 -p=5940:5940 -e VNC_PASSWORD=hola \
      -e SELENIUM_HUB_HOST=docker.host \
      -e SELENIUM_HUB_PORT=4444 \
      -e SELENIUM_NODE_HOST=docker.host \
      -v /dev/shm:/dev/shm \
      elgalu/selenium && docker exec node_ch wait_all_done 30s

The important part above is `-e GRID=false` which tells the container to be a node-only node, this this case with 2 browsers `-e CHROME=true -e FIREFOX=true` but could be just 1.

Note `SELENIUM_HUB_HOST` and `SELENIUM_NODE_HOST` represent a network firewall config challenge when running on different machines and should be changed to the proper host names or IP addresses of those.

![docker-selenium-chrome-node](../images/chrome_grid_console.png)

### Firefox
Port numbers are completely arbitrary, VNC port will be `5940` and Selenium node port will be `25550` in this example.

    docker run -d --name=node_ff -e GRID=false -e CHROME=false -e FIREFOX=true \
      -e SELENIUM_NODE_FF_PORT=25551 -p 25551:25551 \
      -e VNC_PORT=5960 -p=5960:5960 -e VNC_PASSWORD=hola \
      -e SELENIUM_HUB_HOST=docker.host \
      -e SELENIUM_HUB_PORT=4444 \
      -e SELENIUM_NODE_HOST=docker.host \
      -v /dev/shm:/dev/shm \
      elgalu/selenium && docker exec node_ff wait_all_done 30s

![docker-selenium-firefox-node](../images/firefox_grid_console.png)

### Grid and Nodes on the same network interface
Docker has a first class citizen networking feature that can be used.
WIP ... writing
