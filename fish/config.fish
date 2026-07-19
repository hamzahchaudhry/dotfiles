if status is-login
    if not set -q XDG_RUNTIME_DIR
        set -gx XDG_RUNTIME_DIR "/tmp/xdg-runtime-$USER"
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 700 "$XDG_RUNTIME_DIR"
    end

    # xdg env vars
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_DATA_HOME "$HOME/.local/share"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
    set -gx XDG_STATE_HOME "$HOME/.local/state"

    # user env vars
    set -gx CODEX_HOME "$XDG_CONFIG_HOME/codex"
    set -gx PLATFORMIO_CORE_DIR "$XDG_DATA_HOME/platformio"
    set -gx GOPATH "$XDG_DATA_HOME/go"
    set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"

    set -gx STM32CubeMX_PATH "$HOME/.local/opt/STM32CubeMX"

    set -gx ALTERA_ROOT "$HOME/.local/opt/altera/25.1"
    set -gx QUARTUS_ROOTDIR "$ALTERA_ROOT/quartus"
    set -gx QSYS_ROOTDIR "$QUARTUS_ROOTDIR/sopc_builder/bin"
    set -gx SALT_LICENSE_SERVER "$HOME/.altera.quartus/questa_lic.dat"

    fish_add_path --path --move "$QUARTUS_ROOTDIR/bin" "$ALTERA_ROOT/questa_fse/bin" "$HOME/.local/bin"
end

# enter hyprland on tty1 login
if status is-login && test (tty) = /dev/tty1
    exec dbus-run-session start-hyprland
end

if status is-interactive
    # abbreviations
    abbr --add gcl 'git clone'
    abbr --add gs 'git status'
    abbr --add ga 'git add'
    abbr --add gc 'git commit'
    abbr --add gp 'git push'
    abbr --add gd 'git diff'
    abbr --add gr 'git restore'
    abbr --add gu 'git restore --staged'
    abbr --add gl 'git log'
    abbr --add ip 'ip -c'
    abbr --add s 'ookla-speedtest'
    abbr --add c 'clear'

    zoxide init --cmd cd fish | source
end
