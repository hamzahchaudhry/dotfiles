#!/usr/bin/env bash

BAT_PATH="/sys/class/power_supply/BAT0"
THRESHOLD=15
BRIGHTNESS=30

CAP=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

if [[ "$STATUS" == "Discharging" ]] && ((CAP <= THRESHOLD)); then
  # Run TLP power-saver profile
  /usr/bin/sudo /usr/bin/tlp power-saver

  # Lower brightness
  for d in /sys/class/backlight/*; do
    echo "$BRIGHTNESS" | sudo tee "$d/brightness" >/dev/null
  done

  # Send notifications
  notify-send -u critical "Battery low" "Battery at ${CAP}%, entering power-saver mode"
fi
