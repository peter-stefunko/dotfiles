#!/bin/bash

INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOL=$(echo "$INFO" | awk '{print $2}')
VOL=$(echo "$VOL * 100 / 1" | bc) 

space=$(printf '\u00A0')

if echo "$INFO" | grep -q "MUTED"; then
    echo "$space"
else
    if [[ "$VOL" -lt 20 ]]; then
         echo " $VOL%"
    else
    	if [[ "$VOL" -lt 45 ]]; then
    	    echo "$space$VOL%"
	else
	    echo "$space$space$VOL%"
	fi
    fi
fi
