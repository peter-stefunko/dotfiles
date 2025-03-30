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

title_max=35
title_len=${#title}

if [[ $title_len -gt $title_max ]]; then
	adj=$(( $title_max - 3 ))
	title="${title:0:$adj}..."
fi

artist_max=20
artist_len=${#artist}

if [[ $artist_len -gt $artist_max ]]; then
	adj=$(( $artist_max - 3 ))
	artist="${artist:0:$adj}..."
fi

output="$title - $artist $status_icon$toggles"

echo "$output"
