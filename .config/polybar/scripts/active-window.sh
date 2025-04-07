#!/bin/bash

data="$HOME/.config/polybar/data"

if [[ ! -d "$data" ]]; then
	mkdir -p "$data"
fi

uuids_file="$data/uuids.txt"
progs_file="$data/progs.txt"
count_file="$data/count.txt"
active_file="$data/active.txt"

if [[ ! -f "$uuids_file" ]]; then
        touch "$uuids_file"
fi

if [[ ! -f "$progs_file" ]]; then
        touch "$progs_file"
fi

if [[ ! -f "$count_file" ]]; then
        touch "$count_file"
fi

if [[ ! -f "$active_file" ]]; then
        touch "$active_file"
fi

active_uuid=$(cat "$active_file")

if [[ -z "$active_uuid" ]]; then
	echo
	exit
fi

line_num=$(grep -n "$active_uuid" "$uuids_file" | cut -d: -f1)
active_name=$(awk -v N="$line_num" 'NR==N' "$progs_file" | awk -F ';' '{print $1}')
active_icon=$(awk -v N="$line_num" 'NR==N' "$progs_file" | awk -F ';' '{print $2}')

if [[ -z "$active_name" ]]; then
	echo "  Desktop"
else
	if [[ "$active_icon" == "$active_name" ]]; then
		echo "$active_name"
	else
		echo "$active_icon $active_name"
	fi
fi
