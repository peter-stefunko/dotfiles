#!/bin/bash

bat=/sys/class/power_supply/BAT0
status=$(cat $bat/status)

if [[ $status == "Discharging" ]]; then
        power=$(echo "scale=2; $(cat $bat/power_now) / 1000000" | bc)
	echo "$power W"
else
	echo ""
fi
