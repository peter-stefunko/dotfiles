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

ACTIVE_UUID=$(cat "$ACTIVE_FILE")

if [[ -z "$ACTIVE_UUID" ]]; then
	echo
	exit
fi

LINE_NUM=$(grep -n "$ACTIVE_UUID" "$UUIDS_FILE" | cut -d: -f1)
ACTIVE_NAME=$(awk -v N="$LINE_NUM" 'NR==N' "$PROGS_FILE" | awk -F ';' '{print $1}')
ACTIVE_ICON=$(awk -v N="$LINE_NUM" 'NR==N' "$PROGS_FILE" | awk -F ';' '{print $2}')

if [[ -z "$ACTIVE_NAME" ]]; then
	echo "  Desktop"
else
	if [[ "$ACTIVE_ICON" == "$ACTIVE_NAME" ]]; then
		echo "$ACTIVE_NAME"
	else
		echo "$ACTIVE_ICON $ACTIVE_NAME"
	fi
fi
