#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

icon_count=0

time_rn=$(date +"%H:%M:%S")

output="󱑂  $time_rn"
icon_count=$(($icon_count + 1))

len=$((${#output} + 3 - $icon_count))
sed -i "8s/.*/$icon_count;$len/" "$right_file"

echo "$output"
