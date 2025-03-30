#!/bin/bash

if lsof /dev/video0 >/dev/null 2>&1; then
    	camera="  󰄀"
fi

if pactl list sources | grep -E 'Name|State' | grep -A 1 "RUNNING" | grep "Name:" | grep -q "Mic1"; then
	mic="  "
fi

if wpctl status 2>/dev/null | awk '/Video/,/Settings/' | grep -E "^[[:space:]]+[0-9]+\." | grep -vE "kwin_wayland|plasmashell" | grep -q "active"; then
    	screen="󰍹"
fi

output="$screen$camera$mic"

echo "$output"
