#!/bin/sh

task rc.verbose=nothing rc.context=none status:pending -WAITING export |
  jq -c '
    def epoch: strptime("%Y%m%dT%H%M%SZ") | mktime;
    now as $now |
    length as $pending |
    ([.[] | select(.due? and (.due | epoch) < $now)] | length) as $overdue |
    ([.[] | select(.due? and (.due | epoch) >= $now and (.due | epoch) < ($now + 86400))] | length) as $upcoming |
    {
      text: "<span foreground=\"#ffffff\" weight=\"bold\">\($pending)</span>  <span foreground=\"#ffb000\" weight=\"bold\">\($upcoming)</span>  <span foreground=\"#ff4040\" weight=\"bold\">\($overdue)</span>",
      tooltip: "Tasks to do: \($pending)\nDue within 24 hours: \($upcoming)\nOverdue: \($overdue)"
    }'
