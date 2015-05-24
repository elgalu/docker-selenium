#!/usr/bin/env bash

RUNAS="sudo -E HOME=/home/$NORMAL_USER -u $NORMAL_USER $BIN_UTILS/start.sh"
WHOAMI=$(whoami)
WHOAMI_EXIT_CODE=$?

echo "-- INFO: Container USER var is: '$USER', \$(whoami) returns '$WHOAMI', UID is '$UID'"

if [ $WHOAMI_EXIT_CODE != 0 ]; then
  if [ $UID != $NORMAL_USER_UID]; then
    echo "-- WARN: UID '$UID' is different from the expected '$NORMAL_USER_UID'"
    echo "-- INFO: Will try to fix uid before continuing"
    # TODO: fix it ...
    echo "-- now will try to use NORMAL_USER: '$NORMAL_USER' to continue"
    exec $RUNAS
  else
    echo "-- WARN: You seem to be running docker -u {{some-non-existing-user-in-container}}"
    echo "-- will try to use NORMAL_USER: '$NORMAL_USER' instead."
    exec $RUNAS
  fi
elif [ "$WHOAMI" = "root" ]; then
  echo "-- WARN: Container running user is 'root' so switching to less privileged one"
  echo "-- will use NORMAL_USER: '$NORMAL_USER' instead."
  exec $RUNAS
else
  echo "-- INFO: Will use \$USER '$USER' and \$(whoami) is '$WHOAMI'"
  exec $BIN_UTILS/start.sh
fi

# Note: sudo -i creates a login shell for someUser, which implies the following:
# - someUser's user-specific shell profile, if defined, is loaded.
# - $HOME points to someUser's home directory, so there's no need for -H (though you may still specify it)
# - the working directory for the impersonating shell is the someUser's home directory.
