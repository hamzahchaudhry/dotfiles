#!/bin/sh

set -eu

read_power_w() {
  energy_file=$1
  max_file=$2
  state_file=$3

  [ -r "$energy_file" ] || {
    printf '...'
    return 0
  }

  now_t=$(date +%s%N)
  now_e=$(cat "$energy_file")
  watts="..."

  if [ -r "$state_file" ]; then
    read -r prev_t prev_e < "$state_file"
    dt=$((now_t - prev_t))
    de=$((now_e - prev_e))

    if [ "$de" -lt 0 ] && [ -r "$max_file" ]; then
      max=$(cat "$max_file")
      de=$(((max - prev_e) + now_e))
    fi

    watts=$(awk -v de="$de" -v dt="$dt" 'BEGIN {
      if (dt <= 0) {
        printf "..."
        exit
      }
      printf "%.1fW", (de * 1000) / dt
    }')
  fi

  printf '%s %s\n' "$now_t" "$now_e" > "$state_file"
  printf '%s' "$watts"
}

cpu_text=$(read_power_w \
  /sys/class/powercap/intel-rapl:0/energy_uj \
  /sys/class/powercap/intel-rapl:0/max_energy_range_uj \
  /tmp/waybar-power-cpu.state)

total_text=$(read_power_w \
  /sys/class/powercap/intel-rapl:1/energy_uj \
  /sys/class/powercap/intel-rapl:1/max_energy_range_uj \
  /tmp/waybar-power-psys.state)

text=" ${cpu_text} 󰾆 ${total_text}"
tooltip="CPU package: ${cpu_text}\\nSystem power: ${total_text}"
printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"
