#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
	touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

bat=/sys/class/power_supply/BAT0
capacity=$(cat $bat/capacity)

icon_count=0

if [[ $capacity -gt 90 ]]; then
    icon="󰁹"
elif [[ $capacity -gt 80 ]]; then
    icon="󰂁"
elif [[ $capacity -gt 70 ]]; then
    icon="󰂀"
elif [[ $capacity -gt 60 ]]; then
    icon="󰁿"
elif [[ $capacity -gt 50 ]]; then
    icon="󰁾"
elif [[ $capacity -gt 40 ]]; then
    icon="󰁽"
elif [[ $capacity -gt 30 ]]; then
    icon="󰁼"
elif [[ $capacity -gt 20 ]]; then
    icon="󰁻"
else
    icon="󰂎"
    icon_count=$(($icon_count + 1))
fi

icon_count=$(($icon_count + 1))

status=$(cat /sys/class/power_supply/BAT0/status)

if [[ $status == "Charging" ]]; then
	icon="$icon󱐋"
	icon_count=$(($icon_count + 1))
fi

if [ -d /sys/class/power_supply/hidpp_battery* ]; then
	mouse_cap=$(cat /sys/class/power_supply/hidpp_battery*/capacity)
	output="$icon $capacity% 󰍽 $mouse_cap%"
	icon_count=$(($icon_count + 1))
else
	output="$icon $capacity%"
fi

len=$((${#output} + 3 - $icon_count))
sed -i "7s/.*/$icon_count;$len/" "$right_file"

echo "$output"
