#!/bin/bash

device_name=$(bluetoothctl devices Connected | cut -d' ' -f3-)
space=$(printf '\u00A0')

if bluetoothctl show | grep -q "Powered: yes"; then
	if [[ -n $device_name ]]; then
		echo 
	else
		echo 󰂯
	fi
else
	echo
fi
