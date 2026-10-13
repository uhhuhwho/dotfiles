#!/usr/bin/env python3
"""
Script: hp-fan-control.py
Category: Hardware (HP Omen) / Thermal & Fan Management
Description:
  Unified CLI tool for HP Omen fan control via the hp-wmi hwmon sysfs interface.
  Automatically locates the active hwmon directory and supports toggling,
  inspecting RPM speeds, or explicitly setting Auto (2) vs Max (0) fan mode.

Usage:
  sudo python3 hp-fan-control.py            # Toggle between Auto and Max mode
  sudo python3 hp-fan-control.py status     # Show current RPMs and PWM mode
  sudo python3 hp-fan-control.py max        # Force Maximum fan speed (0)
  sudo python3 hp-fan-control.py auto       # Restore Automatic fan control (2)
"""

import argparse
import os
import sys

HP_WMI_PATH = "/sys/devices/platform/hp-wmi"
REQUIRED_FILES = ["fan1_input", "fan2_input", "pwm1_enable"]


def find_hwmon_path() -> str:
    """Dynamically locate the hwmon directory under /sys/devices/platform/hp-wmi."""
    hwmon_base = os.path.join(HP_WMI_PATH, "hwmon")
    if not os.path.exists(hwmon_base):
        sys.stderr.write("Error: hp-wmi hwmon interface does not exist on this machine.\n")
        sys.exit(1)

    for entry in sorted(os.listdir(hwmon_base)):
        full_path = os.path.join(hwmon_base, entry)
        if os.path.isdir(full_path):
            if all(os.path.exists(os.path.join(full_path, f)) for f in REQUIRED_FILES):
                return full_path

    sys.stderr.write("Error: Could not find a valid hp-wmi hwmon directory with fan controls.\n")
    sys.exit(1)


def read_file(path: str) -> str | None:
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read().strip()
    except OSError as e:
        sys.stderr.write(f"Error reading {path}: {e}\n")
        return None


def write_file(path: str, value: str) -> bool:
    try:
        with open(path, "w", encoding="utf-8") as f:
            f.write(value)
        return True
    except PermissionError:
        sys.stderr.write(f"Permission denied writing to {path}. Please run with sudo.\n")
    except OSError as e:
        sys.stderr.write(f"Error writing to {path}: {e}\n")
    return False


def format_mode(pwm_val: str | None) -> str:
    if pwm_val == "2":
        return "2 (Automatic)"
    if pwm_val == "0":
        return "0 (Manual / Max RPM)"
    return f"{pwm_val} (Unknown)"


def show_status(hwmon_path: str) -> None:
    fan1 = read_file(os.path.join(hwmon_path, "fan1_input"))
    fan2 = read_file(os.path.join(hwmon_path, "fan2_input"))
    pwm = read_file(os.path.join(hwmon_path, "pwm1_enable"))

    print("=== HP Omen Fan Status ===")
    if fan1 is not None:
        print(f"  Fan 1 (CPU) : {fan1} RPM")
    if fan2 is not None:
        print(f"  Fan 2 (GPU) : {fan2} RPM")
    print(f"  PWM Mode    : {format_mode(pwm)}")


def set_mode(hwmon_path: str, state: str) -> None:
    pwm_path = os.path.join(hwmon_path, "pwm1_enable")
    if not write_file(pwm_path, state):
        sys.exit(1)
    label = "Max Mode (0)" if state == "0" else "Auto Mode (2)"
    print(f"✓ HP Omen fans set to: {label}")
    show_status(hwmon_path)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="HP Omen fan controller via hp-wmi hwmon interface."
    )
    parser.add_argument(
        "action",
        nargs="?",
        default="toggle",
        choices=["toggle", "status", "max", "auto", "0", "2"],
        help="Action to perform (default: toggle between Auto and Max)",
    )
    args = parser.parse_args()

    hwmon_path = find_hwmon_path()
    pwm_path = os.path.join(hwmon_path, "pwm1_enable")

    if args.action == "status":
        show_status(hwmon_path)
    elif args.action in ("max", "0"):
        set_mode(hwmon_path, "0")
    elif args.action in ("auto", "2"):
        set_mode(hwmon_path, "2")
    elif args.action == "toggle":
        current = read_file(pwm_path)
        if current is None:
            sys.exit(1)
        new_state = "0" if current == "2" else "2"
        set_mode(hwmon_path, new_state)


if __name__ == "__main__":
    main()

