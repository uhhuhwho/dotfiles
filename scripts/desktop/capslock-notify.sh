#!/usr/bin/env python3
import json, subprocess, glob, time, sys

# Small delay to ensure the hardware/compositor state has settled after the key event
time.sleep(0.06)

is_caps = False

# 1. Authoritative check via Hyprland devices
try:
    res = subprocess.check_output(["hyprctl", "devices", "-j"], timeout=1)
    data = json.loads(res.decode())
    for kb in data.get("keyboards", []):
        if kb.get("main") and "capsLock" in kb:
            is_caps = bool(kb["capsLock"])
            break
except Exception:
    pass

# 2. Hardware sysfs fallback (ignore virtual mouse capslock like input23)
if not is_caps:
    for f in glob.glob("/sys/class/leds/*capslock*/brightness"):
        # Ignore mouse devices exporting fake capslock leds
        if "razer" in f.lower() or "input23" in f:
            continue
        try:
            with open(f, "r") as fp:
                if fp.read().strip() == "1":
                    is_caps = True
                    break
        except Exception:
            pass

if is_caps:
    subprocess.run([
        "notify-send", "-t", "1500", "-a", "System",
        "Caps Lock", "Caps Lock is ON",
        "-h", "string:x-canonical-private-synchronous:capslock",
        "-i", "keyboard-caps-lock-symbolic"
    ])
else:
    subprocess.run([
        "notify-send", "-t", "1500", "-a", "System",
        "Caps Lock", "Caps Lock is OFF",
        "-h", "string:x-canonical-private-synchronous:capslock",
        "-i", "keyboard-caps-lock-symbolic"
    ])
