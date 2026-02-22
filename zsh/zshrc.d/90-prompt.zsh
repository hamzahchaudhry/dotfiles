# ==========================================
# prompt configuration
# ==========================================
# powerlevel10k theme and user config.
# loaded last so prompt sees final shell state.

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# load personal p10k config if present
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh

# make cursor blinking bar
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

