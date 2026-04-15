#!/bin/sh

set -eu

battery_dir=/sys/class/power_supply/BAT0
ac_dir=/sys/class/power_supply/ADP1

battery_text() {
  if [ "$2" = "online" ]; then
    printf ' %s%%' "$1"
  elif [ "$1" -ge 90 ] 2>/dev/null; then
    printf ' %s%%' "$1"
  elif [ "$1" -ge 65 ] 2>/dev/null; then
    printf ' %s%%' "$1"
  elif [ "$1" -ge 40 ] 2>/dev/null; then
    printf ' %s%%' "$1"
  elif [ "$1" -ge 15 ] 2>/dev/null; then
    printf ' %s%%' "$1"
  else
    printf ' %s%%' "$1"
  fi
}

if [ ! -r "$battery_dir/status" ]; then
  printf '{"text":"--","tooltip":"No battery found","class":["unknown"]}\n'
  exit 0
fi

capacity=$(cat "$battery_dir/capacity" 2>/dev/null || printf '?')
energy_now=$(cat "$battery_dir/energy_now" 2>/dev/null || printf '')
energy_full=$(cat "$battery_dir/energy_full" 2>/dev/null || printf '')
power_uw=$(cat "$battery_dir/power_now" 2>/dev/null || printf '')

ac_online=offline
[ "$(cat "$ac_dir/online" 2>/dev/null || printf '0')" = "1" ] && ac_online=online

text=$(battery_text "$capacity" "$ac_online")
class_name=$([ "$ac_online" = "online" ] && printf plugged || printf battery)
extra_class=
[ "$capacity" -lt 20 ] 2>/dev/null && extra_class=',"low"'

tooltip="Battery: ${capacity}%"

if [ -n "$energy_now" ] && [ -n "$energy_full" ]; then
  tooltip="${tooltip}\\n$(awk -v now="$energy_now" -v full="$energy_full" 'BEGIN {
  printf "Energy: %.1f / %.1f Wh", now / 1000000, full / 1000000
}')"
fi

if [ -n "$power_uw" ] && [ "$power_uw" -gt 0 ] 2>/dev/null; then
  power_w=$(awk -v p="$power_uw" 'BEGIN { printf "%.1f", p / 1000000 }')
  if [ "$ac_online" = "online" ]; then
    tooltip="${tooltip}\\nBattery flow: +${power_w} W"
  else
    tooltip="${tooltip}\\nBattery flow: -${power_w} W"
  fi
fi

tooltip="${tooltip}\\nAC: $( [ "$ac_online" = "online" ] && printf connected || printf disconnected )"

printf '{"text":"%s","tooltip":"%s","class":["%s"%s],"percentage":%s}\n' \
  "$text" "$tooltip" "$class_name" "$extra_class" "$capacity"
