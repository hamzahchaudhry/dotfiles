# ================================
# ls / eza
# ================================

alias ls='eza --color=always --group-directories-first --icons'
alias l='eza -l --icons --octal-permissions --group-directories-first'
alias ll='eza -la --icons --octal-permissions --group-directories-first --git'
alias la='eza --all --color=always --group-directories-first --icons'
alias lt='eza --all --tree --level=2 --color=always --group-directories-first --icons'
alias ltt='eza --all --tree --color=always --group-directories-first --icons'


# ================================
# git
# ================================

alias gcl='git clone'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gu='git restore --staged'
alias gd='git diff'


# ================================
# quality of life
# ================================

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias c='clear'


# ================================
# pacman
# ================================

alias remove='sudo pacman -Rnsc $(pacman -Qtdq)'

