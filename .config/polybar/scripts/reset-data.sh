#!/bin/bash

data_dir="$HOME/.config/polybar/data"

#rm "$data_dir/*" !("$data_dir/right_entries.txt")
find "$data_dir" -type f ! -name "right_entries.txt" -delete
