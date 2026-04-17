#!/bin/sh

set -eu

DOTFILES_DIR="$(pwd)"
FIREFOX_PROFILE="$XDG_CONFIG_HOME/mozilla/firefox/i4hwomfd.default-release"

printf 'installing...\n'

printf '\n'
printf 'home:\n'

printf 'symlinking home/.config/bat -> ~/.config/bat...\n'
ln -sfn "$DOTFILES_DIR/home/.config/bat" "$HOME/.config/bat"
printf 'symlinking home/.config/foot -> ~/.config/foot...\n'
ln -sfn "$DOTFILES_DIR/home/.config/foot" "$HOME/.config/foot"
printf 'symlinking home/.config/fuzzel -> ~/.config/fuzzel...\n'
ln -sfn "$DOTFILES_DIR/home/.config/fuzzel" "$HOME/.config/fuzzel"
printf 'symlinking home/.config/git -> ~/.config/git...\n'
ln -sfn "$DOTFILES_DIR/home/.config/git" "$HOME/.config/git"
printf 'symlinking home/.config/gtk-3.0 -> ~/.config/gtk-3.0...\n'
ln -sfn "$DOTFILES_DIR/home/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
printf 'symlinking home/.config/hypr -> ~/.config/hypr...\n'
ln -sfn "$DOTFILES_DIR/home/.config/hypr" "$HOME/.config/hypr"
printf 'symlinking home/.config/mako -> ~/.config/mako...\n'
ln -sfn "$DOTFILES_DIR/home/.config/mako" "$HOME/.config/mako"
printf 'symlinking home/.config/npm -> ~/.config/npm...\n'
ln -sfn "$DOTFILES_DIR/home/.config/npm" "$HOME/.config/npm"
printf 'symlinking home/.config/nvim -> ~/.config/nvim...\n'
ln -sfn "$DOTFILES_DIR/home/.config/nvim" "$HOME/.config/nvim"
printf 'symlinking home/.config/paru -> ~/.config/paru...\n'
ln -sfn "$DOTFILES_DIR/home/.config/paru" "$HOME/.config/paru"
printf 'symlinking home/.config/systemd/user -> ~/.config/systemd/user...\n'
ln -sfn "$DOTFILES_DIR/home/.config/systemd/user" "$HOME/.config/systemd/user"
printf 'symlinking home/.config/task -> ~/.config/task...\n'
ln -sfn "$DOTFILES_DIR/home/.config/task" "$HOME/.config/task"
printf 'symlinking home/.config/waybar -> ~/.config/waybar...\n'
ln -sfn "$DOTFILES_DIR/home/.config/waybar" "$HOME/.config/waybar"
printf 'symlinking home/.config/zed -> ~/.config/zed...\n'
ln -sfn "$DOTFILES_DIR/home/.config/zed" "$HOME/.config/zed"
printf 'symlinking home/.config/zsh -> ~/.config/zsh...\n'
ln -sfn "$DOTFILES_DIR/home/.config/zsh" "$HOME/.config/zsh"
printf 'symlinking home/.local/bin -> ~/.local/bin...\n'
ln -sfn "$DOTFILES_DIR/home/.local/bin" "$HOME/.local/bin"
printf 'symlinking home/.local/share/applications -> ~/.local/share/applications...\n'
ln -sfn "$DOTFILES_DIR/home/.local/share/applications" "$HOME/.local/share/applications"

printf 'symlinking home/.config/mozilla/firefox/profile/user.js -> %s/user.js...\n' "$FIREFOX_PROFILE"
ln -sfn "$DOTFILES_DIR/home/.config/mozilla/firefox/profile/user.js" "$FIREFOX_PROFILE/user.js"
printf 'symlinking home/.config/mozilla/firefox/profile/chrome -> %s/chrome...\n' "$FIREFOX_PROFILE"
ln -sfn "$DOTFILES_DIR/home/.config/mozilla/firefox/profile/chrome" "$FIREFOX_PROFILE/chrome"

