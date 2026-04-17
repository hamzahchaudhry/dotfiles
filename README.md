# dotfiles

my arch linux + hyprland dotfiles.

## layout

```text
.
├── home/        # files mirrored into selected paths under $HOME
├── etc/         # root-owned files installed into /etc
├── install.sh   # install script
└── README.md
```

`home/` contains user config under `~/.config`, user files under `~/.local`, and the firefox profile template.

`etc/` contains system config for NetworkManager, mkinitcpio, kernel cmdline, modprobe, pacman hooks, profile.d, snapper, sysctl, udev, and zsh.

## assumptions

- the repo lives at `~/.dotfiles`
- `home/` mirrors selected paths under `$HOME`, mainly `~/.config` and `~/.local`
- `/etc/zsh/zshenv` bootstraps zsh and points `ZDOTDIR` at `~/.config/zsh`
- the firefox profile path is hardcoded near the top of `install.sh` and points into `$XDG_CONFIG_HOME/mozilla/firefox/`

## install

```sh
git clone git@github.com:hamzahchaudhry/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh`:

- runs explicit `ln -sfn` commands for the managed `home/` paths
- runs explicit `doas install -Dm...` commands for every tracked `etc/` file
- reloads `systemctl --user daemon-reload` at the end

it also symlinks:

- `user.js`
- `chrome/`

from `home/.config/mozilla/firefox/profile/` into the hardcoded profile path at the top of `install.sh`.

## notes

- zsh config lives in `home/.config/zsh/`, including cached `.zwc` files
- user units live in `home/.config/systemd/user/`
- user service helper scripts live in `home/.local/bin/systemd/`
- app launch wrappers live in `home/.local/bin/launch/`
- waybar scripts live in `home/.config/waybar/scripts/`
- vendor app desktop files live in `home/.local/share/applications/`
