local mainMod = "SUPER"

local terminal = "footclient"
local browser = "firefox"
local launcher = "fuzzel"
local screenshot = "hyprshot -m region --clipboard-only --freeze"
local clipboard = "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
local emoji_picker = "/home/hamzah/.local/bin/rofimoji --selector fuzzel -a copy"
local discord_client = "vesktop-bin"
local qalc_client = [[footclient --app-id qalcterm sh -c "qalc; exec $SHELL"]]
local task_client = [[footclient --app-id taskterm sh -c "task limit:20; exec $SHELL"]]

local reload_waybar = "pkill waybar; waybar &"
local toggle_waybar = "pkill -SIGUSR1 waybar"
local lock_and_suspend = [[sh -c 'pidof hyprlock >/dev/null || hyprlock & sleep 1; doas -n sh -c "echo mem > /sys/power/state"']]

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd([[hyprctl reload && notify-send "hyprland" "config reloaded"]]))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(emoji_picker))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(discord_client))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(qalc_client))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(task_client))

hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(reload_waybar))
hl.bind(mainMod .. " + less", hl.dsp.exec_cmd(toggle_waybar))

-- Move focus with mainMod + arrow keys or Vim keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/wob-volume.sh up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/wob-volume.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/wob-volume.sh mute"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/wob-brightness.sh down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/wob-brightness.sh up"), { locked = true, repeating = true })

hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd([[notify-send -c off -i input-touchpad "Touchpad" "Disabled"]]))
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd([[notify-send -c on -i input-touchpad "Touchpad" "Enabled"]]))

hl.bind("XF86Sleep", hl.dsp.exec_cmd(lock_and_suspend))
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyprlock"))
hl.bind("CAPS + Caps_Lock", hl.dsp.exec_cmd("~/.config/hypr/scripts/caps-osd.sh"), { release = true })
