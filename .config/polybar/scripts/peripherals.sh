#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
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

len=$((${#output} + 3 - $icon_count))
sed -i "1s/.*/$icon_count;$len/" "$right_file"

echo "$output"
