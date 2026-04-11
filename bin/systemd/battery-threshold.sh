#!/bin/sh

set -eu

BAT_PATH=/sys/class/power_supply/BAT0
THRESHOLD=20
BRIGHTNESS=30%
STATE_FILE=${XDG_RUNTIME_DIR:-/tmp}/battery-threshold.active
ICON=/usr/share/icons/AdwaitaLegacy/48x48/legacy/battery-caution.png

capacity=$(cat "$BAT_PATH/capacity")
status=$(cat "$BAT_PATH/status")

if [ "$status" = "Discharging" ] && [ "$capacity" -le "$THRESHOLD" ]; then
  if [ ! -e "$STATE_FILE" ]; then
    doas -n /usr/bin/tlp power-saver >/dev/null 2>&1 || true
    brightnessctl set "$BRIGHTNESS" >/dev/null 2>&1 || true
    notify-send \
      -u critical \
      -a "Power" \
      -i "$ICON" \
      "Battery low" \
      "Battery at ${capacity}%, enabling low-power actions"
    : > "$STATE_FILE"
  fi
else
  rm -f "$STATE_FILE"
fi
