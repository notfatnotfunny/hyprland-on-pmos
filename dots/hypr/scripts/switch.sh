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
	notify-send "exception: $CURR isn't readable for some reason [maybe it doesn't exist]. Creatig the default link to $VOL"
	ln -sf "$VOL" "$CURR"
	if grep "pactl" "$CURR" &>/dev/null; then
		notifiy-send "the link is now working!"
	else
		notify-send "the link is not working :("
	fi
fi


