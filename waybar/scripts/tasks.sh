#!/bin/sh
set -eu

tw() {
    task rc.verbose=nothing rc.context=none "$@"
}

pending=$(tw status:pending -WAITING count)
upcoming=$(tw status:pending -WAITING due.after:now due.before:now+24hours count)
overdue=$(tw status:pending -WAITING due.before:now count)

text=$(printf \
    '<span foreground="#ffffff" weight="bold">%s</span>  <span foreground="#ffb000" weight="bold">%s</span>  <span foreground="#ff4040" weight="bold">%s</span>' \
    "$pending" "$upcoming" "$overdue")

tooltip=$(printf \
    'Tasks to do: %s\nDue within 24 hours: %s\nOverdue: %s' \
    "$pending" "$upcoming" "$overdue")

jq -cn \
    --arg text "$text" \
    --arg tooltip "$tooltip" \
    '{text: $text, tooltip: $tooltip}'
