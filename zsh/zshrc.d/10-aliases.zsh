# ================================
# ls / eza
# ================================

EZA_IGNORE=".git|node_modules|target|dist|build|__pycache__|.venv|coverage"

alias ls='eza --group-directories-first'
alias la='eza -a --group-directories-first'
alias l='eza -lab --smart-group --time-style=relative --color-scale=size,age --group-directories-first'
alias ll='eza -lab --smart-group --time-style=relative --color-scale=size,age --group-directories-first --total-size --git'
alias lt="eza -aTL2 --git-ignore --group-directories-first -I \"$EZA_IGNORE\""
alias ltt="eza -aTL3 --git-ignore --group-directories-first -I \"$EZA_IGNORE\""
alias lttt="eza -aTL4 --git-ignore --group-directories-first -I \"$EZA_IGNORE\""
alias tree="eza -aT --git-ignore -I \"$EZA_IGNORE\""
alias lsize='eza -labr --sort=size --color-scale=size --group-directories-first --total-size'


# ================================
# git
# ================================

alias gcl='git clone'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gu='git restore --staged'
alias gd='git diff'
alias gl='git log'


# ================================
# quality of life
# ================================

alias sudo='sudo '
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias cdot='codium .'
alias s='speedtest'
bt() {
  case "$1" in
    on)
      sudo rfkill unblock bluetooth
      sudo systemctl start bluetooth
      bluetoothctl power on
      ;;
    off)
      bluetoothctl power off
      sudo systemctl stop bluetooth
      sudo rfkill block bluetooth
      ;;
    airpods)
      sudo rfkill unblock bluetooth
      sudo systemctl start bluetooth
      bluetoothctl power on
      bluetoothctl connect 38:C4:3A:E2:E2:D8
      ;;
    status)
      b=$(rfkill list bluetooth | awk -F": " '/Soft blocked/ {print $2}')
      s=$(systemctl is-active bluetooth 2>/dev/null)
      [[ "$b" == yes ]] && echo "BT: OFF (rfkill blocked)" || [[ "$s" != active ]] && echo "BT: OFF (service $s)" || echo "BT: ON ($(timeout 1 bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print "Powered: "$2}'))"
      ;;
    *)
      echo "Usage: bt {on|off|airpods|status}"
      ;;
  esac
}


# ================================
# taskwarrior
# ================================

alias t='task add'
alias tm='task modify'
alias td='task done'
alias t391='task add proj:"CPEN391 🤖"'
alias t340='task add proj:"CPSC340 🧠"'
alias t320='task add proj:"CPSC320 🧮"'
alias t320p='task add proj:"CPEN320 🌐"'
alias tl='task add proj:"life 🏠"'


# ================================
# pacman
# ================================

alias remove='sudo pacman -Rnsc $(pacman -Qtdq)'

