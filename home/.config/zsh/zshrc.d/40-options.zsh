# ==========================================
# shell options
# ==========================================
# core interactive shell behavior.

setopt autocd           # enter directory by typing its name
setopt auto_param_slash # add trailing slash when completing dirs
setopt interactive_comments

unsetopt prompt_sp      # don't auto-remove blank lines before prompt
setopt complete_aliases
