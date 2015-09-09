#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

auth_keys_path="${HOME}/.ssh/authorized_keys"

# Authorize ssh user if $SSH_AUTH_KEYS was provided
[ -z "${HOME}" ] && die "Need (\$HOME) to be set" 6
if [ ! -z "${SSH_AUTH_KEYS}" ];then
  echo "INFO: \$SSH_AUTH_KEYS detected! will add to ${auth_keys_path}"
  echo ${SSH_AUTH_KEYS} >> ${auth_keys_path}
fi

# Start ssh server. Unfortunately needs sudo
# -e Write debug logs to standard error instead of the system log
# -D will not detach and does not become a daemon allowing easy monitoring
# -p Specifies the port on which the server listens for connections (default 22)
echo "INFO: Starting OpenSSH server..."
# TODO: Add active wait to validate sshd started and works
sudo /usr/sbin/sshd -e -D -p ${SSHD_PORT}
