#!/usr/bin/env bash

# Echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&2;
}

# Print error and exit
die () {
  local error_msg=$1
  local opt_exit_code=$2

  echoerr "ERROR: $error_msg"
  # if $opt_exit_code is defined AND NOT EMPTY, use
  # $opt_exit_code; otherwise, set to "1"
  local errnum=${opt_exit_code-1}
  exit $errnum
}

[ -z "$GUACAMOLE_HOME" ] && die "Need (\$GUACAMOLE_HOME) to be set" 1
[ -z "$GUACAMOLE_SERVER_PORT" ] && die "Need (\$GUACAMOLE_SERVER_PORT) to be set" 2

guacamole_props_file="${GUACAMOLE_HOME}/guacamole.properties"
guacamole_usermappings_file="${GUACAMOLE_HOME}/user-mappings.xml"

cat >${guacamole_props_file} <<EOF
guacd-hostname: localhost
guacd-port: ${GUACAMOLE_SERVER_PORT}
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: ${GUACAMOLE_HOME}/user-mappings.xml
EOF

echo "INFO: Generated content for guacamole file: ${guacamole_props_file}"
echo "INFO: content-start"
cat ${guacamole_props_file}
echo "INFO: content-end"

cat >${guacamole_usermappings_file} <<EOF
<user-mapping>
    <authorize username="docker" password="${VNC_PASSWORD}">
        <protocol>vnc</protocol>
        <param name="hostname">localhost</param>
        <param name="port">${VNC_PORT}</param>
        <param name="password">${VNC_PASSWORD}</param>
    </authorize>
</user-mapping>
EOF

echo "INFO: Generated content for guacamole file: ${guacamole_usermappings_file}"
echo "INFO: content-start"
cat ${guacamole_usermappings_file}
echo "INFO: content-end"
