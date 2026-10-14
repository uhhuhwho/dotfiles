-- Ported from hyprland.conf to hyprland.lua
-- Refer to the wiki for more information: https://wiki.hypr.land/Configuring/Start/


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin" -- "dolphin" -- "thunar"
local menu        = "hyprlauncher"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    -- Hyprland ecosystem
    hl.exec_cmd("hyprpm reload")
    -- hl.exec_cmd("waybar")
    hl.exec_cmd("wayle panel start")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaync")
    -- Others
    hl.exec_cmd("waypaper --restore & while true; do sleep 300; waypaper --random; done")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    -- Clipboard (cliphist)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- Polkit agent
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    -- Auto-mount
    hl.exec_cmd("udiskie")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- GDK scale
hl.env("GDK_SCALE", "1")

-- HyprCursor
hl.env("HYPRCURSOR_THEME", "Future-Cyan-Hyprcursor_Theme")
hl.env("HYPRCURSOR_SIZE", "28")

-- Cursor
hl.env("XCURSOR_SIZE", "24")

-- Wayland app support
hl.env("NIXOS_OZONE_WL", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("OZONE_PLATFORM", "wayland")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Toolkit backend variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- QT variables
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Uncomment to enforce permissions (requires Hyprland restart)
-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-------------------
---- PLUGINS  ----
-------------------

if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    hg.config({
        default_theme = "dark",
        default_preset = "glass",
        tint_color = 0x8899aa22,

        brightness = 0.9,
        dark = { brightness = 0.82 },
        light = { adaptive_boost = 0.5 },

        layers = { enabled = 1 },
    })

    -- Layer surfaces: each call whitelists the namespace and configures it
    hg.layer("waybar", { preset = "subtle", mask_threshold = 0.05 })
    hg.layer("swaync")
    hg.layer("quickshell:bezel", { preset = "ui", mask_threshold = 0.3 })
    hg.layer("debug-panel", { exclude = true })

    -- Presets
    hg.preset("clear", {
        glass_opacity = 0.8,
        blur_strength = 1.5,
        dark = { brightness = 0.7 },
        light = { brightness = 1.2 },
    })

    hg.preset("contrasted", {
        inherits = "high_contrast",
        contrast = 1.2,
        adaptive_dim = 1.5,
        dark = { tint_color = 0x02142aa9 },
    })
end

-- HyMission (Already installed, add it)

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 2,

        border_size = 0,

        col = {
            active_border   = "rgba(595959aa)",
            inactive_border = "rgba(000000aa)",
        },

        -- Enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = false,

        layout = "dwindle",

        snap = {
            enabled = true,
        },
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        border_part_of_window = true,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.97,

        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 15,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Bezier curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0}  } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Animations
hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint",   style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",         style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint",   style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",         style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear",   style = "fade" })

-- Master layout
hl.config({
    master = {
        new_status = "master",
    },
})

-- Misc
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

-- Debug
hl.config({
    debug = {
        vfr = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "fr, ara",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle,caps:digits_row",
        kb_rules   = "",
        repeat_rate  = 25,
        repeat_delay = 600,

        follow_mouse = 1,
        force_no_accel = false,

        touchpad = {
            disable_while_typing = false,
        },
    },
})

-- Touchpad (ThinkPad X230 Synaptics)
hl.device({
    name = "synps/2-synaptics-touchpad",
    enabled = true,
    sensitivity = 0.8,
    -- accel_profile = "flat",
    natural_scroll = false,
    scroll_factor = 2,
    tap_to_click = true,
})

-- Touchpad (Honor MagicBook ELAN)
hl.device({
    name = "elan2204:00-04f3:30f5-touchpad",
    enabled = true,
    sensitivity = 0.4,
    natural_scroll = true,
    scroll_factor = 1.2,
    tap_to_click = true,
})

-- Tune the TrackPoint for better responsiveness (ThinkPad X230)
hl.device({
    name = "tpps/2-ibm-trackpoint",
    enabled = true,
    sensitivity = 1,          -- Boost speed (range is -1.0 to 1.0)
    accel_profile = "flat",     -- Pure 1:1 movement without erratic jumps
})

-----------------
---- GESTURES ---
-----------------

-- Swipe with 3 fingers + SUPER up or down to fullscreen
-- 02 Jun 2026: Broken for now
-- hl.gesture({ fingers = 3, direction = "up",         mod = "SUPER", scale = 1.5, action = "fullscreen" })
-- hl.gesture({ fingers = 3, direction = "down",       mod = "SUPER", scale = 1.5, action = "fullscreen" })
-- hl.gesture({ fingers = 3, direction = "horizontal", mod = "SUPER", action = "workspace" })

hl.config({
    gestures = {
        workspace_swipe_invert   = false,
        workspace_swipe_distance = 100,
    },
})

-----------------
---- DEVICES ----
-----------------

hl.device({
    name           = "razer-razer-viper-mini",
    sensitivity    = -0.5,
    natural_scroll = false,
})

hl.device({
    name           = "razer-razer-viper-mini-1",
    sensitivity    = -0.5,
    natural_scroll = false,
})

--------------------
---- ECOSYSTEM ----
--------------------

hl.config({
    ecosystem = {
        no_update_news  = false,
        no_donation_nag = false,
    },
})


------------------
---- XWAYLAND ----
------------------GDK_SCALE

hl.config({
    xwayland = {
        enabled            = true,
        force_zero_scaling = true,
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Lock the screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +1%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 1%-"))

-- Terminal
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(terminal))

-- Bind the blue ThinkVantage button to toggle ThinkLight on ThinkPad X230
hl.bind("XF86Launch1", hl.dsp.exec_cmd('"$HOME/dotfiles/scripts/hardware/thinkpad/thinklight-toggle.sh"'))

-- Space -> launcher
-- hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
-- Vucunae --
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("vicinae toggle"))

-- blur
hl.layer_rule({
  match = { namespace = "vicinae" },
  name = "vicinae-blur",
  blur = true,
  ignore_alpha = 0,
})

-- disable animation for vicinae only
hl.layer_rule({
  match = { namespace = "vicinae" },
  name = "vicinae-no-animation",
  no_anim = true,
})

-- Vicinae --

-- R -> launcher
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("vicinae toggle"))

-- Region screenshot
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('file="$(xdg-user-dir PICTURES)/Screenshots/$(date +\'%s_grim.png\')" && grim -g "$(slurp)" "$file" && notify-send "Screenshot taken" "Saved as $(basename "$file")"'))

-- Full screenshot
hl.bind("Print", hl.dsp.exec_cmd('file="$(xdg-user-dir PICTURES)/Screenshots/$(date +\'%s_grim.png\')" && grim "$file" && notify-send "Screenshot taken" "Saved as $(basename "$file")"'))

-- Clipboard
-- hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Swap windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Switch workspaces with mainMod + F1-F5
-- Move active window to workspace with mainMod + SHIFT + F1-F5
for i = 1, 5 do
    hl.bind(mainMod .. " + F" .. i,            hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + F" .. i,    hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Switch between existing workspaces with mainMod + scroll

hl.bind(mainMod .. " + E", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"),                                          { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),                                                { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send "Audio" "Output mute toggled"'),  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify-send "Audio" "Output mute toggled"'),{ locked = true, repeating = true })

-- Brightness with SUPER + Volume keys
hl.bind(mainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("brightnessctl s +1%"), { repeating = true })
hl.bind(mainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("brightnessctl s 1%-"), { repeating = true })

-- Media keys (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- HyprMod managed settings
require("hyprland-gui")
