# ==========================================
# plugins and external integrations
# ==========================================
# loaded after core shell behavior is configured.

: "${XDG_CACHE_HOME:=$HOME/.cache}"
zsh_cache_dir="$XDG_CACHE_HOME/zsh"
[[ -d "$zsh_cache_dir" ]] || mkdir -p "$zsh_cache_dir"

# fzf shell integration
if (( $+commands[fzf] )); then
  for fzf_completion in \
    /usr/share/fzf/completion.zsh \
    /usr/share/fzf/shell/completion.zsh \
    /usr/share/doc/fzf/examples/completion.zsh
  do
    if [[ -r "$fzf_completion" ]]; then
      source "$fzf_completion"
      break
    fi
  done

  for fzf_key_bindings in \
    /usr/share/fzf/key-bindings.zsh \
    /usr/share/fzf/shell/key-bindings.zsh \
    /usr/share/doc/fzf/examples/key-bindings.zsh
  do
    if [[ -r "$fzf_key_bindings" ]]; then
      source "$fzf_key_bindings"
      break
    fi
  done
fi

# initialize zoxide
if (( $+commands[zoxide] )); then
  zoxide_init_cache="$zsh_cache_dir/zoxide-init.zsh"

  if [[ ! -s "$zoxide_init_cache" || "$(command -v zoxide)" -nt "$zoxide_init_cache" ]]; then
    zoxide init --cmd cd zsh >| "$zoxide_init_cache"
  fi

  source "$zoxide_init_cache"
fi

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]] && source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # load last
