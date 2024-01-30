#!/bin/bash
set -e
set -o

# Start the VNC server
vncserver :1 -geometry $VNC_RESOLUTION -depth $VNC_COL_DEPTH -verbose

# Start noVNC
/usr/share/novnc/utils/launch.sh --listen $NOVNC_PORT --vnc localhost:$VNC_PORT
