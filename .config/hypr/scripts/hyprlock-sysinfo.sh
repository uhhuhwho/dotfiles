#!/usr/bin/env bash
up=$(uptime -p 2>/dev/null | sed -e 's/up //' -e 's/ hours\?/h/' -e 's/ minutes\?/m/' -e 's/ days\?/d/' -e 's/,//g')
echo "󰌢 $HOSTNAME  │  󰥔 $up"
