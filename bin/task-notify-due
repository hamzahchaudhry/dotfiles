#!/bin/sh

set -eu

XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_RUNTIME_DIR

read -r DBUS_SESSION_BUS_ADDRESS < "$XDG_RUNTIME_DIR/dbus-address" || exit 1
export DBUS_SESSION_BUS_ADDRESS

tw() {
  task rc.verbose=nothing rc.context=none status:pending -WAITING "$@"
}

total=$(tw due.any: count)
overdue=$(tw due.before:now count)
upcoming=$((total - overdue))

[ "$total" -eq 0 ] && exit 0

list=$(
  tw due.any: export | jq -r '
    sort_by(.due)[] |
    "• \(.description)\n  \(.project // "no project") · \(.due | strptime("%Y%m%dT%H%M%SZ") | strftime("%b %-d"))"
  '
)

[ "$overdue" -gt 0 ] && urgency=critical || urgency=normal
[ "$overdue" -gt 0 ] && icon=appointment-missed || icon=appointment-soon

exec notify-send -a task-notify-due -c tasks -u "$urgency" -i "$icon" "$upcoming upcoming · $overdue overdue" "$list"
