#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$SCRIPT_DIR/power_common.sh"

STATE_FILE="/tmp/waybar-cpu-pkg.state"

cpu_text=$(read_cpu_pkg_power "$STATE_FILE")
tooltip="CPU package power: ${cpu_text}"

if load_battery_info && [ -n "${BAT_POWER_NOW_UW:-}" ] && [ "${BAT_POWER_NOW_UW:-0}" -gt 0 ] 2>/dev/null; then
  total_w=$(format_power_w "$BAT_POWER_NOW_UW")

  case "$BAT_STATUS" in
    Discharging)
      tooltip="$tooltip
System draw: ${total_w} W"
      ;;
    Charging)
      tooltip="$tooltip
Charge rate: ${total_w} W"
      ;;
  esac

  if [ "$BAT_STATUS" = "Discharging" ] && [ "$cpu_text" != "..." ]; then
    cpu_share=$(awk -v cpu="${cpu_text%W}" -v total="$total_w" 'BEGIN {
      if (total <= 0) exit 1
      printf "%.0f%%", (cpu / total) * 100
    }' 2>/dev/null || printf '')
    if [ -n "$cpu_share" ]; then
      tooltip="$tooltip
CPU share of system draw: ${cpu_share}"
    fi
  fi
fi

tooltip_escaped=$(json_escape "$tooltip")
printf '{"text":"%s","tooltip":"%s"}\n' "$cpu_text" "$tooltip_escaped"
