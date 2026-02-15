# ==========================================
# history configuration
# ==========================================
# large history size and shared history across shells.
# stored in XDG_STATE_HOME.

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_STATE_HOME/zsh/history"

setopt APPEND_HISTORY     # append instead of overwrite
setopt INC_APPEND_HISTORY # write immediately
setopt SHARE_HISTORY      # merge history between shells
setopt HIST_IGNORE_DUPS   # ignore consecutive duplicates
setopt HIST_REDUCE_BLANKS # remove superfluous whitespace

