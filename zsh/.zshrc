# ==========================================
# zsh main config loader
# ==========================================
# minimal file.
# loads instant prompt early then sources
# all config snippets from zshrc.d/


# ==========================================
# powerlevel10k instant prompt
# ==========================================
# keep this first.
# speeds up perceived startup time.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ==========================================
# load modular configuration
# ==========================================
# loads all .zsh files in zshrc.d/ in sorted order.
# file names control load order (00-, 10-, 20-, etc).

zshrcd="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshrc.d"

if [[ -d "$zshrcd" ]]; then
  for f in "$zshrcd"/*.zsh(N); do
    [[ -r "$f" ]] && source "$f"
  done
fi

