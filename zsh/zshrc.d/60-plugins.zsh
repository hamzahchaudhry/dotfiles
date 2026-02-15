# ==========================================
# plugins and external integrations
# ==========================================
# loaded after core shell behavior is configured.

# fzf shell integration
command -v fzf >/dev/null && source <(fzf --zsh)

# initialize zoxide
eval "$(zoxide init --cmd cd zsh)"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # load last

