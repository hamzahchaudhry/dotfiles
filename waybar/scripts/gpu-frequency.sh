#!/bin/sh

frequency=$(cat /sys/class/drm/card0/gt/gt0/rps_act_freq_mhz)
min_frequency=$(cat /sys/class/drm/card0/gt/gt0/rps_min_freq_mhz)
max_frequency=$(cat /sys/class/drm/card0/gt/gt0/rps_max_freq_mhz)

printf '{"text":"󰢮 %sMHz","tooltip":"GPU range: %s–%s MHz"}\n' \
  "$frequency" "$min_frequency" "$max_frequency"
