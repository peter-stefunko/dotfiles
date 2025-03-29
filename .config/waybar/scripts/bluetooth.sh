#!/bin/bash

device_name=$(bluetoothctl devices Connected | cut -d' ' -f3-)

if bluetoothctl show | grep -q "Powered: yes"; then
	if [[ -n $device_name ]]; then
		output=""
	else
		output="󰂯"
	fi
fi

echo "$output"
