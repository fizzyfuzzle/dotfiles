#!/bin/bash
#
SCREEN_REAL="DP-1"
SCREEN_FAKE="HEADLESS-1"

# SWAY ENVIRONMENT
export SWAYSOCK=$(awk 'BEGIN {RS="\0"; FS="="} $1 == "SWAYSOCK" { print $2 }' /proc/$(pgrep -o swaybg)/environ)
export WAYLAND_DISPLAY=wayland-1

#swaymsg create_output $SCREEN_FAKE
#swaymsg unplug $SCREEN_FAKE

#echo "Disabling SLEEP"
#sudo systemctl mask sleep.target

echo "[SWITCHING OUTPUTS] ${SCREEN_REAL} -> ${SCREEN_FAKE}"
swaymsg output $SCREEN_FAKE enable
swaymsg output $SCREEN_REAL disable

echo "STARTING VNC ..."
wayvnc --output=HEADLESS-1 --max-fps=15 127.0.0.1 5900

echo "[SWITCHING OUTPUTS] ${SCREEN_FAKE} -> ${SCREEN_REAL}"
swaymsg output $SCREEN_REAL enable
swaymsg output $SCREEN_FAKE disable

#echo "Enabling SLEEP"
#sudo systemctl unmask sleep.target
