#!/usr/bin/bash
set -e

VOL="/home/user/.config/hypr/scripts/volume.conf"
BRI="/home/user/.config/hypr/scripts/brightness.conf"
CURR="/home/user/.config/hypr/scripts/active.conf"

if grep "pactl" "$CURR" &>/dev/null; then
	ln -sf "$BRI" "$CURR"
	notify-send "brightness mode"
elif grep "brightnessctl" "$CURR" &>/dev/null; then
	ln -sf "$VOL" "$CURR"
	notify-send "volume mode"
else 
	echo "exception: $CURR is linked to neither $VOL nor $BRI"
fi


