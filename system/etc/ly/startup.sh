#!/bin/sh
# This file is executed when starting Ly (before the TTY is taken control of)

# Scale console font for Ly HiDPI display
setfont ter-v32n 2>/dev/null || true
