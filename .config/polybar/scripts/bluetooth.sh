#!/bin/bash

idx=8
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

icon_count=0

device_name=$(bluetoothctl devices Connected | cut -d' ' -f3-)

if bluetoothctl show | grep -q "Powered: yes"; then
	icon_count=$(($icon_count + 1))

	if [[ -n $device_name ]]; then
		output=""
	else
		output="󰂯"
	fi
fi

if [[ -n $output ]]; then
	len=$((${#output} + 3 - $icon_count))
else
	len=0
fi

sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
