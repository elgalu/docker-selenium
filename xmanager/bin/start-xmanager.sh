#!/usr/bin/env bash

#----------------
# Alternative 1.
# Openbox is a lightweight window manager using freedesktop standards
openbox-session

#----------------
# Alternative 2.
# Fluxbox is a fast, lightweight and responsive window manager
# fluxbox -display ${DISPLAY}

#----------------
# Alternative 3.
# GNOME Shell provides core interface functions like switching windows,
#  launching applications or see your notifications
# gnome-shell -display ${DISPLAY}

#----------------
# Alternative 4.
# GNOME ubuntu desktop; The fat and full featured windows manager
# /etc/X11/Xsession &
# gnome-session &

#----------------
# Alternative 5.
# Not working: LXDE is a Lightweight X11 Desktop Environment
# lxde -display ${DISPLAY}

#----------------
# Alternative 6.
# lightdm is a fat and full featured windows manager
# lightdm-session

# Note to double pipe output and keep this process logs add at the end:
#  2>&1 | tee $XMANAGER_LOG
# But is no longer required because individual logs are maintained by
# supervisord right now.
