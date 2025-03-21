#!/bin/bash

DATA_DIR=$HOME/.config/polybar/data

UUIDS_FILE=$DATA_DIR/uuids.txt
PROGS_FILE=$DATA_DIR/progs.txt
COUNT_FILE=$DATA_DIR/count.txt
ACTIVE_FILE=$DATA_DIR/active.txt

if [[ ! -f "$UUIDS_FILE" ]]; then
	touch "$UUIDS_FILE"
fi

if [[ ! -f "$PROGS_FILE" ]]; then
	touch "$PROGS_FILE"
fi

if [[ ! -f "$COUNT_FILE" ]]; then
	touch "$COUNT_FILE"
fi

if [[ ! -f "$ACTIVE_FILE" ]]; then
	touch "$ACTIVE_FILE"
fi

ACTIVE_UUID=$(kdotool getactivewindow 2>/dev/null | awk -F '{' '{print $2}' | awk -F '}' '{print $1}')

if cat "$ACTIVE_FILE" | grep -q "$ACTIVE_UUID"; then
	exit
fi

echo "$ACTIVE_UUID" > "$ACTIVE_FILE"

if ! cat "$UUIDS_FILE" | grep -q "$ACTIVE_UUID"; then
	RESOURCE_CLASS=$(qdbus org.kde.KWin /KWin org.kde.KWin.getWindowInfo "$ACTIVE_UUID" | grep resourceClass | awk -F ': ' '{print $2}')
	DESKTOP_PATH="/usr/share/applications"
	DESKTOP_ENTRY="$DESKTOP_PATH/$RESOURCE_CLASS.desktop"

	if [[ ! -f "$DESKTOP_ENTRY" ]]; then
		PROG_NAME="$RESOURCE_CLASS"
		if [[ $RESOURCE_CLASS == "rofi" ]]; then
			PROG_ICON=" "
		elif [[ $RESOURCE_CLASS == "signal" ]]; then
			PROG_ICON="󰭹 "
		else
			PROG_NAME="Window"
			PROG_ICON=" "
		fi
	else
		PROG_NAME=$(cat "$DESKTOP_ENTRY" | grep "^Name=" -m 1 | awk -F '=' '{print $2}')
		PROG_ICON="$PROG_NAME"

		if [[ "$PROG_NAME" == "1Password" ]]; then
			PROG_ICON="󰌆 "
		elif [[ "$PROG_NAME" == "Chromium Web Browser" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Discover" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Discord" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Dolphin" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Firefox ESR" ]]; then
			PROG_ICON="󰈹 "
		elif [[ "$PROG_NAME" == "Gwenview" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Kate" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Konsole" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "OBS Studio" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Okular" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Spotify" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Steam" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "System Settings" ]]; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "VLC media player" ]]; then
			PROG_ICON="󰕼 "
		elif [[ "$PROG_NAME" == "Visual Studio Code" ]]; then
			PROG_ICON="󰨞 "
		elif [[ "$PROG_NAME" == "Vivaldi" ]]; then
			PROG_ICON=" "
		elif echo "$PROG_NAME" | grep -q "CLion"; then
			PROG_ICON=" "
		elif echo "$PROG_NAME" | grep -q "DataGrip"; then
			PROG_ICON=" "
		elif echo "$PROG_NAME" | grep -q "LibreOffice"; then
			PROG_ICON="󰈙 "
		elif echo "$PROG_NAME" | grep -q "PyCharm"; then
			PROG_ICON=" "
		elif echo "$PROG_NAME" | grep -q "Rider"; then
			PROG_ICON=" "
		elif echo "$PROG_NAME" | grep -q "RustRover"; then
			PROG_ICON=" "
		elif [[ "$PROG_NAME" == "Plasma Desktop Workspace" ]]; then
			PROG_NAME="Desktop"
			PROG_ICON=" "
		fi
	fi

	echo "$ACTIVE_UUID" >> "$UUIDS_FILE"

#	if [[ ! "$PROG_NAME" == "Desktop" ]]; then
	echo "$PROG_NAME;$PROG_ICON" >> "$PROGS_FILE"
#	fi
fi

for UUID in $(cat "$UUIDS_FILE"); do
	INFO=$(qdbus org.kde.KWin /KWin org.kde.KWin.getWindowInfo "$UUID")
	if [ -z "$INFO" ]; then
		LINE_NUM=$(grep -n "$UUID" "$UUIDS_FILE" | cut -d: -f1)
		sed -i "/$UUID/d" "$UUIDS_FILE"
		sed -i "${LINE_NUM}d" "$PROGS_FILE"
	fi
done

RESULT=""
TOTAL=0

while IFS= read -r PROG; do
	NAME=$(echo "$PROG" | awk -F ';' '{print $1}')
	if [[ $NAME == "Desktop" ]]; then
		continue
	fi

	COUNT=$(grep -c "^$PROG$" "$PROGS_FILE")
	TOTAL=$(($TOTAL+$COUNT))

	if [[ $COUNT == "1" ]]; then
		COUNT=""
	else
		COUNT="$COUNT "
	fi

	ICON=$(echo "$PROG" | awk -F ';' '{print $2}')

	if [ -z "$RESULT" ]; then
		RESULT="$COUNT$ICON"
	else
		RESULT="$RESULT | $COUNT$ICON"
    	fi
done < <(sort "$PROGS_FILE" | uniq)

echo $TOTAL > "$COUNT_FILE"
echo "$RESULT"
