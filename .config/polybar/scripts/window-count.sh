#!/bin/bash

data=$HOME/.config/polybar/data
count_file=$data/count.txt

if [[ ! -f $count_file ]]; then
	touch $count_file
fi

count_file=$HOME/.config/polybar/data/count.txt
window_count=$(cat "$count_file")

echo " $window_count"
