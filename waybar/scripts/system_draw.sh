#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$SCRIPT_DIR/power_common.sh"

CPU_STATE_FILE="/tmp/waybar-system-draw-cpu-pkg.state"

if ! load_battery_info; then
  printf '{"text":"--","tooltip":"No battery found","class":["unknown"]}\n'
  exit 0
fi

class_name=$(printf '%s' "$BAT_STATUS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
cpu_text=$(read_cpu_pkg_power "$CPU_STATE_FILE")
tooltip=""

if [ -n "${BAT_POWER_NOW_UW:-}" ] && [ "${BAT_POWER_NOW_UW:-0}" -gt 0 ] 2>/dev/null; then
  power_w=$(format_power_w "$BAT_POWER_NOW_UW")

  case "$BAT_STATUS" in
    Discharging)
      text="󰾆 ${power_w}W"
      tooltip="System draw: ${power_w} W"
      ;;
    Charging)
      text="󱐋 +${power_w}W"
      tooltip="Charge rate: ${power_w} W"
      ;;
    *)
      text=" ${power_w}W"
      tooltip="Battery power flow: ${power_w} W"
      ;;
  esac

  if [ "$cpu_text" != "..." ]; then
    tooltip="$tooltip
CPU package: ${cpu_text}"

    cpu_share=$(awk -v cpu="${cpu_text%W}" -v total="$power_w" 'BEGIN {
      if (total <= 0) exit 1
      printf "%.0f%%", (cpu / total) * 100
    }' 2>/dev/null || printf '')
    if [ -n "$cpu_share" ]; then
      tooltip="$tooltip
CPU share of total: ${cpu_share}"
    fi
  fi
else
  case "$BAT_STATUS" in
    Full)
      text=" full"
      tooltip="System draw unavailable on AC
Battery is full"
      ;;
    Not\ charging)
      text=" idle"
      tooltip="System draw unavailable on AC
AC online, battery not charging"
      ;;
    *)
      text="--"
      tooltip="Power rate unavailable"
      ;;
  esac
fi

tooltip_escaped=$(json_escape "$tooltip")
printf '{"text":"%s","tooltip":"%s","class":["%s"]}\n' "$text" "$tooltip_escaped" "$class_name"
