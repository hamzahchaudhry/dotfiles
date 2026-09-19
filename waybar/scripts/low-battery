#!/bin/sh

read -r capacity < /sys/class/power_supply/BAT0/capacity

doas -n tlp power-saver
brightnessctl set 30%
notify-send -u critical -a Power -i battery-caution "Battery low" "Battery at ${capacity}%, enabling low-power actions"
