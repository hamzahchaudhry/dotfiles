# ================================
# XDG base directories
# ================================

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


# ================================
# XDG compliance overrides
# ================================

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"


# ================================
# editor / pager
# ================================

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="bat -plman"

