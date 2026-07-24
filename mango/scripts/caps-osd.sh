#!/bin/sh

set -eu

enabled=
for led in /sys/class/leds/*::capslock/brightness; do
  [ -r "$led" ] || continue
  read -r state < "$led"
  [ "$state" -eq 0 ] || {
    enabled=1
    break
  }
done

if [ -n "$enabled" ]; then
  notify-send -c on -i input-keyboard "Caps Lock" "Enabled"
else
  notify-send -c off -i input-keyboard "Caps Lock" "Disabled"
fi
