#!/bin/bash

COUNT_FILE=$HOME/.config/polybar/data/count.txt

if [[ ! -f $COUNT_FILE ]]; then
	touch $COUNT_FILE
fi

count_file=$HOME/.config/polybar/data/count.txt
window_count=$(cat "$count_file")
space=$(printf '\u00A0')

echo "$space$window_count"
