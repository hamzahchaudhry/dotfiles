#!/bin/sh

for led in /sys/class/leds/*::capslock/brightness; do
  read -r state 2>/dev/null < "$led" || continue
  [ "$state" = 0 ] || exec notify-send -c on -i input-keyboard "Caps Lock" "Enabled"
done

exec notify-send -c off -i input-keyboard "Caps Lock" "Disabled"
