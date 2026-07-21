#!/usr/bin/env bash
set -euo pipefail

MAKO_PID=$(pgrep -n -u "$(id -u)" -x mako) || exit 0
DBUS_SESSION_BUS_ADDRESS=$(tr '\0' '\n' < "/proc/$MAKO_PID/environ" | sed -n 's/^DBUS_SESSION_BUS_ADDRESS=//p')
[ -n "$DBUS_SESSION_BUS_ADDRESS" ] || exit 0
export DBUS_SESSION_BUS_ADDRESS

WINDOW="now+24hours"

OVERDUE=$(task rc.verbose=nothing status:pending due.before:now count)
UPCOMING=$(task rc.verbose=nothing status:pending due.after:now due.before:"$WINDOW" count)

[ "$OVERDUE" -eq 0 ] && [ "$UPCOMING" -eq 0 ] && exit 0

LIST=$(task rc.verbose=nothing status:pending due.before:"$WINDOW" notify 2>/dev/null | head -n 20 || true)

[ "$OVERDUE" -gt 0 ] && URGENCY=critical || URGENCY=normal
[ "$OVERDUE" -gt 0 ] && ICON=task-past-due || ICON=task-due

notify-send -a task-notify-due -c tasks -u "$URGENCY" -i "$ICON" "$UPCOMING upcoming, $OVERDUE overdue" "${LIST:-No tasks due in the next 24 hours.}"
