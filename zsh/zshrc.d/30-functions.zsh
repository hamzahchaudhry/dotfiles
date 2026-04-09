# ================================
# shell functions
# ================================

zshrecompile() {
  local zsh_dir="$ZDOTDIR"
  local f

  for f in "$zsh_dir"/.zshenv "$zsh_dir"/.zshrc "$zsh_dir"/.p10k.zsh "$zsh_dir"/zshrc.d/*.zsh(N); do
    [[ -r "$f" ]] && zcompile -U "$f"
  done
}


# ================================
# help
# ================================

bathelp() {
  bat --plain --language=help --paging=always
}

help() {
  "$@" --help 2>&1 | bathelp
}


# ================================
# bluetooth
# ================================

bt() {
  local blocked service powered

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
      blocked=$(rfkill list bluetooth | awk -F": " '/Soft blocked/ {print $2}')
      service=$(systemctl is-active bluetooth 2>/dev/null)
      powered=$(timeout 1 bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2}')

      if [[ "$blocked" == yes ]]; then
        echo "BT: OFF (rfkill blocked)"
      elif [[ "$service" != active ]]; then
        echo "BT: OFF (service $service)"
      else
        echo "BT: ON (Powered: ${powered:-unknown})"
      fi
      ;;
    *)
      echo "Usage: bt {on|off|airpods|status}"
      ;;
  esac
}


# ================================
# pacman
# ================================

pacclean() {
  local removable
  local download_dirs
  removable="$(pacman -Qqd 2>/dev/null | pacman -Rsu --print-format '%n' --print - 2>/dev/null | sed '/^[[:space:]]*there is nothing to do$/d')"
  download_dirs=(/var/cache/pacman/pkg/download-*(N))

  if [[ -n "$removable" ]]; then
    sudo pacman -Rns ${(f)removable}
  else
    echo "No removable dependency packages found."
  fi

  sudo paccache -rk0
  sudo paccache -ruk0
  (( ${#download_dirs[@]} )) && sudo rm -rf "${download_dirs[@]}"
  yes | paru -Scc
}


# ================================
# speedtest
# ================================

function s() {
  trap 'tput cnorm; stty sane' EXIT INT
  speedtest-go
}
