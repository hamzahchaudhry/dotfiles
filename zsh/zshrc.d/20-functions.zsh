# ================================
# shell functions
# ================================

zshrecompile() {
local zsh_dir="$ZDOTDIR"
  local f

  for f in "$zsh_dir"/.zshrc "$zsh_dir"/.p10k.zsh "$zsh_dir"/zshrc.d/*.zsh(N); do
    zcompile "$f"
  done
}

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

remove() {
  local orphans
  orphans=(${(f)"$(pacman -Qtdq 2>/dev/null)"})

  if (( ${#orphans[@]} == 0 )); then
    echo "No orphaned packages found."
    return 0
  fi

  sudo pacman -Rnsc "${orphans[@]}"
}
