#!/bin/sh

set -eu

icon_on=microphone-sensitivity-high
icon_off=microphone-sensitivity-muted
mic=alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source

if pgrep -x easyeffects >/dev/null; then
  pactl set-source-mute "$mic" 1
  easyeffects -q >/dev/null 2>&1
  notify-send -c off -a "EasyEffects" -i "$icon_off" "Mic Off" "Processing off"
else
  pactl set-source-mute "$mic" 0
  easyeffects --service-mode -w >/dev/null 2>&1 &
  notify-send -c on -a "EasyEffects" -i "$icon_on" "Mic On" "Processing on"
fi
