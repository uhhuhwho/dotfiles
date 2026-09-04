#!/usr/bin/env bash
status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    title=$(playerctl metadata --format '{{title}}' 2>/dev/null | cut -c 1-32)
    artist=$(playerctl metadata --format '{{artist}}' 2>/dev/null | cut -c 1-22)
    
    if [ "$status" = "Playing" ]; then
        icon="󰎆"
    else
        icon="󰏤"
    fi
    
    if [ -n "$artist" ] && [ -n "$title" ]; then
        echo "$icon $title • $artist"
    elif [ -n "$title" ]; then
        echo "$icon $title"
    else
        echo ""
    fi
else
    echo ""
fi
