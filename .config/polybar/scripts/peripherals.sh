#!/bin/bash

space=$(printf '\u00A0\u00A0')

if lsof /dev/video0 >/dev/null 2>&1; then
    	camera="$space󰄀"
fi

if wpctl status 2>/dev/null | grep -A 10 "Streams:" | grep -q "capture_.*\[active\]"; then
	if wpctl status | grep -A 22 "^Audio" | grep -A 7 "Sources:" | grep "*" | grep -q "MUTED"; then
    		mic=󰍭
    	else
    		mic=
    	fi
    	mic="$space$mic"
fi

if wpctl status 2>/dev/null | awk '/Video/,/Settings/' | grep -E "^[[:space:]]+[0-9]+\." | grep -vE "kwin_wayland|plasmashell" | grep -q "active"; then
    	screen="$space󰍹"
fi

echo "$screen$camera$mic"
