#!/bin/sh

sink='@DEFAULT_AUDIO_SINK@'

case "$1" in
	up) wpctl set-volume -l 1.5 "$sink" 5%+ && wpctl set-mute "$sink" 0 ;;
	down)
		wpctl set-volume "$sink" 5%- || exit
		set -- $(wpctl get-volume "$sink")
		[ "$2" != 0.00 ]
		wpctl set-mute "$sink" "$?"
		;;
	mute) wpctl set-mute "$sink" toggle ;;
esac
