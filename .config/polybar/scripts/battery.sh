#!/bin/bash

idx=3
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
	touch $poly_right
	printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

supply="/sys/class/power_supply"
bat="$supply/BAT0"

bat_cap=$(cat $bat/capacity)

icon_count=0

if [[ $bat_cap -gt 90 ]]; then
    icon="󰁹"
elif [[ $bat_cap -gt 80 ]]; then
    icon="󰂁"
elif [[ $bat_cap -gt 70 ]]; then
    icon="󰂀"
elif [[ $bat_cap -gt 60 ]]; then
    icon="󰁿"
elif [[ $bat_cap -gt 50 ]]; then
    icon="󰁾"
elif [[ $bat_cap -gt 40 ]]; then
    icon="󰁽"
elif [[ $bat_cap -gt 30 ]]; then
    icon="󰁼"
elif [[ $bat_cap -gt 20 ]]; then
    icon="󰁻"
else
    icon="󰂎"
    icon_count=$(($icon_count + 1))
fi

icon_count=$(($icon_count + 1))

bat_status=$(cat $bat/status)

if [[ $bat_status == "Charging" ]]; then
	icon="$icon󱐋"
	icon_count=$(($icon_count + 1))
fi

mouse=$supply/hidpp_battery*

if [ -d $mouse ]; then
	mouse_cap=$(cat $mouse/capacity)
	mouse_status=$(cat $mouse/status)

	if [[ $mouse_status == "Charging" ]]; then
		mouse_output="  󰍽 󱐋 $mouse_cap%"
		icon_count=$(($icon_count + 1))
	else
		mouse_output="  󰍽 $mouse_cap%"
	fi

	icon_count=$(($icon_count + 1))
fi

output="$icon $bat_cap%$mouse_output"

len=$((${#output} + 3 - $icon_count))
sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
