#!/bin/sh
echo "---- Starting TigerVNC on port $VNC_PORT and noVNC on port $NOVNC_PORT"

. /etc/profile

# Start the VNC server
vncserver :1 -geometry $VNC_RESOLUTION -depth $VNC_COL_DEPTH -verbose -SecurityTypes None
# Route VNC server logs to docker stdout
tail -f /root/.vnc/*.log &> /dev/fd/1 &

if [ $# -eq 0 ]
  then
    echo "---- No custom command provided, running VNC only. Stop container manually."
    # Start noVNC
    /usr/share/novnc/utils/launch.sh --listen $NOVNC_PORT --vnc localhost:$VNC_PORT
  else
    echo "---- Provided command '$@'. Running noVNC in background"
    # Start noVNC in background
    /usr/share/novnc/utils/launch.sh --listen $NOVNC_PORT --vnc localhost:$VNC_PORT &> /dev/fd/1 &
    # Run command and wait for it to finish
    echo "---- Contianer will stop once '$@' finishes."
    exec "$@"
fi
echo "---- Exiting"
