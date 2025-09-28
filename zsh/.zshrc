# main zsh settings. env in ~/.zprofile
# read second

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source global shell alias file
[ -f "$XDG_CONFIG_HOME/zsh/aliases" ] && source "$XDG_CONFIG_HOME/zsh/aliases"

# history
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
setopt APPEND_HISTORY           # append, don't overwrite
setopt INC_APPEND_HISTORY       # write each command as it's entered
setopt SHARE_HISTORY            # merge history across sessions
setopt HIST_IGNORE_DUPS         # ignore consecutive dupes in this session
setopt HIST_SAVE_NO_DUPS        # don't write dupes to $HISTFILE
setopt HIST_REDUCE_BLANKS       # trim extra spaces
setopt HIST_EXPIRE_DUPS_FIRST   # expire dupes before unique entries
setopt HIST_FIND_NO_DUPS        # skip dupes when searching history
setopt HIST_IGNORE_SPACE

# fzf setup
source <(fzf --zsh) # allow for fzf history widget

# keybindings
bindkey -e   # use emacs-style keybindings
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word
bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word
bindkey '^R' fzf-history-widget

# completion
zmodload zsh/complist
autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always --icon=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump"

# options
setopt auto_menu
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
[[ -t 0 ]] && stty stop undef 2>/dev/null # disable accidental ctrl s

# plugins
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'   # dim
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

eval "$(zoxide init --cmd cd zsh)"

# prompt theme
source "$XDG_CONFIG_HOME/zsh/.powerlevel10k/powerlevel10k.zsh-theme"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh
