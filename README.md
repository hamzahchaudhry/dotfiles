# dotfiles

my dotfiles for my arch linux + hyprland setup.

## layout

```text
.
├── home/           # files mirrored into $HOME
├── etc/            # root-owned system config
├── README.md
└── .gitignore
```

## assumptions

- the repo lives at `~/.dotfiles`
- `home/` mirrors `$HOME`
- root-owned system files are mirrored under `etc/`
- zsh loads from `~/.config/zsh` via `/etc/zsh/zshenv`

## install

clone it:

```sh
git clone git@github.com:hamzahchaudhry/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` applies the mirrored `home/` and `etc/` trees:

- symlinks the user-owned paths from `home/` into `$HOME`
- installs the root-owned paths from `etc/` into `/etc`
- optionally wires firefox `user.js` and `chrome/` if `FIREFOX_PROFILE` is set

useful flags:

```sh
./install.sh --dry-run
./install.sh --home-only
./install.sh --etc-only
FIREFOX_PROFILE=~/.mozilla/firefox/<profile-dir> ./install.sh
```

`etc/zsh/zshenv` is only the bootstrap. it sets `ZDOTDIR="$HOME/.config/zsh"` so the rest of the zsh config loads from the linked `home/.config/zsh/` directory.

reload user units after linking:

```sh
systemctl --user daemon-reload
```

## xdg

`etc/profile.d/xdg.sh` is meant to be sourced globally so gui apps, shells, and user services all agree on the same xdg paths.

install it as a profile script:

```sh
doas install -Dm644 ~/.dotfiles/etc/profile.d/xdg.sh /etc/profile.d/xdg.sh
```

## firefox

`home/.config/mozilla/firefox/profile/` in the repo is a profile template, not a literal profile name.

set `FIREFOX_PROFILE` if you want `install.sh` to symlink `user.js` and `chrome/` into the live firefox profile:

```sh
FIREFOX_PROFILE=~/.mozilla/firefox/<profile-dir> ./install.sh --home-only
```

## desktop entries

desktop entries live in `home/.local/share/applications/`.

app launchers use wrappers from:

```text
~/.local/bin/launch
```

some vendor apps are wrapped with a fake app-specific `HOME` so they stop spilling state across the real xdg dirs. that mostly applies to quartus, modelsim, stm32cubemx, and orion jr.

## systemd jobs

user units live in `home/.config/systemd/user/`.

their scripts live in:

```text
~/.local/bin/systemd
```

current jobs:

- battery threshold actions
- syncthing on-demand
- task due notifications

enable timers/services as needed:

```sh
systemctl --user enable --now battery-threshold.timer
systemctl --user enable --now syncthing.timer
systemctl --user enable --now task-notify-due.timer
```

## bat

bat uses its own config in `home/.config/bat/config`.

man pages still use a custom `MANPAGER` from `home/.config/zsh/zshrc.d/10-env.zsh`:

- `sed` strips the weird manpage artifacts
- `bat` handles rendering
- `less -R -i --incsearch` gives paging and vim-like search

## paru

paru uses `~/.config/paru/paru.conf`.

## neovim

neovim config lives in `home/.config/nvim/`.

the setup is lua-based and starts from `init.lua`.

## udev

udev rules live in `etc/udev/rules.d/` in the repo and should be installed into `/etc/udev/rules.d`.

current rules:

- `99-intel-rapl.rules`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/etc/udev/rules.d/99-intel-rapl.rules /etc/udev/rules.d/99-intel-rapl.rules
doas udevadm control --reload
doas udevadm trigger
```

## sysctl

`etc/sysctl.d/` files in the repo should be installed into `/etc/sysctl.d/`.

current overrides:

- `50-disable-coredumps.conf`
- `90-network-hardening.conf`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/etc/sysctl.d/50-disable-coredumps.conf /etc/sysctl.d/50-disable-coredumps.conf
doas install -Dm644 ~/.dotfiles/etc/sysctl.d/90-network-hardening.conf /etc/sysctl.d/90-network-hardening.conf
doas sysctl --system
```

## snapper

snapper configs live in `etc/snapper/configs/` in the repo and should be installed into `/etc/snapper/configs/`.

current configs:

- `root`

install or update them with:

```sh
doas install -Dm640 ~/.dotfiles/etc/snapper/configs/root /etc/snapper/configs/root
```

## boot

boot-related config is mirrored under `etc/` and should be installed into the matching `/etc` paths.

current files:

- `kernel/cmdline`
- `mkinitcpio.conf`
- `mkinitcpio.d/linux.preset`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/etc/kernel/cmdline /etc/kernel/cmdline
doas install -Dm644 ~/.dotfiles/etc/mkinitcpio.conf /etc/mkinitcpio.conf
doas install -Dm644 ~/.dotfiles/etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux.preset
```

## modprobe

module policy lives in `etc/modprobe.d/` in the repo and should be installed into `/etc/modprobe.d/`.

current files:

- `blacklist-watchdog.conf`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/etc/modprobe.d/blacklist-watchdog.conf /etc/modprobe.d/blacklist-watchdog.conf
```

## pacman hooks

pacman hooks live in `etc/pacman.d/hooks/` in the repo and should be installed into `/etc/pacman.d/hooks/`.

current hooks:

- `log-orphans.hook`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/etc/pacman.d/hooks/log-orphans.hook /etc/pacman.d/hooks/log-orphans.hook
```

`log-orphans.hook` checks for orphaned packages after installs, upgrades, and
removals using `pacman -Qdtt`.

## networkmanager dispatcher

`etc/NetworkManager/dispatcher.d/wireguard-toggle.sh` toggles the `wg0` connection based on the active wifi ssid.

it expects:

- home ssid set in the script
- a WireGuard logo at `~/.local/share/icons/wireguard.png`
- mako categories `on` and `off` for notification styling

install it as a root-owned dispatcher script:

```sh
doas install -m 755 -o root -g root ~/.dotfiles/etc/NetworkManager/dispatcher.d/wireguard-toggle.sh /etc/NetworkManager/dispatcher.d/wireguard-toggle.sh
```
