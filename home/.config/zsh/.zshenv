# ==========================================
# zsh environment
# ==========================================
# user-specific environment variables.
# runs for all zsh invocations.
# XDG base dirs are defined globally via xdg.sh.

export PATH="$HOME/.local/bin:$HOME/.local/bin/launch:$PATH"


# ==========================================
# XDG overrides
# ==========================================

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"


# ==========================================
# app-specific paths
# ==========================================

export FIREFOX_PROFILE="$XDG_CONFIG_HOME/mozilla/firefox/i4hwomfd.default-release"


# ==========================================
# editor
# ==========================================

export EDITOR="nvim"
