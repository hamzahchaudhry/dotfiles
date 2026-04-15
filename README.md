# dotfiles

my dotfiles for my arch linux + hyprland setup.

## layout

```text
.
├── applications/   # desktop entries
├── bat/            # bat config
├── bin/
│   ├── launch/     # app launch wrappers
│   └── systemd/    # scripts used by user services/timers
├── firefox/        # firefox user.js and chrome tweaks
├── foot/           # foot config
├── fuzzel/         # fuzzel config
├── git/            # git config
├── gtk-3.0/        # gtk settings
├── hypr/           # hyprland, hyprlock, hypridle
├── mako/           # notification daemon config
├── npm/            # npm config
├── nvim/           # neovim config
├── pacman/         # pacman hooks
├── paru/           # paru config
├── snapper/        # root-owned snapper configs
├── sysctl.d/       # root-owned sysctl overrides
├── systemd/        # user units/timers
├── task/           # taskwarrior config
├── udev/           # udev rules
├── waybar/         # waybar config + scripts
├── zed/            # zed settings/themes
├── zsh/            # zsh config
└── xdg.sh          # global xdg bootstrap
```

## assumptions

- the repo lives at `~/.dotfiles`
- `~/.local/bin` symlinks to `~/.dotfiles/bin`
- zsh loads from `~/.config/zsh` via `/etc/zsh/zshenv`
- xdg base dirs are set globally through `xdg.sh`

## install

clone it:

```sh
git clone git@github.com:hamzahchaudhry/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## symlinks

config dirs:

```sh
ln -s ~/.dotfiles/bat ~/.config/bat
ln -s ~/.dotfiles/foot ~/.config/foot
ln -s ~/.dotfiles/fuzzel ~/.config/fuzzel
ln -s ~/.dotfiles/git ~/.config/git
ln -s ~/.dotfiles/gtk-3.0 ~/.config/gtk-3.0
ln -s ~/.dotfiles/hypr ~/.config/hypr
ln -s ~/.dotfiles/mako ~/.config/mako
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/npm ~/.config/npm
ln -s ~/.dotfiles/task ~/.config/task
ln -s ~/.dotfiles/waybar ~/.config/waybar
ln -s ~/.dotfiles/zed ~/.config/zed
ln -s ~/.dotfiles/systemd/user ~/.config/systemd/user
```

user bin:

```sh
ln -s ~/.dotfiles/bin ~/.local/bin
```

zsh:

```sh
ln -s ~/.dotfiles/zsh ~/.config/zsh
doas install -Dm644 ~/.dotfiles/zsh/zshenv /etc/zsh/zshenv
```

`zsh/zshenv` is only the bootstrap. it sets `ZDOTDIR="$HOME/.config/zsh"` so the rest of the zsh config loads from the linked `zsh/` directory.

reload user units after linking:

```sh
systemctl --user daemon-reload
```

## xdg

`xdg.sh` is meant to be sourced globally so gui apps, shells, and user services all agree on the same xdg paths.

install it as a profile script:

```sh
doas install -Dm644 ~/.dotfiles/xdg.sh /etc/profile.d/xdg.sh
```

## firefox

firefox still needs manual profile wiring.

copy `user.js` and `chrome/` into the active profile:

```sh
cp ~/.dotfiles/firefox/user.js ~/.config/mozilla/firefox/<profile>/user.js
cp -r ~/.dotfiles/firefox/chrome ~/.config/mozilla/firefox/<profile>/chrome
```

## desktop entries

desktop entries live in `applications/`.

app launchers use wrappers from:

```text
~/.local/bin/launch
```

that path is added in `zsh/.zshenv`.

some vendor apps are wrapped with a fake app-specific `HOME` so they stop spilling state across the real xdg dirs. that mostly applies to quartus, modelsim, stm32cubemx, and orion jr.

## systemd jobs

user units live in `systemd/user/`.

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

bat uses its own config in `bat/config`.

man pages still use a custom `MANPAGER` from `zsh/zshrc.d/10-env.zsh`:

- `sed` strips the weird manpage artifacts
- `bat` handles rendering
- `less -R -i --incsearch` gives paging and vim-like search

## paru

paru uses `~/.config/paru/paru.conf`.

## neovim

neovim config lives in `nvim/`.

the setup is lua-based and starts from `init.lua`.

## udev

udev rules live in `udev/rules.d/` in the repo, but should be installed into `/etc/udev/rules.d` instead of symlinked from home.

current rules:

- `99-intel-rapl.rules`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/udev/rules.d/99-intel-rapl.rules /etc/udev/rules.d/99-intel-rapl.rules
doas udevadm control --reload
doas udevadm trigger
```

## sysctl

`sysctl.d/` files in the repo should be installed into `/etc/sysctl.d/` instead of symlinked from home.

current overrides:

- `50-disable-coredumps.conf`
- `90-network-hardening.conf`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/sysctl.d/50-disable-coredumps.conf /etc/sysctl.d/50-disable-coredumps.conf
doas install -Dm644 ~/.dotfiles/sysctl.d/90-network-hardening.conf /etc/sysctl.d/90-network-hardening.conf
doas sysctl --system
```

## snapper

snapper configs live in `snapper/configs/` in the repo, but should be installed into `/etc/snapper/configs/` instead of symlinked from home.

current configs:

- `root`

install or update them with:

```sh
doas install -Dm640 ~/.dotfiles/snapper/configs/root /etc/snapper/configs/root
```

## pacman hooks

pacman hooks live in `pacman/hooks/` in the repo, but should be installed into
`/etc/pacman.d/hooks/`.

current hooks:

- `log-orphans.hook`

install or update them with:

```sh
doas install -Dm644 ~/.dotfiles/pacman/hooks/log-orphans.hook /etc/pacman.d/hooks/log-orphans.hook
```

`log-orphans.hook` checks for orphaned packages after installs, upgrades, and
removals using `pacman -Qdtt`.

## networkmanager dispatcher

`wireguard-toggle.sh` is a NetworkManager dispatcher script that toggles the `wg0` connection based on the active wifi ssid.

it expects:

- home ssid set in the script
- a WireGuard logo at `~/.local/share/icons/wireguard.png`
- mako categories `on` and `off` for notification styling

install it as a root-owned dispatcher script:

```sh
doas install -m 755 -o root -g root ~/.dotfiles/wireguard-toggle.sh /etc/NetworkManager/dispatcher.d/wireguard-toggle.sh
```
