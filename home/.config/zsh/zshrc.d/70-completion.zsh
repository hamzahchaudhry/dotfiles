# ==========================================
# completion system
# ==========================================
# enables advanced completion with caching.
# optimized for fzf-tab integration.
# cached in XDG_CACHE_HOME.

autoload -Uz compinit

: "${XDG_CACHE_HOME:=$HOME/.cache}"
zsh_cache_dir="$XDG_CACHE_HOME/zsh"
zcompdump="$zsh_cache_dir/zcompdump"

[[ -d "$zsh_cache_dir" ]] || mkdir -p "$zsh_cache_dir"

# cache expensive completion results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

# disable native zsh menu so fzf-tab controls UI
zstyle ':completion:*' menu no
zstyle ':completion:*' menu select
zstyle ':fzf-tab:*' fzf-flags --height=40%

# show group descriptions (used by fzf-tab)
zstyle ':completion:*:descriptions' format '[%d]'

# enable standard completion plus flexible matching
# case-insensitive + separator-aware matching
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'

# preview directory contents with eza when completing `cd`
zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'eza -1 --color=always $realpath'

# reuse the cached dump most of the time and refresh it periodically
if [[ ! -f "$zcompdump" || -n "$zcompdump"(N.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi

compdef _sudo doas
