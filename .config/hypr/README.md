# Hyprland Configuration

My personal Hyprland setup with Lua configuration.

## Overview

- **Terminal:** kitty
- **File Manager:** thunar
- **App Launcher:** rofi
- **Status Bar:** waybar
- **Notifications:** swaync
- **Main Modifier:** SUPER (Windows key)

## Essential Shortcuts

### System

| Shortcut | Action |
|----------|--------|
| `SUPER + L` | Lock screen |
| `SUPER + M` | Logout menu |
| `SUPER + Z` | Open terminal |
| `SUPER + Space` | App launcher |
| `SUPER + R` | App launcher (alternative) |

### Brightness & Volume

| Shortcut | Action |
|----------|--------|
| `XF86MonBrightnessUp/Down` | Adjust brightness |
| `SUPER + Volume Up/Down` | Adjust brightness (alternative) |
| `Volume Up/Down` | Adjust volume |
| `Mute` | Toggle audio mute |

### Screenshots

| Shortcut | Action |
|----------|--------|
| `Print` | Full screenshot |
| `SHIFT + Print` | Region screenshot |

### Window Management

| Shortcut | Action |
|----------|--------|
| `SUPER + Q` | Close window |
| `SUPER + E` | File manager |
| `SUPER + B` | Clipboard history |
| `SUPER + V` | Toggle float |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + TAB` | Workspace overview (Hymission) |

### Navigation

| Shortcut | Action |
|----------|--------|
| `SUPER + Arrow Keys` | Move focus |
| `SUPER + SHIFT + Arrow Keys` | Swap windows |

### Workspaces

| Shortcut | Action |
|----------|--------|
| `SUPER + F1-F5` | Switch to workspace 1-5 |
| `SUPER + SHIFT + F1-F5` | Move window to workspace 1-5 |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + SHIFT + S` | Move window to scratchpad |

### Media Control

| Shortcut | Action |
|----------|--------|
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86AudioPlay` | Play/Pause |

## Plugins

- **HyprGlass:** Glass transparency effects for windows and layers
- **Hymission:** Workspace overview (accessible with `SUPER + TAB`)

## Configuration Files

- `hyprland.lua` - Main configuration
- `hypridle.conf` - Idle management
- `hyprlock.conf` - Lock screen
- `hyprpaper.conf` - Wallpaper
- `hyprsunset.conf` - Night light/blue light filter

## Reload Configuration

After making changes, reload with:
```bash
hyprctl reload
```
