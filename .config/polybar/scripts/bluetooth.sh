#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

device_name=$(bluetoothctl devices Connected | cut -d' ' -f3-)
icon_count=0

if bluetoothctl show | grep -q "Powered: yes"; then
	icon_count=$(($icon_count + 1))

	if [[ -n $device_name ]]; then
		output=""
	else
		output="󰂯"
	fi
else
	output=""
fi

len=$((${#output} + 3 - $icon_count))
sed -i "2s/.*/$icon_count;$len/" "$right_file"

echo "$output"
