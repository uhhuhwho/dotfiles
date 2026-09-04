#!/usr/bin/env bash
if [ -d /sys/class/power_supply/BAT* ]; then
    cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
    stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1)
    if [ "$stat" = "Charging" ]; then
        icon="󰂄"
    elif [ -z "$cap" ]; then
        icon="󰂑"
        cap="100"
    elif [ "$cap" -ge 90 ]; then icon="󰁹"
    elif [ "$cap" -ge 80 ]; then icon="󰂂"
    elif [ "$cap" -ge 70 ]; then icon="󰂁"
    elif [ "$cap" -ge 60 ]; then icon="󰂀"
    elif [ "$cap" -ge 50 ]; then icon="󰁿"
    elif [ "$cap" -ge 40 ]; then icon="󰁾"
    elif [ "$cap" -ge 30 ]; then icon="󰁽"
    elif [ "$cap" -ge 20 ]; then icon="󰁼"
    elif [ "$cap" -ge 10 ]; then icon="󰁻"
    else icon="󰁺"
    fi
    echo "$icon ${cap}%"
else
    echo "󰚥 AC"
fi
