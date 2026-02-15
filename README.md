# dotfiles

Personal configuration for my Linux setup.

## Structure

```text
.
├── alacritty/        # Alacritty config
├── firefox/          # Firefox user.js (manual link)
├── git/              # Git config
├── hypr/             # Hyprland ecosystem configs
├── systemd/          # User-level systemd overrides (manual link)
├── tmux/             # tmux config
├── vim/              # Vim config
├── VSCodium/         # VSCodium user settings (manual link)
├── waybar/           # Waybar config
└── zsh/              # Zsh config (modular)
```

---

## Installation

Clone into `~/.dotfiles`:

```sh
git clone git@github.com:hamzahchaudhry/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

---

## Setup

### Symlink configs into `~/.config` (excluding Firefox, VSCodium, systemd)

```sh
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/git ~/.config/git
ln -s ~/.dotfiles/hypr ~/.config/hypr
ln -s ~/.dotfiles/tmux ~/.config/tmux
ln -s ~/.dotfiles/vim ~/.config/vim
ln -s ~/.dotfiles/waybar ~/.config/waybar
ln -s ~/.dotfiles/zsh ~/.config/zsh
```

---

## Exceptions

### Firefox

`user.js` must be copied into Firefox profile directory:

```sh
ls ~/.mozilla/firefox
cp ~/.dotfiles/firefox/user.js ~/.mozilla/firefox/<profile>/user.js
```

---

### VSCodium

VSCodium expects settings in:

`~/.config/VSCodium/User/`

```sh
mkdir -p ~/.config/VSCodium
ln -s ~/.dotfiles/VSCodium/User ~/.config/VSCodium/User
```

---

### systemd (user)

Link user units/overrides into the standard systemd user dir:

```sh
mkdir -p ~/.config/systemd
ln -s ~/.dotfiles/systemd/user ~/.config/systemd/user
systemctl --user daemon-reload
```
