#!/bin/sh

set -eu

sink='@DEFAULT_AUDIO_SINK@'

volume_state() {
  wpctl get-volume "$sink"
}

volume_percent() {
  volume_state | awk '{printf "%d\n", $2 * 100}'
}

is_muted() {
  volume_state | grep -q 'MUTED'
}

case "${1:-}" in
  up)
    if is_muted; then
      wpctl set-mute "$sink" 0
    fi

    wpctl set-volume -l 1.5 "$sink" 5%+
    ;;
  down)
    wpctl set-volume "$sink" 5%-

    if [ "$(volume_percent)" -eq 0 ]; then
      wpctl set-mute "$sink" 1
    fi
    ;;
  mute)
    wpctl set-mute "$sink" toggle
    ;;
  *)
    printf 'usage: %s {up|down|mute}\n' "$0" >&2
    exit 1
    ;;
esac

if is_muted; then
  printf '0 muted\n' > /tmp/wobpipe
else
  volume_percent > /tmp/wobpipe
fi
