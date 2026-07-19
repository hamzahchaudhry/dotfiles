hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = "1" })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto-up", scale = "1" })
hl.monitor({ output = "desc:Plain Tree Systems Inc 0x076F", mode = "preferred", position = "auto-right", scale = "1" })
hl.monitor({ output = "desc:Dell Inc. DELL P2425H HHNRC74", mode = "highrr", position = "auto-up", scale = "1" })

hl.env("HYPRCURSOR_THEME", "macOS")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("NO_AT_BRIDGE", "1") -- disable at-spi-bus-launcher and at-spi2-registryd
hl.config({
  xwayland = {
      enabled = false,
  },
})

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("gentoo-pipewire-launcher")
    hl.exec_cmd("~/.config/hypr/scripts/wob-run.sh")
    hl.exec_cmd("foot -s")
    hl.exec_cmd("mako")
    hl.exec_cmd("swaybg -i /home/hamzah/.local/share/wallpapers/supermassive_blackhole.png -m fill")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("waybar")
end)
