#!/bin/sh

set -eu

sink='@DEFAULT_AUDIO_SINK@'
pipe="${XDG_RUNTIME_DIR:?}/wobpipe"

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
    current_volume="$(volume_percent)"

    if [ "$current_volume" -le 5 ]; then
      wpctl set-volume "$sink" 0
      wpctl set-mute "$sink" 1
      :
    else
      if is_muted; then
        wpctl set-mute "$sink" 0
      fi

      wpctl set-volume "$sink" 5%-
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
  printf '0 muted\n' > "$pipe"
else
  volume_percent > "$pipe"
fi
