# ==========================================
# XDG base directories
# ==========================================
# sets XDG paths globally for the user session.
# loaded via /etc/profile.d/ so GUI apps,
# Hyprland, systemd user services, and shells
# share the same directory layout.

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
