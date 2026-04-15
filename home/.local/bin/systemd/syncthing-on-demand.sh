#!/usr/bin/env bash

set -euo pipefail

SYNCTHING_HOME="${STHOMEDIR:-$HOME/.local/state/syncthing}"
CONFIG_FILE="$SYNCTHING_HOME/config.xml"
IDLE_GRACE_SECONDS="${IDLE_GRACE_SECONDS:-60}"
STATUS_POLL_SECONDS="${STATUS_POLL_SECONDS:-30}"
STARTUP_TIMEOUT_SECONDS="${STARTUP_TIMEOUT_SECONDS:-60}"

extract_gui_value() {
    local key="$1"
    awk -v key="$key" '
        /<gui / { in_gui=1 }
        in_gui && index($0, "<" key ">") {
            sub("^.*<" key ">", "")
            sub("</" key ">.*$", "")
            print
            exit
        }
        /<\/gui>/ { in_gui=0 }
    ' "$CONFIG_FILE"
}

GUI_ADDRESS="${STGUIADDRESS:-$(extract_gui_value address)}"
GUI_API_KEY="${STGUIAPIKEY:-$(extract_gui_value apikey)}"
BASE_URL="http://$GUI_ADDRESS"

if [ -z "$GUI_ADDRESS" ] || [ -z "$GUI_API_KEY" ]; then
    echo "Missing Syncthing GUI address or API key in $CONFIG_FILE" >&2
    exit 1
fi

cleanup() {
    if [ "${syncthing_pid:-}" ]; then
        if kill -0 "$syncthing_pid" 2>/dev/null; then
            curl -fsS -X POST -H "X-API-Key: $GUI_API_KEY" \
                "$BASE_URL/rest/system/shutdown" >/dev/null 2>&1 || true
            wait "$syncthing_pid" 2>/dev/null || true
        fi
    fi
}

trap cleanup EXIT INT TERM

/usr/bin/syncthing serve --no-browser --no-restart &
syncthing_pid=$!

startup_deadline=$(( $(date +%s) + STARTUP_TIMEOUT_SECONDS ))
while :; do
    if curl -fsS -H "X-API-Key: $GUI_API_KEY" \
        "$BASE_URL/rest/system/ping" >/dev/null 2>&1; then
        break
    fi

    if [ "$(date +%s)" -ge "$startup_deadline" ]; then
        echo "Timed out waiting for Syncthing API at $BASE_URL" >&2
        exit 1
    fi

    sleep 1
done

mapfile -t folder_ids < <(
    curl -fsS -H "X-API-Key: $GUI_API_KEY" "$BASE_URL/rest/config/folders" |
        jq -r '.[].id'
)

if [ "${#folder_ids[@]}" -eq 0 ]; then
    exit 0
fi

idle_since=0

while :; do
    all_idle=1

    for folder_id in "${folder_ids[@]}"; do
        status_json="$(
            curl -fsS -G -H "X-API-Key: $GUI_API_KEY" \
                --data-urlencode "folder=$folder_id" \
                "$BASE_URL/rest/db/status"
        )"

        if ! printf '%s' "$status_json" | jq -e '
            .state == "idle" and
            .needBytes == 0 and
            .needTotalItems == 0
        ' >/dev/null; then
            all_idle=0
            idle_since=0
            break
        fi
    done

    if [ "$all_idle" -eq 1 ]; then
        now="$(date +%s)"
        if [ "$idle_since" -eq 0 ]; then
            idle_since="$now"
        elif [ $(( now - idle_since )) -ge "$IDLE_GRACE_SECONDS" ]; then
            curl -fsS -X POST -H "X-API-Key: $GUI_API_KEY" \
                "$BASE_URL/rest/system/shutdown" >/dev/null
            wait "$syncthing_pid"
            exit 0
        fi
    fi

    sleep "$STATUS_POLL_SECONDS"
done
