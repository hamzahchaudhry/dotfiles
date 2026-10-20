set -g fish_greeting

if status is-login
    # user env vars
    set -gx TERMINAL foot
    set -gx CODEX_HOME "$HOME/.config/codex"
    set -gx PLATFORMIO_CORE_DIR "$HOME/.local/share/platformio"
    set -gx GOPATH "$HOME/.local/share/go"
    set -gx CARGO_HOME "$HOME/.local/share/cargo"

    set -gx ALTERA_ROOT "$HOME/.local/opt/altera/25.1"
    set -gx QUARTUS_ROOTDIR "$ALTERA_ROOT/quartus"
    set -gx QSYS_ROOTDIR "$QUARTUS_ROOTDIR/sopc_builder/bin"

    fish_add_path --path --move "$HOME/.local/bin" "$QUARTUS_ROOTDIR/bin" "$ALTERA_ROOT/questa_fse/bin"
end

# enter window manager on tty1 login
if status is-login && test (tty) = /dev/tty1
    set -gx NO_AT_BRIDGE 1
    exec dbus-run-session mango >~/.local/state/mango.log 2>&1
end

if status is-interactive
    fish_vi_key_bindings
    bind -M insert ctrl-backspace backward-kill-word

    # abbreviations
    abbr -a gcl 'git clone'
    abbr -a gs 'git status -sb'
    abbr -a ga 'git add'
    abbr -a gc --set-cursor 'git commit -m "%"'
    abbr -a gp 'git push'
    abbr -a gd 'git diff'
    abbr -a gr 'git restore'
    abbr -a gu 'git restore --staged'
    abbr -a gl 'git --no-pager log --oneline --decorate -10'
    abbr -a ip 'ip -c'
    abbr -a s 'ookla-speedtest'
    abbr -a c 'clear'
    abbr -a net 'doas iwctl station wlan0 get-networks'
    abbr -a iwdr 'doas rc-service iwd restart'
    abbr -a con 'doas iwctl station wlan0 connect'
    abbr -a t 'task'
    abbr -a td 'task done'
    abbr -a tm 'task modify'
    abbr -a tsm 'task add project:supermileage'
    abbr -a tper 'task add project:personal'
    abbr -a cr 'codex resume'
    abbr -a ep 'doas emlop p'
    abbr -a z 'zathura --fork'

    set -g fish_color_command brgreen
    source /usr/share/fzf/key-bindings.fish
    set -g -- FZF_ALT_C_OPTS '--preview "eza --tree --level=2 --icons --color=always -- {}" --preview-window=right:55%'
    set -gx FZF_CTRL_R_OPTS "--with-nth 3.. --bind 'alt-t:change-with-nth(2..|1,3..|3..)'"
    zoxide init --cmd cd fish | source
end
