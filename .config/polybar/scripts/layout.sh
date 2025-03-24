#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

icon_count=0

index=$(qdbus org.kde.keyboard /Layouts getLayout)
layout_index=$((2+$index*6))
layout=$(qdbus --literal org.kde.keyboard /Layouts getLayoutsList | awk -F '"' -v idx="$layout_index" '{print $idx}')

output="$layout"

len=$((${#output} + 3 - $icon_count))
sed -i "5s/.*/$icon_count;$len/" "$right_file"

echo "$output"
