#!/usr/bin/env python3
"""
Lightweight Caps Lock state change monitor for Hyprland / Wayland.
Continuously watches keyboard Caps Lock state via sysfs LED and hyprctl,
sending instant ON / OFF desktop notifications.
"""

import glob
import os
import signal
import subprocess
import sys
import time

PID_FILE = f"/run/user/{os.getuid()}/capslock-watcher.pid"

def is_keyboard_capslock(path: str) -> bool:
    dev_dir = os.path.dirname(os.path.dirname(path))
    name_file = os.path.join(dev_dir, "device", "name")
    if os.path.isfile(name_file):
        try:
            with open(name_file, "r") as f:
                dev_name = f.read().strip().lower()
                if any(x in dev_name for x in ("mouse", "razer", "viper")):
                    return False
        except Exception:
            pass
    if "openrazer" in path.lower() or "razer" in path.lower():
        return False
    return True

def get_caps_led_paths() -> list[str]:
    paths = []
    for f in glob.glob("/sys/class/leds/*capslock*/brightness"):
        if is_keyboard_capslock(f):
            paths.append(f)
    return paths

def read_caps_state(led_paths: list[str]) -> bool:
    for path in led_paths:
        try:
            with open(path, "r") as f:
                val = f.read().strip()
                if val == "1":
                    return True
        except Exception:
            pass
    return False

def notify_caps(is_on: bool):
    status_text = "Caps Lock is ON" if is_on else "Caps Lock is OFF"
    icon = "keyboard-caps-lock-symbolic" if is_on else "keyboard-symbolic"
    try:
        subprocess.run(
            [
                "notify-send",
                "-t", "1200",
                "-a", "System",
                "Caps Lock",
                status_text,
                "-h", "string:x-canonical-private-synchronous:capslock",
                "-i", icon,
            ],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except Exception:
        pass

def main():
    # Ensure singleton
    if os.path.isfile(PID_FILE):
        try:
            with open(PID_FILE, "r") as pf:
                old_pid = int(pf.read().strip())
            os.kill(old_pid, 0)
            # If already running, exit cleanly
            sys.exit(0)
        except (OSError, ValueError):
            pass

    with open(PID_FILE, "w") as pf:
        pf.write(str(os.getpid()))

    def cleanup(*_):
        try:
            if os.path.isfile(PID_FILE):
                os.remove(PID_FILE)
        except Exception:
            pass
        sys.exit(0)

    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    led_paths = get_caps_led_paths()
    prev_state = read_caps_state(led_paths)

    scan_counter = 0

    while True:
        time.sleep(0.08)
        scan_counter += 1

        # Re-scan available LEDs periodically every ~15 seconds in case devices change
        if scan_counter > 180:
            scan_counter = 0
            led_paths = get_caps_led_paths()

        current_state = read_caps_state(led_paths)
        if current_state != prev_state:
            prev_state = current_state
            notify_caps(current_state)

if __name__ == "__main__":
    main()

