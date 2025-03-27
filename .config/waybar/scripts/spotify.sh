#!/bin/bash

status=$(playerctl -p spotify status 2>/dev/null)

if [ "$status" == "Playing" ]; then
	status_icon=""
elif [ "$status" == "Paused" ]; then
	status_icon=""
else
	echo ""
	exit
fi

title=$(playerctl metadata title)
artist=$(playerctl metadata artist)
shuffle=$(playerctl shuffle)
repeat=$(playerctl loop)

if [ "$shuffle" = "On" ]; then
	shuffle_icon=""
fi

case "$repeat" in
	"Track")
		repeat_icon=""
		;;
	"Playlist")
		repeat_icon=""
		;;
esac

if [[ -n $shuffle_icon ]]; then
	if [[ -n $repeat_icon ]]; then
		toggles=" | $shuffle_icon  $repeat_icon "
	else
		toggles=" | $shuffle_icon "
	fi
else
	if [[ -n $repeat_icon ]]; then
		toggles=" | $repeat_icon "
	fi
fi

rest=" - $artist $status_icon$toggles"
output="$title$rest"
output_len=${#output}
max=80

if [[ $output_len -gt $max ]]; then
	adj=$(( $max - 3 ))
	output="${output:0:$adj}..."
fi

echo "$output"
