#!/bin/bash

data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

status=$(playerctl -p spotify status 2>/dev/null)

icon_count=0

if [ "$status" == "Playing" ]; then
	status_icon=
elif [ "$status" == "Paused" ]; then
	status_icon=
else
	echo ""
	exit
fi

icon_count=$(($icon_count + 1))

title=$(playerctl metadata title)
artist=$(playerctl metadata artist)
album=$(playerctl metadata album)
shuffle=$(playerctl shuffle)
repeat=$(playerctl loop)

if [ "$shuffle" = "On" ]; then
	shuffle_icon=" "
	icon_count=$(($icon_count + 1))
else
	shuffle_icon=""
fi

case "$repeat" in
	"Track")
		repeat_icon=""
		icon_count=$(($icon_count + 1))
		;;
	"Playlist")
		repeat_icon=""
		icon_count=$(($icon_count + 1))
		;;
	*) repeat_icon="" ;;
esac

toggles="$shuffle_icon $repeat_icon"

if [[ ${#toggles} -gt 1 ]]; then
	toggles=" | $toggles"
fi

gap=10
screen_width=1920
icon_width=9
text_width=8

icon_sum=0
text_sum=0

while IFS=";" read -r icon char; do
    icon_sum=$(( icon_sum + icon ))
    char_sum=$(( char_sum + char ))
done < "$poly_right"

right_pixels=$(( (icon_sum * icon_width) + (char_sum * text_width) + (gap * text_width) ))

max_pixels=$(( screen_width - 2 * right_pixels ))

spotify_rest=" - $artist $status_icon$toggles "
rest_pixels=$(( (${#spotify_rest} - $icon_count) * $text_width + $icon_count * $icon_width ))

output="$title$spotify_rest"
output_pixels=$(( (${#output} - $icon_count) * $text_width + $icon_count * $icon_width ))

if [[ $output_pixels -gt $max_pixels ]]; then
	diff=$(( ($output_pixels - $max_pixels) ))
	title_len=${#title}
	title_adj=$(( (max_pixels - rest_pixels) / $text_width - 3 ))
	title_min=5

	if [[ $title_adj -lt $title_min ]]; then
		artist_adj=$(( ${#artist} + $title_adj - $title_min))
		title_adj=$title_min
		artist="${artist:0:$artist_adj}..."
		spotify_rest=" - $artist $status_icon$toggles "
	elif [[ $title_adj -gt 30 ]]; then
		title_adj=30
	fi

	title="${title:0:$title_adj}..."
	output="$title$spotify_rest"
fi

echo "$output"
