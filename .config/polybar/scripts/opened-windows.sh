#!/bin/bash

data=$HOME/.config/polybar/data

uuids_file=$data/uuids.txt
progs_file=$data/progs.txt
count_file=$data/count.txt
active_file=$data/active.txt

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

active_uuid=$(kdotool getactivewindow 2>/dev/null | awk -F '{' '{print $2}' | awk -F '}' '{print $1}')

if cat "$active_file" | grep -q "$active_uuid"; then
	exit
fi

echo "$active_uuid" > "$active_file"

if ! cat "$uuids_file" | grep -q "$active_uuid"; then
	resource_class=$(qdbus org.kde.KWin /KWin org.kde.KWin.getWindowInfo "$active_uuid" | grep resourceClass | awk -F ': ' '{print $2}')
	desktop_path="/usr/share/applications"
	desktop_entry="$desktop_path/$resource_class.desktop"

	if [[ ! -f "$desktop_entry" ]]; then
		prog_name="$resource_class"
		if [[ "$resource_class" == "rofi" ]]; then
			prog_icon=" "
		elif [[ "$resource_class" == "signal" ]]; then
			prog_icon="󰭹 "
		else
			prog_name="Window"
			prog_icon=" "
		fi
	else
		prog_name=$(cat "$desktop_entry" | grep "^Name=" -m 1 | awk -F '=' '{print $2}')
		prog_icon="$prog_name"

		if [[ "$prog_name" == "1Password" ]]; then
			prog_icon="󰌆 "
		elif [[ "$prog_name" == "Chromium Web Browser" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Discover" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Discord" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Dolphin" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Firefox ESR" ]]; then
			prog_icon="󰈹 "
		elif [[ "$prog_name" == "Gwenview" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Kate" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Konsole" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "OBS Studio" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Okular" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Spotify" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "Steam" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "System Settings" ]]; then
			prog_icon=" "
		elif [[ "$prog_name" == "VLC media player" ]]; then
			prog_icon="󰕼 "
		elif [[ "$prog_name" == "Visual Studio Code" ]]; then
			prog_icon="󰨞 "
		elif [[ "$prog_name" == "Vivaldi" ]]; then
			prog_icon=" "
		elif echo "$prog_name" | grep -q "CLion"; then
			prog_icon=" "
		elif echo "$prog_name" | grep -q "DataGrip"; then
			prog_icon=" "
		elif echo "$prog_name" | grep -q "LibreOffice"; then
			prog_icon="󰈙 "
		elif echo "$prog_name" | grep -q "PyCharm"; then
			prog_icon=" "
		elif echo "$prog_name" | grep -q "Rider"; then
			prog_icon=" "
		elif echo "$prog_name" | grep -q "RustRover"; then
			prog_icon=" "
		elif [[ "$prog_name" == "Plasma Desktop Workspace" ]]; then
			prog_name="Desktop"
			prog_icon=" "
		fi
	fi

	echo "$active_uuid" >> "$uuids_file"
	echo "$prog_name;$prog_icon" >> "$progs_file"
fi

for uuid in $(cat "$uuids_file"); do
	info=$(qdbus org.kde.KWin /KWin org.kde.KWin.getWindowInfo "$uuid")
	if [ -z "$info" ]; then
		line_num=$(grep -n "$uuid" "$uuids_file" | cut -d: -f1)
		sed -i "/$uuid/d" "$uuids_file"
		sed -i "${line_num}d" "$progs_file"
	fi
done

result=""
total=0

while IFS= read -r prog; do
	name=$(echo "$prog" | awk -F ';' '{print $1}')
	if [[ "$name" == "Desktop" ]]; then
		continue
	fi

	count=$(grep -c "^$prog$" "$progs_file")
	total=$(($total+$count))

	if [[ $count == "1" ]]; then
		count=""
	else
		count="$count "
	fi

	icon=$(echo "$prog" | awk -F ';' '{print $2}')

	if [ -z "$result" ]; then
		result="$count$icon"
	else
		result="$result | $count$icon"
    	fi
done < <(sort "$progs_file" | uniq)

echo "$total" > "$count_file"
echo "$result"
