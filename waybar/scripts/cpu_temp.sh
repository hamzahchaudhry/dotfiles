#!/bin/sh

set -eu

find_coretemp_input() {
  for dir in /sys/class/hwmon/hwmon*; do
    [ -r "$dir/name" ] || continue
    [ "$(cat "$dir/name")" = "coretemp" ] || continue

    for label in "$dir"/temp*_label; do
      [ -r "$label" ] || continue
      if [ "$(cat "$label")" = "Package id 0" ]; then
        printf '%s\n' "${label%_label}_input"
        return 0
      fi
    done

    if [ -r "$dir/temp1_input" ]; then
      printf '%s\n' "$dir/temp1_input"
      return 0
    fi
  done

  return 1
}

input=$(find_coretemp_input || true)
if [ -z "$input" ] || [ ! -r "$input" ]; then
  printf '{"text":" --°","tooltip":"CPU package temperature unavailable","class":["unknown"]}\n'
  exit 0
fi

temp_millic=$(cat "$input")
temp_c=$(awk -v t="$temp_millic" 'BEGIN { printf "%.0f", t / 1000 }')

if [ "$temp_c" -ge 90 ] 2>/dev/null; then
  icon=""
  class_name="critical"
elif [ "$temp_c" -ge 80 ] 2>/dev/null; then
  icon=""
  class_name="warning"
elif [ "$temp_c" -ge 70 ] 2>/dev/null; then
  icon=""
  class_name="warm"
elif [ "$temp_c" -ge 55 ] 2>/dev/null; then
  icon=""
  class_name="normal"
else
  icon=""
  class_name="cool"
fi

tooltip=$(printf 'CPU package temperature: %s C\nSensor: %s' "$temp_c" "$input")
tooltip_escaped=$(printf '%s' "$tooltip" | sed ':a;N;$!ba;s/\\/\\\\/g;s/"/\\"/g;s/\n/\\n/g')

printf '{"text":"%s %s°","tooltip":"%s","class":["%s"]}\n' \
  "$icon" "$temp_c" "$tooltip_escaped" "$class_name"
