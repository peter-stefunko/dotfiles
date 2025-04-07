#!/bin/bash

data="$HOME/.config/polybar/data"

if [[ -d $data ]]; then
	find "$data" -type f ! -name "right_entries.txt" -delete
fi
