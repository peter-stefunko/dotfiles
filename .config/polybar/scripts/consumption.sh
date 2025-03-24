#!/bin/bash

idx=4
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi


bat="/sys/class/power_supply/BAT0"
status=$(cat $bat/status)

icon_count=0

if [[ $status == "Discharging" ]]; then
        power=$(echo "scale=2; $(cat $bat/power_now) / 1000000" | bc)
	output="$power W"
fi

if [[ -n $output ]]; then
	len=$((${#output} + 3 - $icon_count))
else
	len=0
fi

sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
