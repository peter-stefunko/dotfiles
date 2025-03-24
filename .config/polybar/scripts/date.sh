#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

icon_count=0

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

date=$(date +"%a %d/%m/%Y")
output=" $date"
icon_count=$(($icon_count + 1))

len=$((${#output} - $icon_count))
sed -i "9s/.*/$icon_count;$len/" "$right_file"

echo "$output"
