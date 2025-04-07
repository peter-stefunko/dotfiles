#!/bin/bash

idx=5
data="$HOME/.config/polybar/data"

if [[ ! -d "$data" ]]; then
        mkdir -p "$data"
fi

poly_right="$data/right.txt"
entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi


icon_count=0

index=$(qdbus org.kde.keyboard /Layouts getLayout)

layout_index=$((2+$index*6))
layout=$(qdbus --literal org.kde.keyboard /Layouts getLayoutsList | awk -F '"' -v idx="$layout_index" '{print $idx}')

output="$layout"

len=$((${#output} + 3 - $icon_count))
sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
