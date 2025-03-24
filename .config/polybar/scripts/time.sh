#!/bin/bash

idx=2
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi


icon_count=0

time_rn=$(date +"%H:%M:%S")

output="󱑂  $time_rn"
icon_count=$(($icon_count + 1))

len=$((${#output} + 3 - $icon_count))
sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
