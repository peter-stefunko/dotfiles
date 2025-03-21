#!/bin/bash

STATUS=$(playerctl -p spotify status 2>/dev/null)

if [ "$STATUS" == "Playing" ]; then
	STATUS_ICON=
elif [ "$STATUS" == "Paused" ]; then
	STATUS_ICON=
else
	echo ""
	exit
fi

TITLE=$(playerctl metadata title)
ARTIST=$(playerctl metadata artist)
ALBUM=$(playerctl metadata album)
# POSITION=$(playerctl position)
# DURATION=$(playerctl metadata mpris:length)
#VOLUME=$(playerctl volume)
SHUFFLE=$(playerctl shuffle)
REPEAT=$(playerctl loop)

# DURATION=$((DURATION / 1000000))
# DURATION_FORMATTED=$(printf "%02d:%02d" $((DURATION / 60)) $((DURATION % 60)))

#VOLUME=$(printf "%.0f" $(echo "$VOLUME * 100" | bc))

# POSITION=$(printf "%.0f" $POSITION)
# POSITION=$(printf "%02d:%02d" $((POSITION / 60)) $((POSITION % 60)))

space=$(printf '\u00A0\u00A0')

if [ "$SHUFFLE" = "On" ]; then
	SHUFFLE_ICON=" "
else
	SHUFFLE_ICON=""
fi

case "$REPEAT" in
	"Track") REPEAT_ICON= ;;
	"Playlist") REPEAT_ICON= ;;
	*) REPEAT_ICON="" ;;
esac

TOGGLES="$SHUFFLE_ICON $REPEAT_ICON"

if [[ -n $TOGGLES ]]; then
	TOGGLES=" | $TOGGLES"
fi

OUTPUT="$TITLE - $ARTIST $STATUS_ICON$TOGGLES "
LEN=${#OUTPUT}
MAX=60
DIFF=$(($LEN - $MAX))
TITLE_LEN=${#TITLE}
ADJUSTED=$(($TITLE_LEN - $DIFF - 3))

if [[ $LEN -gt $MAX ]]; then
	TITLE="${TITLE:0:$ADJUSTED}..."
fi

OUTPUT="$TITLE - $ARTIST $STATUS_ICON$TOGGLES "

echo "$OUTPUT"
