# Usage
#  make setup #first time
#  make chrome=3 firefox=5
#   note is destructive, firsts `compose down`
#   warns if your service is not listed in the `docker-compose.yml`
#  make down
#
# All in one
#  make setup compose chrome=3 firefox=5 see browser=firefox node=5
#
# Contributing
#  export TESTING_MAKE=true proj=leo nodes=2
#  make chrome=2 firefox=2 && make seeall dock
ifeq ($(OS),Windows_NT)
$(error Windows is not currently supported)
endif

export GIT_BASE_URL ?= https://raw.githubusercontent.com/elgalu/docker-selenium
export GIT_TAG_OR_BRANCH ?= latest

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
export VNC_CLIENT := vncviewer
endif
ifeq ($(UNAME_S),Darwin)
export VNC_CLIENT := /Applications/RealVNC/VNC Viewer.app/Contents/MacOS/vncviewer
endif

default: compose

get: .env

.env:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/.env"

include .env

ECHOERR=sh -c 'awk " BEGIN { print \"-- ERROR: $$1\" > \"/dev/fd/2\" }"' ECHOERR
# TODO: Output warning in color: yellow
ECHOWARN=sh -c 'awk " BEGIN { print \"-- WARN: $$1\" > \"/dev/fd/2\" }"' ECHOWARN

docker-compose.yml:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/docker-compose.yml"

mk/install_vnc.sh:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/mk/install_vnc.sh" \
	  -O mk/install_vnc.sh
	chmod +x mk/install_vnc.sh

mk/install_wmctrl.sh:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/mk/install_wmctrl.sh" \
	  -O mk/install_wmctrl.sh
	chmod +x mk/install_wmctrl.sh

mk/vnc_cask.rb:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/mk/vnc_cask.rb" \
	  -O mk/vnc_cask.rb

mk/see.sh:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/mk/see.sh" \
	  -O mk/see.sh
	chmod +x mk/see.sh

mk/move.sh:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/mk/move.sh" \
	  -O mk/move.sh
	chmod +x mk/move.sh

mk/wait.sh:
	wget -nv "${GIT_BASE_URL}/${GIT_TAG_OR_BRANCH}/mk/wait.sh" \
	  -O mk/wait.sh
	chmod +x mk/wait.sh

install_vnc:
	./mk/install_vnc.sh

install_wmctrl:
	./mk/install_wmctrl.sh

mk:
	mkdir -p mk

docker:
	@if ! docker --version; then \
	  ${ECHOERR} "We need docker installed" ; \
	  ${ECHOERR} "google: 'install docker'" ; \
	  exit 1; \
	fi

docker-compose:
	@if ! docker-compose --version; then \
	  ${ECHOERR} "We need docker installed" ; \
	  ${ECHOERR} "google: 'install docker-compose'" ; \
	  exit 1; \
	fi

pull:
	@# Only pull for end users, not CI servers or repo owners
	@if [ "${TESTING_MAKE}" != "true" ]; then \
	  echo "Pulling latest version of docker-selenium..." ; \
	  docker pull elgalu/selenium:${DOCKER_SELENIUM_TAG} ; \
	fi

warn_vncviewer:
	@# Only check if not in a CI server
	@if [ "${BUILD_NUMBER}" = "" ]; then \
	  if ! eval ${VNC_CHECK_CMD}; then \
	    ${ECHOWARN} ${VNC_CLIENT_ERROR_MSG} ; \
	    ${ECHOWARN} "  RUN: make install_vnc" ; \
	  fi ; \
	fi

check_vncviewer:
	@if ! eval ${VNC_CHECK_CMD}; then \
	  ${ECHOERR} ${VNC_CLIENT_ERROR_MSG} ; \
	  exit 4; \
	fi

warn_wmctrl:
	@# Only check if not in a CI server
	@if [ "${BUILD_NUMBER}" = "" ]; then \
	  if ! eval ${WMCTRL_CHECK_CMD} >/dev/null; then \
	    ${ECHOWARN} ${WMCTRL_CLIENT_ERROR_MSG} ; \
	    ${ECHOWARN} "  RUN: make install_wmctrl" ; \
	  fi ; \
	fi

check_wmctrl:
	@if [ $(shell uname -s) = 'Darwin' ]; then \
	  echo "Sorry: moving windows with wmctrl in OSX is not upported." 1>&2 ; \
	  exit 11 ; \
	fi
	@if ! eval ${WMCTRL_CHECK_CMD} >/dev/null; then \
	  ${ECHOERR} ${WMCTRL_CLIENT_ERROR_MSG} ; \
	  exit 5; \
	fi

