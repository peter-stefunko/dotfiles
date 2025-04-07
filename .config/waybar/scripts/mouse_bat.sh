#!/bin/bash

supply="/sys/class/power_supply"
mouse=$supply/hidpp_battery*

if [ -d $mouse ]; then
	cap=$(cat $mouse/capacity)
	status=$(cat $mouse/status)

	if [[ $status == "Charging" ]]; then
		output="󰍽 󱐋 $cap%"
	else
		output="󰍽 $cap%"
	fi
else
	echo ""
	exit
fi

echo "$output"
