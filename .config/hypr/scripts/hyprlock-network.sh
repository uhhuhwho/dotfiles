#!/usr/bin/env bash
ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -n1)
if [ -n "$ssid" ]; then
    echo "󰤨  $ssid"
else
    eth=$(nmcli -t -f TYPE,STATE dev 2>/dev/null | grep 'ethernet:connected')
    if [ -n "$eth" ]; then
        echo "󰈀  Ethernet"
    else
        echo "󰤮  Offline"
    fi
fi
