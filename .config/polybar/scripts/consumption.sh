#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

bat=/sys/class/power_supply/BAT0
status=$(cat $bat/status)

icon_count=0

if [[ $status == "Discharging" ]]; then
        power=$(echo "scale=2; $(cat $bat/power_now) / 1000000" | bc)
	output="$power W"
else
	output=""
fi

if [[ ! $output == "" ]]; then
	len=$((${#output} + 3 - $icon_count))
else
	len=0
fi

sed -i "6s/.*/$icon_count;$len/" "$right_file"

echo "$output"
