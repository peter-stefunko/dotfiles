#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOL=$(echo "$INFO" | awk '{print $2}')
VOL=$(echo "$VOL * 100 / 1" | bc)

icon_count=0

if echo "$INFO" | grep -q "MUTED"; then
     output=" "
else
    if [[ "$VOL" -lt 20 ]]; then
          output=" $VOL%"
    else
    	if [[ "$VOL" -lt 45 ]]; then
    	     output=" $VOL%"
	else
	    output="  $VOL%"
	fi
    fi
fi

icon_count=$(($icon_count + 1))

len=$((${#output} + 3 - $icon_count))
sed -i "4s/.*/$icon_count;$len/" "$right_file"

echo "$output"
