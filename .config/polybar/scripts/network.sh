#!/bin/bash

idx=7
data="$HOME/.config/polybar/data"
poly_right="$data/right.txt"

entries=$(cat "$data/right_entries.txt")

if [[ ! -f $poly_right ]]; then
        touch $poly_right
        printf '0;0\n%.0s' $(seq 1 "$entries") > "$poly_right"
fi

icon_count=0

wifi_interface=$(/usr/sbin/iw dev | grep Interface | awk '{print $2}')
wifi_status=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep "^$wifi_interface" | awk -F: '{print $3}')
wifi_signal=$(/usr/sbin/iwconfig $wifi_interface | grep "Signal level" | awk -F '=' '{print $3}' | awk -F ' ' '{print $1}')

if [[ -n $wifi_signal ]]; then
	quality=$((2*($wifi_signal+100)))
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

eth_interface=$(nmcli -t -f DEVICE,TYPE dev | grep ethernet | awk -F: '{print $1}' | head -n 1)
eth_status=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep "^$eth_interface" | awk -F: '{print $3}')

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

city=$(nordvpn status | grep "City" | awk -F ': ' '{print $2}')
country=$(nordvpn status | grep "Country" | awk -F ': ' '{print $2}')

if nordvpn status | grep -q "Disconnected"; then
        output="$network "
else
	output="$network  󰕥"

fi

len=$((${#output} + 3 - $icon_count))
sed -i "${idx}s/.*/$icon_count;$len/" "$poly_right"

echo "$output"
