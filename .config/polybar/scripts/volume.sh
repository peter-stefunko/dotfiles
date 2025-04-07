#!/bin/bash

idx=6
data="$HOME/.config/polybar/data"

if [[ ! -d "$data" ]]; then
        mkdir -p "$data"
fi

poly_right="$data/right.txt"
entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

icon_count=0

info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
vol=$(echo "$info" | awk '{print $2}')
vol=$(echo "$vol * 100 / 1" | bc)

if echo "$info" | grep -q "MUTED"; then
     output=" "
else
    if [[ "$vol" -lt 20 ]]; then
          output=" $vol%"
    else
    	if [[ "$vol" -lt 45 ]]; then
    	     output=" $vol%"
	else
	    output="  $vol%"
	fi
    fi
fi

icon_count=$(($icon_count + 1))

len=$((${#output} + 3 - $icon_count))
sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
