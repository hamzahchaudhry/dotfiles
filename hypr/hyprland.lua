-- monitors
hl.monitor({ output = "eDP-1", position = "0x0", scale = "1" })
hl.monitor({ output = "HDMI-A-1", position = "auto-up", scale = "1" })
hl.monitor({ output = "desc:Plain Tree Systems Inc 0x076F", position = "auto-right", scale = "1" })
hl.monitor({ output = "desc:Dell Inc. DELL P2425H HHNRC74", mode = "highrr", position = "auto-up", scale = "1" })

-- input
hl.config({ input = { sensitivity = 0.5, touchpad = { natural_scroll = true } } })
hl.device({ name = "2.4g-wireless-mouse", sensitivity = -0.5 })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- settings
hl.config({
    general = { gaps_in = 0, gaps_out = 0, col = { active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 } } },
    decoration = { shadow = { enabled = false }, blur = { enabled = false } },
    xwayland = { enabled = false },
})

hl.config({ animations = { enabled = false } })

-- environment
hl.env("HYPRCURSOR_THEME", "macOS")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NO_AT_BRIDGE", "1")

-- startup
hl.on("hyprland.start", function()
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

-- bindings
local lock_and_suspend = [[sh -c 'pidof hyprlock >/dev/null || hyprlock & sleep 1; doas -n sh -c "echo mem > /sys/power/state"']]

local function mod(key)
    return "SUPER + " .. key
end

local function run(key, command, options)
    hl.bind(key, hl.dsp.exec_cmd(command), options)
end

hl.bind(mod("Q"), hl.dsp.window.close())
run(mod("M"), "hyprshutdown")
hl.bind(mod("F"), hl.dsp.window.fullscreen({ mode = "maximized" }))

for _, item in ipairs({
    { "Return", "footclient" },
    { "B", "firefox" },
    { "D", "fuzzel" },
    { "SHIFT + S", "hyprshot -m region --clipboard-only --freeze" },
    { "V", "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy" },
    { "period", "/home/hamzah/.local/bin/rofimoji --selector fuzzel -a copy" },
    { "Z", "vesktop-bin" },
    { "C", [[footclient --app-id qalcterm sh -c "qalc; exec $SHELL"]] },
    { "T", [[footclient --app-id taskterm sh -c "task limit:20; exec $SHELL"]] },
    { "R", "pkill waybar; waybar &" },
    { "less", "pkill -SIGUSR1 waybar" },
}) do
    run(mod(item[1]), item[2])
end

local focus_keys = { "H", "L", "K", "J" }
local directions = { "left", "right", "up", "down" }

for i, key in ipairs(focus_keys) do
    hl.bind(mod(key), hl.dsp.focus({ direction = directions[i] }))
end

for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(mod(key), hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod("SHIFT + " .. key), hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mod("mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(mod("mouse:273"), hl.dsp.window.resize(), { mouse = true })

for _, item in ipairs({
    { "XF86AudioRaiseVolume", "~/.config/hypr/scripts/wob-volume.sh up" },
    { "XF86AudioLowerVolume", "~/.config/hypr/scripts/wob-volume.sh down" },
    { "XF86AudioMute", "~/.config/hypr/scripts/wob-volume.sh mute" },
    { "XF86MonBrightnessDown", "~/.config/hypr/scripts/wob-brightness.sh down" },
    { "XF86MonBrightnessUp", "~/.config/hypr/scripts/wob-brightness.sh up" },
}) do
    run(item[1], item[2], { locked = true, repeating = true })
end

run("XF86TouchpadOff", [[notify-send -c off -i input-touchpad "Touchpad" "Disabled"]])
run("XF86TouchpadOn", [[notify-send -c on -i input-touchpad "Touchpad" "Enabled"]])
run("XF86Sleep", lock_and_suspend)
run("XF86PowerOff", "hyprlock")
run("CAPS + Caps_Lock", "~/.config/hypr/scripts/caps-osd.sh", { release = true })

-- window rules
for i, workspace in ipairs({ "w[tv1]", "f[1]" }) do
    hl.window_rule({ name = "single-window-" .. i, match = { float = false, workspace = workspace }, border_size = 0 })
end

for _, app in ipairs({
    { name = "qalc", class = "qalcterm" },
    { name = "taskwarrior", class = "taskterm" },
}) do
    hl.window_rule({ name = app.name, match = { class = app.class }, float = true, center = true, size = { 900, 600 } })
end
