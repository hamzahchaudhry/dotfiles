#!/bin/sh

read_first_line() {
  file=$1
  [ -r "$file" ] || return 1
  IFS= read -r value < "$file" || return 1
  printf '%s\n' "$value"
}

find_battery() {
  for dir in /sys/class/power_supply/*; do
    [ -r "$dir/type" ] || continue
    [ "$(cat "$dir/type")" = "Battery" ] && {
      printf '%s\n' "$dir"
      return 0
    }
  done
  return 1
}

find_ac_online() {
  for dir in /sys/class/power_supply/*; do
    [ -r "$dir/type" ] || continue
    case "$(cat "$dir/type")" in
      Mains|USB|USB_C|USB_PD)
        online=$(read_first_line "$dir/online" || printf '0')
        [ "$online" = "1" ] && {
          printf 'online\n'
          return 0
        }
        ;;
    esac
  done
  printf 'offline\n'
}

calc_hours_to_hhmm() {
  hours=$1
  awk -v hours="$hours" 'BEGIN {
    if (hours <= 0) {
      print "0:00"
      exit
    }
    total_minutes = int((hours * 60) + 0.5)
    printf "%d:%02d", int(total_minutes / 60), total_minutes % 60
  }'
}

json_escape() {
  printf '%s' "$1" | sed ':a;N;$!ba;s/\\/\\\\/g;s/"/\\"/g;s/\n/\\n/g'
}

format_power_w() {
  power_uw=$1
  awk -v p="$power_uw" 'BEGIN { printf "%.1f", p / 1000000 }'
}

read_cpu_pkg_power() {
  state_file=$1
  rapl_energy="/sys/class/powercap/intel-rapl:0/energy_uj"
  rapl_max="/sys/class/powercap/intel-rapl:0/max_energy_range_uj"

  [ -r "$rapl_energy" ] || {
    printf '...'
    return 0
  }

  t=$(date +%s%N)
  e=$(cat "$rapl_energy")

  if [ -r "$state_file" ]; then
    read -r pt pe < "$state_file"
    dt=$((t - pt))
    de=$((e - pe))

    if [ "$de" -lt 0 ] && [ -r "$rapl_max" ]; then
      max=$(cat "$rapl_max")
      de=$(((max - pe) + e))
    fi

    cpu_text=$(awk -v de="$de" -v dt="$dt" 'BEGIN {
      if (dt <= 0) {
        printf "..."
        exit
      }
      printf "%.1fW", (de * 1000) / dt
    }')
  else
    cpu_text="..."
  fi

  printf '%s %s\n' "$t" "$e" > "$state_file"
  printf '%s\n' "$cpu_text"
}

load_battery_info() {
  BAT_DIR=$(find_battery 2>/dev/null || true)
  [ -n "$BAT_DIR" ] || return 1

  BAT_STATUS=$(read_first_line "$BAT_DIR/status" || printf 'Unknown')
  BAT_CAPACITY=$(read_first_line "$BAT_DIR/capacity" || printf '?')
  BAT_ENERGY_NOW_UH=$(read_first_line "$BAT_DIR/energy_now" || printf '')
  BAT_ENERGY_FULL_UH=$(read_first_line "$BAT_DIR/energy_full" || printf '')
  BAT_ENERGY_FULL_DESIGN_UH=$(read_first_line "$BAT_DIR/energy_full_design" || printf '')
  BAT_POWER_NOW_UW=$(read_first_line "$BAT_DIR/power_now" || printf '')
  BAT_CYCLE_COUNT=$(read_first_line "$BAT_DIR/cycle_count" || printf 'n/a')

  if [ -z "$BAT_POWER_NOW_UW" ]; then
    current_now_ua=$(read_first_line "$BAT_DIR/current_now" || printf '')
    voltage_now_uv=$(read_first_line "$BAT_DIR/voltage_now" || printf '')
    if [ -n "$current_now_ua" ] && [ -n "$voltage_now_uv" ]; then
      BAT_POWER_NOW_UW=$(awk -v c="$current_now_ua" -v v="$voltage_now_uv" 'BEGIN {
        printf "%.0f", (c * v) / 1000000
      }')
    fi
  fi

  BAT_AC_ONLINE=$(find_ac_online)
  return 0
}

battery_icon() {
  capacity=$1
  status=$2

  case "$status" in
    Charging)
      printf ''
      return 0
      ;;
    Full)
      printf ''
      return 0
      ;;
  esac

  if [ "$capacity" -ge 90 ] 2>/dev/null; then
    printf ''
  elif [ "$capacity" -ge 65 ] 2>/dev/null; then
    printf ''
  elif [ "$capacity" -ge 40 ] 2>/dev/null; then
    printf ''
  elif [ "$capacity" -ge 15 ] 2>/dev/null; then
    printf ''
  else
    printf ''
  fi
}
