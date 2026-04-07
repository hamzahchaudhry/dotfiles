#!/bin/sh

[ "$2" = "up" ] || exit 0

HOME_SSID="Shaw wifi"
USER_NAME="hamzah"
USER_ID="$(id -u "$USER_NAME")"
SSID="$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2; exit}')"

notify() {
  runuser -u "$USER_NAME" -- env \
    XDG_RUNTIME_DIR="/run/user/$USER_ID" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" \
    notify-send -i "$1" "Tailscale" "$2"
}

if [ "$SSID" = "$HOME_SSID" ]; then
  tailscale status | grep -q 'Tailscale is stopped' && exit 0
  tailscale down
  notify changes-allow "down on $SSID"
else
  tailscale status | grep -q 'Tailscale is stopped' || exit 0
  tailscale up
  notify changes-prevent "up on ${SSID:-unknown network}"
fi
