# ==========================================
# session startup
# ==========================================
# automatically start hyprland when:
# - on tty1
# - not already inside Wayland
# prevents accidental nested sessions.

if [[ -z "$WAYLAND_DISPLAY" && -n "$XDG_VTNR" && "$XDG_VTNR" -eq 1 ]]; then
  exec start-hyprland
fi

