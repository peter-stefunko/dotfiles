#!/bin/bash

idx=9
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

icon_count=0

if lsof /dev/video0 >/dev/null 2>&1; then
    	camera="  󰄀"
    	icon_count=$(($icon_count + 1))
fi

if wpctl status 2>/dev/null | grep -A 10 "Streams:" | grep -q "capture_.*\[active\]"; then
    	icon_count=$(($icon_count + 1))

	if wpctl status | grep -A 22 "^Audio" | grep -A 7 "Sources:" | grep "*" | grep -q "MUTED"; then
    		mic="  󰍭"
    	else
    		mic="  "
    	fi
fi

if wpctl status 2>/dev/null | awk '/Video/,/Settings/' | grep -E "^[[:space:]]+[0-9]+\." | grep -vE "kwin_wayland|plasmashell" | grep -q "active"; then
    	screen="󰍹"
    	icon_count=$(($icon_count + 1))
fi

output="$screen$camera$mic"

if [[ -n $output ]]; then
	len=$((${#output} + 3 - $icon_count))
else
	len=0
fi

sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
