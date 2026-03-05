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
alias gp='git push'
alias gu='git restore --staged'
alias gd='git diff'
alias gl='git log'


# ================================
# quality of life
# ================================

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias cdot='codium .'
bt () {
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
      b=$(rfkill list bluetooth | awk -F": " '/Soft blocked/ {print $2}'); s=$(systemctl is-active bluetooth 2>/dev/null); [[ "$b" == yes ]] && echo "BT: OFF (rfkill blocked)" || [[ "$s" != active ]] && echo "BT: OFF (service $s)" || echo "BT: ON ($(timeout 1 bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print "Powered: "$2}'))"
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
alias t391='task add proj:"CPEN391 🤖"'
alias t340='task add proj:"CPSC340 🧠"'
alias t320='task add proj:"CPSC320 🧮"'
alias t320p='task add proj:"CPEN320 🌐"'
alias tl='task add proj:"life 🏠"'


# ================================
# pacman
# ================================

alias remove='sudo pacman -Rnsc $(pacman -Qtdq)'

