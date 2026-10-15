#!/usr/bin/env bash
# Notification for Caps Lock toggle
sleep 0.05

is_on=0
for f in /sys/class/leds/input*::capslock/brightness; do
    if [ -f "$f" ] && [ "$(cat "$f" 2>/dev/null)" = "1" ]; then
        is_on=1
        break
    fi
done

if [ "$is_on" -eq 1 ]; then
    notify-send -t 1500 -a "System" "Caps Lock" "Caps Lock is ON" -h string:x-canonical-private-synchronous:capslock -i keyboard-caps-lock-symbolic
else
    notify-send -t 1500 -a "System" "Caps Lock" "Caps Lock is OFF" -h string:x-canonical-private-synchronous:capslock -i keyboard-caps-lock-symbolic
fi

