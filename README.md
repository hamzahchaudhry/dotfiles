# dotfiles

my dotfiles for my arch linux + hyprland setup.

## layout

```text
.
├── applications/   # desktop entries
├── bin/
│   ├── launch/     # app launch wrappers
│   └── systemd/    # scripts used by user services/timers
├── firefox/        # firefox user.js and chrome tweaks
├── foot/           # foot config
├── fuzzel/         # fuzzel config
├── git/            # git config
├── hypr/           # hyprland, hyprlock, hypridle
├── mako/           # notification daemon config
├── npm/            # npm config
├── systemd/        # user units/timers
├── task/           # taskwarrior config
├── vim/            # vim config
├── waybar/         # waybar config + scripts
├── zed/            # zed settings/themes
├── zsh/            # zsh config
└── xdg.sh          # global xdg bootstrap
```

## assumptions

- the repo lives at `~/.dotfiles`
- `~/.local/bin` symlinks to `~/.dotfiles/bin`
- zsh loads from `~/.config/zsh`
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
ln -s ~/.dotfiles/foot ~/.config/foot
ln -s ~/.dotfiles/fuzzel ~/.config/fuzzel
ln -s ~/.dotfiles/git ~/.config/git
ln -s ~/.dotfiles/hypr ~/.config/hypr
ln -s ~/.dotfiles/mako ~/.config/mako
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
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
```

reload user units after linking:

```sh
systemctl --user daemon-reload
```

## xdg

`xdg.sh` is meant to be sourced globally so gui apps, shells, and user services all agree on the same xdg paths.

example:

```sh
sudo ln -s ~/.dotfiles/xdg.sh /etc/profile.d/xdg.sh
```

## firefox

firefox still needs manual profile wiring.

copy `user.js` into the active profile:

```sh
cp ~/.dotfiles/firefox/user.js ~/.config/mozilla/firefox/<profile>/user.js
```

## desktop entries

desktop entries live in `applications/`.

the app launchers use wrappers from:

```text
~/.local/bin/launch
```

that path is added in `zsh/.zshenv`.

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
