#!/bin/bash

idx=1
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

icon_count=0

date=$(date +"%a %d/%m/%Y")

output=" $date"
icon_count=$(($icon_count + 1))

len=$((${#output} - $icon_count))
sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
