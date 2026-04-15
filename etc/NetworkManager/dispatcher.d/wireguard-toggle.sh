#!/bin/sh

[ "$2" = "up" ] || exit 0

HOME_SSID="Shaw wifi"
WG_CONN="wg0"
USER_NAME="hamzah"
USER_ID="$(id -u "$USER_NAME")"
SSID="$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2; exit}')"
ICON="/home/$USER_NAME/.local/share/icons/wireguard.png"

notify() {
  category="$1"
  title="$2"
  body="$3"

  runuser -u "$USER_NAME" -- env \
    XDG_RUNTIME_DIR="/run/user/$USER_ID" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" \
    HOME="/home/$USER_NAME" \
    notify-send -t 2500 -c "$category" -a "WireGuard" -i "$ICON" "$title" "$body"
}

wg_is_up() {
  nmcli -t -f NAME connection show --active | grep -Fxq "$WG_CONN"
}

if [ "$SSID" = "$HOME_SSID" ]; then
  wg_is_up || exit 0
  nmcli connection down "$WG_CONN"
  notify off "WireGuard" "Disabled"
else
  wg_is_up && exit 0
  nmcli connection up "$WG_CONN"
  notify on "WireGuard" "Enabled"
fi
