# dotfiles

Personal configuration for my Linux setup.

## Structure

```text
.
├── alacritty/        # alacritty config
├── firefox/          # firefox user.js
├── git/              # git config
├── hypr/             # hyprland ecosystem configs
├── systemd/          # user-level systemd units
├── tmux/             # tmux config
├── vim/              # vim config
├── VSCodium/         # VSCodium user settings
├── waybar/           # waybar config
├── zsh/              # zsh config
└── xdg.sh            # global XDG environment bootstrap
```

---

## Installation

Clone into `~/.dotfiles`:

```sh
git clone git@github.com:hamzahchaudhry/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

---

## XDG Environment Setup

XDG base directories are defined globally via `xdg.sh`.

Symlink into `/etc/profile.d`:

```sh
sudo ln -s ~/.dotfiles/xdg.sh /etc/profile.d/xdg.sh
```

This ensures:

* GUI apps
* Hyprland
* systemd user services
* shells

all share the same XDG directory layout.

---

## Zsh Setup (XDG-based)

Zsh is configured to load from:

```
$XDG_CONFIG_HOME/zsh
```

### 1. Symlink zsh config

```sh
ln -s ~/.dotfiles/zsh ~/.config/zsh
```

### 2. Bootstrap ZDOTDIR

Symlink the bootstrap file:

```sh
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
```

This ensures zsh loads config from `~/.config/zsh`.

---

## Symlink Configs into `~/.config`

```sh
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/git ~/.config/git
ln -s ~/.dotfiles/hypr ~/.config/hypr
ln -s ~/.dotfiles/tmux ~/.config/tmux
ln -s ~/.dotfiles/vim ~/.config/vim
ln -s ~/.dotfiles/waybar ~/.config/waybar
```

---

## Exceptions

### Firefox

`user.js` must be copied into your Firefox profile:

```sh
ls ~/.mozilla/firefox
cp ~/.dotfiles/firefox/user.js ~/.mozilla/firefox/<profile>/user.js
```

---

### VSCodium

VSCodium expects settings in:

```
~/.config/VSCodium/User/
```

```sh
mkdir -p ~/.config/VSCodium
ln -s ~/.dotfiles/VSCodium/User ~/.config/VSCodium/User
```

---

### systemd (user)

```sh
mkdir -p ~/.config/systemd
ln -s ~/.dotfiles/systemd/user ~/.config/systemd/user
systemctl --user daemon-reload
```