see: check_vncviewer
	./mk/see.sh &

# Shortcut to VNC into Chrome
seech:
	@$(MAKE) -s see browser=chrome

# Shortcut to VNC into Firefox
seeff:
	@$(MAKE) -s see browser=firefox

env:
	env

basic_reqs: docker-compose.yml .env mk mk/wait.sh mk/move.sh docker docker-compose

# Gather all requisites
setup: .env basic_reqs mk/install_vnc.sh mk/vnc_cask.rb mk/see.sh mk/install_wmctrl.sh warn_vncviewer warn_wmctrl pull
	@echo "Requirements checked."

cleanup:
	@echo -n "Stopping and removing ${COMPOSE_PROJ_NAME}..."
	@docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} down \
	  --remove-orphans >./mk/compose_down.log 2>&1
	@echo "Done!"

# like cleanup but verbose plus graceful stop-video
down:
	@if [ "${VIDEO}" = "true" ]; then \
	  $(MAKE) -s stop_videos_chrome ; \
	  $(MAKE) -s stop_videos_firefox ; \
	fi
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} down \
	  --remove-orphans

stop_videos:
	@for node in $(shell seq -s ' ' 1 ${tot_nodes}); do \
	  docker exec "${proj}_${browser}_$$node" stop-video \
	    >./mk/stop_video_${browser}_$$node.log || true ; \
	done

stop_videos_chrome:
	@$(MAKE) -s stop_videos browser=chrome tot_nodes=${chrome}

stop_videos_firefox:
	@$(MAKE) -s stop_videos browser=firefox tot_nodes=${firefox}

scale:
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} scale \
	  ${APP_NAME}=1 hub=1 chrome=${chrome} firefox=${firefox}
	@$(MAKE) -s wait chrome=${chrome} firefox=${firefox}

compose: basic_reqs cleanup
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} up -d
	@$(MAKE) -s scale chrome=${chrome} firefox=${firefox}

wait:
	./mk/wait.sh

# Move VNC windows targeting by DISPLAY given is unique, e.g.
#  wmctrl -r ":87 - VNC Viewer" -e 1,0,0,-1,-1
move: check_wmctrl
	./mk/move.sh

gather_videos:
	mkdir -p ./videos
	@for node in $(shell seq -s ' ' 1 ${tot_nodes}); do \
	  docker exec "${proj}_${browser}_$$node" stop-video \
	    >./mk/stop_video_${browser}_$$node.log || true ; \
	  docker cp "${proj}_${browser}_$$node:/videos/." videos ; \
	  docker exec "${proj}_${browser}_$$node" rm_videos || true ; \
	  docker exec "${proj}_${browser}_$$node" start-video ; \
	done
	ls -la ./videos/

gather_videos_chrome:
	@$(MAKE) -s gather_videos browser=chrome tot_nodes=${chrome}

gather_videos_firefox:
	@$(MAKE) -s gather_videos browser=firefox tot_nodes=${firefox}

# Gather video artifacts
videos: gather_videos_chrome gather_videos_firefox

# VNC open all. As of now only 4 are supported
seeall: check_vncviewer
	@$(MAKE) -s see browser=chrome node=1
	@sleep 0.3
	@$(MAKE) -s see browser=firefox node=1

# Move them all. As of now only 4 are supported
dock: check_wmctrl
	@sleep 0.2 #TODO Make active wait: http://stackoverflow.com/a/19441380/511069
	@$(MAKE) -s move browser=chrome node=1
	@sleep 0.2 #TODO Make active wait
	@$(MAKE) -s move browser=firefox node=1

# Run self tests
test:
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} exec \
	  --index 1 hub run_test

# PHONY: Given make doesn't execute a task if there is an existing file
# with that task name, .PHONY is used to skip that logic listing task names
.PHONY: \
	default \
	docker \
	docker-compose \
	pull \
	setup \
	basic_reqs \
	check_vncviewer \
	warn_vncviewer \
	warn_wmctrl \
	check_wmctrl \
	vncviewer \
	vnc \
	see \
	install_vnc \
	install_wmctrl \
	scale \
	seeff \
	seech \
	compose \
	wait \
	down \
	cleanup \
	move \
	videos \
	gather_videos \
	gather_videos_chrome \
	gather_videos_firefox \
	stop_videos \
	stop_videos_chrome \
	stop_videos_firefox \
	env \
	test
