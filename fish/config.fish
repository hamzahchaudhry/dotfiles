set -g fish_greeting

if status is-login
    # user env vars
    set -gx CODEX_HOME "$HOME/.config/codex"
    set -gx PLATFORMIO_CORE_DIR "$HOME/.local/share/platformio"
    set -gx GOPATH "$HOME/.local/share/go"
    set -gx CARGO_HOME "$HOME/.local/share/cargo"

    set -gx ALTERA_ROOT "$HOME/.local/opt/altera/25.1"
    set -gx QUARTUS_ROOTDIR "$ALTERA_ROOT/quartus"
    set -gx QSYS_ROOTDIR "$QUARTUS_ROOTDIR/sopc_builder/bin"
    set -gx SALT_LICENSE_SERVER "$HOME/.altera.quartus/questa_lic.dat"

    fish_add_path --path --move "$HOME/.local/bin" "$QUARTUS_ROOTDIR/bin" "$ALTERA_ROOT/questa_fse/bin"
end

# enter window manager on tty1 login
if status is-login && test (tty) = /dev/tty1
    set -gx NO_AT_BRIDGE 1
    exec dbus-run-session mango
end

if status is-interactive
    fish_vi_key_bindings
    bind -M insert ctrl-backspace backward-kill-word

    # abbreviations
    abbr --add gcl 'git clone'
    abbr --add gs 'git status -sb'
    abbr --add ga 'git add'
    abbr --add gc --set-cursor 'git commit -m "%"'
    abbr --add gp 'git push'
    abbr --add gd 'git diff'
    abbr --add gr 'git restore'
    abbr --add gu 'git restore --staged'
    abbr --add gl 'git --no-pager log --oneline --decorate -10'
    abbr --add ip 'ip -c'
    abbr --add s 'ookla-speedtest'
    abbr --add c 'clear'
    abbr --add net 'doas iwctl station wlan0 get-networks'
    abbr --add iwdr 'doas rc-service iwd restart'
    abbr --add con 'doas iwctl station wlan0 connect'
    abbr --add t 'task'
    abbr --add td 'task done'
    abbr --add tm 'task modify'
    abbr --add tsm 'task add project:supermileage'
    abbr --add tper 'task add project:personal'
    abbr --add cr 'codex resume'
    abbr --add ep 'doas emlop p'

    set --global fish_color_command brgreen
    source /usr/share/fzf/key-bindings.fish
    set --global -- FZF_ALT_C_OPTS '--preview "eza --tree --level=2 --icons --color=always -- {}" --preview-window=right:55%'
    set -gx FZF_CTRL_R_OPTS "--with-nth 3.. --bind 'alt-t:change-with-nth(2..|1,3..|3..)'"
    zoxide init --cmd cd fish | source
end
