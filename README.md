# Dotfiles

Personal configuration for terminal tools and editors.

## Contents

- `alacritty/` - Alacritty terminal config.
- `Code/` - VS Code user settings.
- `firefox/` - `user.js` preferences (copy into a Firefox profile).
- `tmux/` - tmux config.
- `zsh/` - zsh env and aliases.

## Setup

Clone the repo into `~/.dotfiles`:

```sh
git clone <repo> ~/.dotfiles
```

Then create the symlinks wanted:

```sh
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/Code ~/.config/Code
ln -s ~/.dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
```

## Firefox

`user.js` must be placed in the profile directory manually. Copy it
from `~/.dotfiles/firefox/user.js`.
