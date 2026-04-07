#!/bin/sh

set -eu

if hyprctl devices -j | jq -e '.keyboards[] | select(.main == true and .capsLock == true)' >/dev/null; then
  notify-send -c on -i input-keyboard "Caps Lock" "Enabled"
else
  notify-send -c off -i input-keyboard "Caps Lock" "Disabled"
fi
