#!/bin/bash

data="$HOME/.config/polybar/data"
right_file="$data/right.txt"

if [[ ! -f $right_file ]]; then
        touch $right_file
        printf '0;0\n%.0s' {1..9} > $right_file
fi

wifi_interface=$(/usr/sbin/iw dev | grep Interface | awk '{print $2}')
wifi_status=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep "^$wifi_interface" | awk -F: '{print $3}')
signal=$(/usr/sbin/iwconfig $wifi_interface | grep "Signal level" | awk -F '=' '{print $3}' | awk -F ' ' '{print $1}')

eth_interface=$(nmcli -t -f DEVICE,TYPE dev | grep ethernet | awk -F: '{print $1}' | head -n 1)
eth_status=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep "^$eth_interface" | awk -F: '{print $3}')

icon_count=0

if [[ -n $signal ]]; then
	quality=$((2*($signal+100)))
	if [[ $quality -lt 25 ]]; then
		wufi="󰤯"
	elif [[ $quality -lt 50 ]]; then
		wifi="󰤟"
	elif [[ $quality -lt 75 ]]; then
		wifi="󰤢"
	else
		wifi="󰤨"
	fi
else
	wifi="󰤮"
fi

icon_count=$(($icon_count + 1))

both="$wifi "
eth=""
neither="󰤮"

if [[ "$wifi_status" == "connected" && "$eth_status" == "connected" ]]; then
    network="$both"
    icon_count=$(($icon_count + 1))
elif [[ "$wifi_status" == "connected" ]]; then
    network="$wifi"
elif [[ "$eth_status" == "connected" ]]; then
    network="$eth"
else
    network="$neither"
fi

CITY=$(nordvpn status | grep "City" | awk -F ': ' '{print $2}')
COUNTRY=$(nordvpn status | grep "Country" | awk -F ': ' '{print $2}')

if nordvpn status | grep -q "Disconnected"; then
        output="$network "
else
	output="$network  󰕥"

fi

len=$((${#output} + 3 - $icon_count))
sed -i "3s/.*/$icon_count;$len/" "$right_file"

echo "$output"
