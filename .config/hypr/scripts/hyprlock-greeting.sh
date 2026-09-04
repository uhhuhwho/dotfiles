#!/usr/bin/env bash
HOUR=$(date +%H)
USER_NAME="${USER^}"
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    GREET="Good Morning"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    GREET="Good Afternoon"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 22 ]; then
    GREET="Good Evening"
else
    GREET="Good Night"
fi
echo "$GREET, $USER_NAME"
