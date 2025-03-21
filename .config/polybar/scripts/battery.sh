#!/bin/bash

bat=/sys/class/power_supply/BAT0
capacity=$(cat $bat/capacity)
space=$(printf '\u00A0')

if [[ $capacity -gt 90 ]]; then
    icon=󰁹
elif [[ $capacity -gt 80 ]]; then
    icon=󰂁
elif [[ $capacity -gt 70 ]]; then
    icon=󰂀
elif [[ $capacity -gt 60 ]]; then
    icon=󰁿
elif [[ $capacity -gt 50 ]]; then
    icon=󰁾
elif [[ $capacity -gt 40 ]]; then
    icon=󰁽
elif [[ $capacity -gt 30 ]]; then
    icon=󰁼
elif [[ $capacity -gt 20 ]]; then
    icon=󰁻
else
    icon=󰂎
fi

status=$(cat /sys/class/power_supply/BAT0/status)

if [[ $status == "Charging" ]]; then
	icon="$icon󱐋"
fi

if [ -d /sys/class/power_supply/hidpp_battery* ]; then
	mouse_cap=$(cat /sys/class/power_supply/hidpp_battery*/capacity)
	echo "$icon$space$capacity%$space󰍽$space$mouse_cap%"
else
	echo "$icon$space$capacity%"
fi
