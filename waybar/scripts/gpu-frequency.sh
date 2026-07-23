#!/bin/sh

set -eu

base=/sys/class/drm/card0/gt/gt0
read -r frequency < "$base/rps_act_freq_mhz"
read -r minimum < "$base/rps_min_freq_mhz"
read -r maximum < "$base/rps_max_freq_mhz"

printf '{"text":"󰢮 %sMHz","tooltip":"GPU range: %s–%s MHz"}\n' "$frequency" "$minimum" "$maximum"
