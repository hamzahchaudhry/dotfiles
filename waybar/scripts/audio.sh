#!/bin/sh

set -eu

read_volume() {
  target=$1
  wpctl get-volume "$target" 2>/dev/null || return 1
}

parse_percent() {
  awk '{
    for (i = 1; i <= NF; i++) {
      if ($i ~ /^[0-9]+(\.[0-9]+)?$/) {
        printf "%.0f", $i * 100
        exit
      }
    }
  }'
}

sink=$(read_volume @DEFAULT_AUDIO_SINK@ || true)
source=$(read_volume @DEFAULT_AUDIO_SOURCE@ || true)

if [ -z "$sink" ] && [ -z "$source" ]; then
  printf '{"text":"󰖁 --","tooltip":"PipeWire/WirePlumber unavailable","class":["muted"]}\n'
  exit 0
fi

sink_percent=$(printf '%s\n' "$sink" | parse_percent)
source_percent=$(printf '%s\n' "$source" | parse_percent)

sink_muted=
source_muted=
printf '%s\n' "$sink" | grep -q '\[MUTED\]' && sink_muted=1
printf '%s\n' "$source" | grep -q '\[MUTED\]' && source_muted=1

if [ -n "$sink_muted" ]; then
  sink_icon="󰖁"
elif [ "${sink_percent:-0}" -ge 66 ] 2>/dev/null; then
  sink_icon=""
elif [ "${sink_percent:-0}" -ge 33 ] 2>/dev/null; then
  sink_icon=""
else
  sink_icon=""
fi

if [ -n "$source_muted" ]; then
  source_text=""
else
  source_text=" ${source_percent:-0}%"
fi

classes=
[ -n "$sink_muted" ] && classes=',"muted"'

printf '{"text":"%s%% %s %s","tooltip":"Sink: %s\\nSource: %s","class":["audio"%s],"percentage":%s}\n' \
  "${sink_percent:-0}" "$sink_icon" "$source_text" "$sink" "$source" "$classes" "${sink_percent:-0}"
