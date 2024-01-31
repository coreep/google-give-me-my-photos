#!/bin/bash
set -e
set -o

source /etc/profile

if [ $# -eq 0 ]
  then
    # Start the VNC server
    vncserver :1 -geometry $VNC_RESOLUTION -depth $VNC_COL_DEPTH -verbose -SecurityTypes None

    # Start noVNC
    /usr/share/novnc/utils/launch.sh --listen $NOVNC_PORT --vnc localhost:$VNC_PORT
  else
    exec "$@"
fi
