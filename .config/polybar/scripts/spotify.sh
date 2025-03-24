#!/bin/bash

DATA="$HOME/.config/polybar/data"
RIGHT_FILE="$DATA/right.txt"

if [[ ! -f $RIGHT_FILE ]]; then
        touch $RIGHT_FILE
        printf '0;0\n%.0s' {1..9} > $RIGHT_FILE
fi

STATUS=$(playerctl -p spotify status 2>/dev/null)

icon_count=0

if [ "$STATUS" == "Playing" ]; then
	STATUS_ICON=
elif [ "$STATUS" == "Paused" ]; then
	STATUS_ICON=
else
	echo ""
	exit
fi

icon_count=$(($icon_count + 1))

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
	icon_count=$(($icon_count + 1))
else
	SHUFFLE_ICON=""
fi

case "$REPEAT" in
	"Track")
		REPEAT_ICON=""
		icon_count=$(($icon_count + 1))
		;;
	"Playlist")
		REPEAT_ICON=""
		icon_count=$(($icon_count + 1))
		;;
	*) REPEAT_ICON="" ;;
esac

TOGGLES="$SHUFFLE_ICON $REPEAT_ICON"

if [[ -n $TOGGLES ]]; then
	TOGGLES=" | $TOGGLES"
fi

GAP=10
SCREEN_WIDTH=1920
ICON_WIDTH=9
TEXT_WIDTH=8

ICON_SUM=0
TEXT_SUM=0

while IFS=";" read -r ICON CHAR; do
    ICON_SUM=$((ICON_SUM + ICON))
    CHAR_SUM=$((CHAR_SUM + CHAR))
done < "$RIGHT_FILE"

RIGHT_PIXELS=$(( (ICON_SUM * ICON_WIDTH) + (CHAR_SUM * TEXT_WIDTH) + (GAP * TEXT_WIDTH)))

MAX_PIXELS=$(( SCREEN_WIDTH - 2 * RIGHT_PIXELS ))

REST=" - $ARTIST $STATUS_ICON$TOGGLES "
REST_PIXELS=$(( (${#REST} - $icon_count) * $TEXT_WIDTH + $icon_count * $ICON_WIDTH ))

OUTPUT="$TITLE$REST"
OUTPUT_PIXELS=$(( (${#OUTPUT} - $icon_count) * $TEXT_WIDTH + $icon_count * $ICON_WIDTH ))

if [[ $OUTPUT_PIXELS -gt $MAX_PIXELS ]]; then
	DIFF=$(( ($OUTPUT_PIXELS - $MAX_PIXELS) ))
	TITLE_LEN=${#TITLE}
	ADJUSTED=$(( (MAX_PIXELS - REST_PIXELS) / $TEXT_WIDTH - 3))
	TITLE="${TITLE:0:$ADJUSTED}..."
	OUTPUT="$TITLE$REST"
fi

echo "$OUTPUT"
