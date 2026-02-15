# ==========================================
# keybindings
# ==========================================
# emacs-style bindings with custom word movement.

bindkey -e

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word
bindkey '^[[3~' delete-char

# fzf history search
bindkey '^R' fzf-history-widget