printf '\n'
printf 'etc:\n'

printf 'installing etc/NetworkManager/conf.d/50-dns.conf -> /etc/NetworkManager/conf.d/50-dns.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/NetworkManager/conf.d/50-dns.conf" /etc/NetworkManager/conf.d/50-dns.conf
printf 'installing etc/NetworkManager/conf.d/60-mac-randomization.conf -> /etc/NetworkManager/conf.d/60-mac-randomization.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/NetworkManager/conf.d/60-mac-randomization.conf" /etc/NetworkManager/conf.d/60-mac-randomization.conf
printf 'installing etc/NetworkManager/dispatcher.d/wireguard-toggle.sh -> /etc/NetworkManager/dispatcher.d/wireguard-toggle.sh (755)...\n'
doas install -Dm755 "$DOTFILES_DIR/etc/NetworkManager/dispatcher.d/wireguard-toggle.sh" /etc/NetworkManager/dispatcher.d/wireguard-toggle.sh
printf 'installing etc/kernel/cmdline -> /etc/kernel/cmdline (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/kernel/cmdline" /etc/kernel/cmdline
printf 'installing etc/mkinitcpio.conf -> /etc/mkinitcpio.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/mkinitcpio.conf" /etc/mkinitcpio.conf
printf 'installing etc/mkinitcpio.d/linux.preset -> /etc/mkinitcpio.d/linux.preset (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/mkinitcpio.d/linux.preset" /etc/mkinitcpio.d/linux.preset
printf 'installing etc/modprobe.d/blacklist-watchdog.conf -> /etc/modprobe.d/blacklist-watchdog.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/modprobe.d/blacklist-watchdog.conf" /etc/modprobe.d/blacklist-watchdog.conf
printf 'installing etc/modprobe.d/iwlwifi.conf -> /etc/modprobe.d/iwlwifi.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/modprobe.d/iwlwifi.conf" /etc/modprobe.d/iwlwifi.conf
printf 'installing etc/pacman.d/hooks/log-orphans.hook -> /etc/pacman.d/hooks/log-orphans.hook (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/pacman.d/hooks/log-orphans.hook" /etc/pacman.d/hooks/log-orphans.hook
printf 'installing etc/profile.d/xdg.sh -> /etc/profile.d/xdg.sh (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/profile.d/xdg.sh" /etc/profile.d/xdg.sh
printf 'installing etc/snapper/configs/root -> /etc/snapper/configs/root (640)...\n'
doas install -Dm640 "$DOTFILES_DIR/etc/snapper/configs/root" /etc/snapper/configs/root
printf 'installing etc/sysctl.d/50-disable-coredumps.conf -> /etc/sysctl.d/50-disable-coredumps.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/sysctl.d/50-disable-coredumps.conf" /etc/sysctl.d/50-disable-coredumps.conf
printf 'installing etc/sysctl.d/90-network-hardening.conf -> /etc/sysctl.d/90-network-hardening.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/sysctl.d/90-network-hardening.conf" /etc/sysctl.d/90-network-hardening.conf
printf 'installing etc/sysctl.d/99-vm-zram-parameters.conf -> /etc/sysctl.d/99-vm-zram-parameters.conf (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/sysctl.d/99-vm-zram-parameters.conf" /etc/sysctl.d/99-vm-zram-parameters.conf
printf 'installing etc/udev/rules.d/99-intel-rapl.rules -> /etc/udev/rules.d/99-intel-rapl.rules (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/udev/rules.d/99-intel-rapl.rules" /etc/udev/rules.d/99-intel-rapl.rules
printf 'installing etc/zsh/zshenv -> /etc/zsh/zshenv (644)...\n'
doas install -Dm644 "$DOTFILES_DIR/etc/zsh/zshenv" /etc/zsh/zshenv

printf '\n'
printf 'running systemctl --user daemon-reload...\n'
systemctl --user daemon-reload

printf '\n'
printf 'done.\n'
