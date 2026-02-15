# ==========================================
# completion system
# ==========================================
# enables advanced completion with caching.
# optimized for fzf-tab integration.
# cached in XDG_CACHE_HOME.

autoload -Uz compinit

mkdir -p "$XDG_CACHE_HOME/zsh"

# cache expensive completion results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

# disable native zsh menu so fzf-tab controls UI
zstyle ':completion:*' menu no

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
  fzf-preview 'eza -1 --color=always --icons $realpath'

# initialize completion
compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump"

