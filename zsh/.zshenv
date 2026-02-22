# ==========================================
# zsh environment
# ==========================================
# user-specific environment variables.
# runs for all zsh invocations.
# XDG base dirs are defined globally via xdg.sh.

export PATH="$HOME/.local/bin:$PATH"


# ==========================================
# XDG overrides
# ==========================================

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"


# ==========================================
# editor / pager
# ==========================================

export EDITOR="nvim"
export MANPAGER="bat -plman"

