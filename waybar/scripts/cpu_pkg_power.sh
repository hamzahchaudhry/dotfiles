#!/bin/sh
R="/sys/class/powercap/intel-rapl:0/energy_uj"
M="/sys/class/powercap/intel-rapl:0/max_energy_range_uj"
S="/tmp/pkg.state"

[ -r "$R" ] || { echo "..."; exit 0; }

t=$(date +%s%N)
e=$(cat "$R")

if [ -r "$S" ]; then
  read -r pt pe < "$S"
  dt=$((t-pt))
  de=$((e-pe))

  # handle wraparound if max range is available
  if [ "$de" -lt 0 ] && [ -r "$M" ]; then
    max=$(cat "$M")
    de=$(( (max - pe) + e ))
  fi

  awk -v de="$de" -v dt="$dt" 'BEGIN{
    if (dt <= 0) { printf "..."; exit }
    printf "%.1fW", (de*1000)/dt
  }'
else
  echo "..."
fi

printf "%s %s\n" "$t" "$e" > "$S"