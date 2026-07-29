#!/bin/sh

set -eu

XDG_RUNTIME_DIR=/tmp/xdg-runtime-$LOGNAME
read -r DBUS_SESSION_BUS_ADDRESS < "$XDG_RUNTIME_DIR/dbus-address" || exit 0
export DBUS_SESSION_BUS_ADDRESS

window=now+24hours

tw() {
  task rc.verbose=nothing rc.context=none status:pending -WAITING "$@"
}

overdue=$(tw due.before:now count)
upcoming=$(tw due.after:now due.before:"$window" count)

[ "$overdue" -eq 0 ] && [ "$upcoming" -eq 0 ] && exit 0

list=$(tw due.before:"$window" notify 2>/dev/null | head -n 20)

[ "$overdue" -gt 0 ] && urgency=critical || urgency=normal
[ "$overdue" -gt 0 ] && icon=task-past-due || icon=task-due

exec notify-send -a task-notify-due -c tasks -u "$urgency" -i "$icon" "$upcoming upcoming, $overdue overdue" "${list:-No tasks due in the next 24 hours.}"
