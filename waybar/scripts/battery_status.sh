#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$SCRIPT_DIR/power_common.sh"

if ! load_battery_info; then
  printf '{"text":"--","tooltip":"No battery found","class":["unknown"]}\n'
  exit 0
fi

icon=$(battery_icon "$BAT_CAPACITY" "$BAT_STATUS")
class_name=$(printf '%s' "$BAT_STATUS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

case "$BAT_STATUS" in
  Charging)
    text=" ${BAT_CAPACITY}%"
    ;;
  Full)
    text=" full"
    ;;
  "Not charging")
    text=" ${BAT_CAPACITY}%"
    ;;
  *)
    text="${icon} ${BAT_CAPACITY}%"
    ;;
esac

tooltip="Battery: ${BAT_CAPACITY}%
Status: ${BAT_STATUS}"

if [ -n "${BAT_POWER_NOW_UW:-}" ] && [ "${BAT_POWER_NOW_UW:-0}" -gt 0 ] 2>/dev/null; then
  power_w=$(format_power_w "$BAT_POWER_NOW_UW")

  case "$BAT_STATUS" in
    Discharging)
      tooltip="$tooltip
System draw: ${power_w} W"
      ;;
    Charging)
      tooltip="$tooltip
Charge rate: ${power_w} W"
      ;;
    *)
      tooltip="$tooltip
Battery rate: ${power_w} W"
      ;;
  esac
else
  tooltip="$tooltip
Power rate: unavailable"
fi

if [ -n "$BAT_ENERGY_NOW_UH" ] && [ -n "$BAT_ENERGY_FULL_UH" ]; then
  energy_line=$(awk -v now="$BAT_ENERGY_NOW_UH" -v full="$BAT_ENERGY_FULL_UH" 'BEGIN {
    printf "Energy: %.1f / %.1f Wh", now / 1000000, full / 1000000
  }')
  tooltip="$tooltip
$energy_line"
fi

if [ -n "$BAT_ENERGY_FULL_UH" ] && [ -n "$BAT_ENERGY_FULL_DESIGN_UH" ] && [ "$BAT_ENERGY_FULL_DESIGN_UH" -gt 0 ] 2>/dev/null; then
  health_line=$(awk -v full="$BAT_ENERGY_FULL_UH" -v design="$BAT_ENERGY_FULL_DESIGN_UH" 'BEGIN {
    printf "Health: %.0f%%", (full / design) * 100
  }')
  tooltip="$tooltip
$health_line"
fi

tooltip="$tooltip
Cycles: ${BAT_CYCLE_COUNT}
AC: ${BAT_AC_ONLINE}"

if [ -n "${BAT_POWER_NOW_UW:-}" ] && [ "${BAT_POWER_NOW_UW:-0}" -gt 0 ] 2>/dev/null; then
  if [ "$BAT_STATUS" = "Discharging" ] && [ -n "$BAT_ENERGY_NOW_UH" ]; then
    hours_left=$(awk -v now="$BAT_ENERGY_NOW_UH" -v p="$BAT_POWER_NOW_UW" 'BEGIN { print now / p }')
    tooltip="$tooltip
Time left: $(calc_hours_to_hhmm "$hours_left")"
  elif [ "$BAT_STATUS" = "Charging" ] && [ -n "$BAT_ENERGY_NOW_UH" ] && [ -n "$BAT_ENERGY_FULL_UH" ]; then
    hours_to_full=$(awk -v now="$BAT_ENERGY_NOW_UH" -v full="$BAT_ENERGY_FULL_UH" -v p="$BAT_POWER_NOW_UW" 'BEGIN {
      remaining = full - now
      if (remaining < 0) remaining = 0
      print remaining / p
    }')
    tooltip="$tooltip
Time to full: $(calc_hours_to_hhmm "$hours_to_full")"
  fi
fi

tooltip_escaped=$(json_escape "$tooltip")
printf '{"text":"%s","tooltip":"%s","class":["%s"],"percentage":%s}\n' \
  "$text" "$tooltip_escaped" "$class_name" "$BAT_CAPACITY"
