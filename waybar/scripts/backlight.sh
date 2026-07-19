#!/bin/sh

set -eu

backlight_dir=
for dir in /sys/class/backlight/*; do
  [ -d "$dir" ] || continue
  [ -r "$dir/brightness" ] || continue
  [ -r "$dir/max_brightness" ] || continue
  backlight_dir=$dir
  break
done

if [ -z "$backlight_dir" ]; then
  printf '{"text":"󰃠 --","tooltip":"No backlight device found","class":["unknown"]}\n'
  exit 0
fi

brightness=$(cat "$backlight_dir/brightness" 2>/dev/null || printf 0)
max_brightness=$(cat "$backlight_dir/max_brightness" 2>/dev/null || printf 0)
percent=$(awk -v b="$brightness" -v m="$max_brightness" 'BEGIN {
  if (m <= 0) {
    print 0
    exit
  }
  printf "%.0f", (b * 100) / m
}')

if [ "$percent" -ge 80 ] 2>/dev/null; then
  icon="󰛨"
elif [ "$percent" -ge 60 ] 2>/dev/null; then
  icon="󱩕"
elif [ "$percent" -ge 40 ] 2>/dev/null; then
  icon="󱩓"
elif [ "$percent" -ge 20 ] 2>/dev/null; then
  icon="󱩑"
else
  icon="󱩎"
fi

printf '{"text":"%s %s%%","percentage":%s}\n' "$icon" "$percent" "$percent"
