# Usage
#  make setup #first time
#  make chrome=3 firefox=5
#   note is destructive, firsts `compose down`
#   warns if your service is not listed in the `docker-compose.yml`
#  make cleanup
#
# All in one
#  make setup compose chrome=3 firefox=5 see browser=firefox node=5
include .env

ECHOERR=sh -c 'awk " BEGIN { print \"-- ERROR: $$1\" > \"/dev/fd/2\" }"' ECHOERR
# TODO: Output warning in color: yellow
ECHOWARN=sh -c 'awk " BEGIN { print \"-- WARN: $$1\" > \"/dev/fd/2\" }"' ECHOWARN

default: compose

docker-compose.yml:
	wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/docker-compose.yml"

.env:
	wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/.env"

mk/install_vnc.sh:
	wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/mk/install_vnc.sh" \
	  -O mk/install_vnc.sh

mk/vnc_cask.rb:
	wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/mk/vnc_cask.rb" \
	  -O mk/vnc_cask.rb

mk/see.sh:
	wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/mk/see.sh" \
	  -O mk/see.sh

mk/wait.sh:
	wget -nv "https://raw.githubusercontent.com/elgalu/docker-selenium/latest/mk/wait.sh" \
	  -O mk/wait.sh

install_vnc:
	./mk/install_vnc.sh

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
	# Only pull for end users
	@if [ "${TESTING}" != "true" ]; then \
	  docker pull elgalu/selenium:latest > mk/docker-pull.log ; \
	fi

warn_vncviewer:
	# Only check if not in a CI server
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

see: check_vncviewer
	./mk/see.sh &

# Shortcut to VNC into Firefox
seeff:
	$(MAKE) see browser=firefox

# Shortcut to VNC into Chrome
seech:
	$(MAKE) see browser=chrome

env:
	env

basic_reqs: docker-compose.yml .env mk mk/wait.sh docker docker-compose

# Gather all requisites
setup: basic_reqs mk/install_vnc.sh mk/vnc_cask.rb mk/see.sh warn_vncviewer pull
	@echo "Requirements checked."

cleanup:
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} down \
	  --remove-orphans >./mk/compose_down.log 2>&1

# Alias
down: cleanup

scale:
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} scale \
	  ${APP_NAME}=1 hub=1 chrome=${chrome} firefox=${firefox}
	$(MAKE) wait chrome=${chrome} firefox=${firefox}

compose: basic_reqs cleanup
	docker-compose -f ${COMPOSE_FILE} -p ${COMPOSE_PROJ_NAME} up -d
	$(MAKE) scale chrome=${chrome} firefox=${firefox}

wait:
	./mk/wait.sh

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
	vncviewer \
	vnc \
	see \
	install_vnc \
	scale \
	seeff \
	seech \
	compose \
	wait \
	down \
	cleanup \
	env \
	test
