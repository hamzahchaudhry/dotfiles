#!/bin/sh

set -eu

case "${1:-}" in
  up)
    brightnessctl s 5%+
    ;;
  down)
    brightnessctl -n s 5%-
    ;;
  *)
    printf 'usage: %s {up|down}\n' "$0" >&2
    exit 1
    ;;
esac

brightnessctl -m | cut -d, -f4 | tr -d '%' > /tmp/wobpipe
