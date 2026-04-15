#!/bin/sh

set -eu

HOME_ROOT="$(pwd)/home"
ETC_ROOT="$(pwd)/etc"
FIREFOX_PROFILE="${FIREFOX_PROFILE:-}"

DO_HOME=1
DO_ETC=1
DRY_RUN=0

HOME_LINKS='
.config/bat
.config/foot
.config/fuzzel
.config/git
.config/gtk-3.0
.config/hypr
.config/mako
.config/npm
.config/nvim
.config/paru
.config/systemd/user
.config/task
.config/waybar
.config/zed
.config/zsh
.local/bin
.local/share/applications
'

usage() {
  printf 'usage: ./install.sh [--home-only] [--etc-only] [--dry-run]\n'
  printf '  --home-only   only install the mirrored $HOME files\n'
  printf '  --etc-only    only install the mirrored /etc files\n'
  printf '  --dry-run     print actions without changing anything\n'
  printf '  FIREFOX_PROFILE=~/.mozilla/firefox/<profile-dir>  optional firefox profile path\n'
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    return 0
  else
    "$@"
  fi
}

symlink_path() {
  rel="$1"
  src="$2"
  dst="$3"

  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'would symlink %s\n' "$rel"
  else
    printf 'symlinking %s\n' "$rel"
  fi

  if [ -L "$dst" ]; then
    current=$(readlink -- "$dst")
    if [ "$current" = "$src" ]; then
      return 0
    fi
    run rm -f -- "$dst"
  elif [ -e "$dst" ]; then
    printf 'error: %s exists and is not a symlink\n' "$dst" >&2
    return 1
  fi

  run mkdir -p -- "$(dirname -- "$dst")"
  run ln -s -- "$src" "$dst"
  return 0
}

install_etc_file() {
  src="$1"
  rel=${src#"$ETC_ROOT"/}
  dst="/etc/$rel"
  mode=644

  case "$rel" in
    NetworkManager/dispatcher.d/*) mode=755 ;;
    snapper/configs/*) mode=640 ;;
  esac

  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'would install %s (%s)\n' "$dst" "$mode"
  else
    printf 'installing %s (%s)\n' "$dst" "$mode"
  fi

  if [ -f "$dst" ] && cmp -s -- "$src" "$dst"; then
    current_mode=$(stat -c '%a' -- "$dst")
    if [ "$current_mode" = "$mode" ]; then
      return 0
    fi
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    return 0
  fi
  doas install -Dm"$mode" -- "$src" "$dst"
  return 0
}

for arg in "$@"; do
  case "$arg" in
    --home-only)
      DO_ETC=0
      ;;
    --etc-only)
      DO_HOME=0
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
done

if [ "$DO_HOME" -eq 0 ] && [ "$DO_ETC" -eq 0 ]; then
  printf 'error: nothing to do\n' >&2
  exit 1
fi

if [ "$DO_HOME" -eq 1 ] && [ "$DO_ETC" -eq 1 ]; then
  MODE_LABEL='home + etc'
  printf 'installing home/ then etc/\n'
elif [ "$DO_HOME" -eq 1 ]; then
  MODE_LABEL='home'
  printf 'installing home/ only\n'
else
  MODE_LABEL='etc'
  printf 'installing etc/ only\n'
fi

if [ "$DO_HOME" -eq 1 ]; then
  printf '\n'
  printf 'home:\n'
  for rel in $HOME_LINKS; do
    symlink_path "$rel" "$HOME_ROOT/$rel" "$HOME/$rel"
  done

  if [ -n "$FIREFOX_PROFILE" ]; then
    symlink_path "$FIREFOX_PROFILE/user.js" "$HOME_ROOT/.config/mozilla/firefox/profile/user.js" "$FIREFOX_PROFILE/user.js"
    symlink_path "$FIREFOX_PROFILE/chrome" "$HOME_ROOT/.config/mozilla/firefox/profile/chrome" "$FIREFOX_PROFILE/chrome"
  else
    printf 'firefox: skipped, set FIREFOX_PROFILE to manage user.js and chrome\n'
  fi
fi

if [ "$DO_ETC" -eq 1 ]; then
  printf '\n'
  printf 'etc:\n'
  for file in $(find "$ETC_ROOT" -type f | sort); do
    install_etc_file "$file"
  done
fi

if [ "$DO_HOME" -eq 1 ]; then
  if [ "$DRY_RUN" -eq 0 ]; then
    printf '\n'
    printf 'running systemctl --user daemon-reload...\n'
    systemctl --user daemon-reload
  fi
fi

printf '\n'
if [ "$DRY_RUN" -eq 1 ]; then
  printf 'done: %s dry-run completed\n' "$MODE_LABEL"
else
  printf 'done: %s install completed\n' "$MODE_LABEL"
fi
