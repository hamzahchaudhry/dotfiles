#!/bin/sh

set -eu

case "${1:-}" in
  up)
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
  *)
    printf 'usage: %s {up|down|mute}\n' "$0" >&2
    exit 1
    ;;
esac

wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '/MUTED/{print 0; exit}{printf "%d\n",$2*100}' > /tmp/wobpipe
