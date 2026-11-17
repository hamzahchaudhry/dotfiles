# environment
set -gx TERMINAL foot
set -gx CODEX_HOME "$XDG_CONFIG_HOME/codex"
set -gx PLATFORMIO_CORE_DIR "$XDG_DATA_HOME/platformio"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx OLLAMA_MODELS "$XDG_DATA_HOME/ollama/models"

set -gx ALTERA_ROOT "$HOME/.local/opt/altera/25.1"
set -gx QUARTUS_ROOTDIR "$ALTERA_ROOT/quartus"
set -gx QSYS_ROOTDIR "$QUARTUS_ROOTDIR/sopc_builder/bin"

# path
fish_add_path -P "$GOPATH/bin" \
    "$ALTERA_ROOT/questa_fse/bin" \
    "$QUARTUS_ROOTDIR/bin" \
    "$HOME/.local/bin"

# enter window manager on tty1 login
if status is-login && test (tty) = /dev/tty1
    set -gx NO_AT_BRIDGE 1
    mkdir -p "$XDG_STATE_HOME"; or return
    exec dbus-run-session mango >"$XDG_STATE_HOME/mango.log" 2>&1
end

# interactive shell setup
if status is-interactive
    set -g fish_greeting
    set -g fish_color_command brgreen

    fish_vi_key_bindings
    bind -M insert ctrl-backspace backward-kill-word
    bind -M insert ctrl-delete kill-word

    # git
    abbr -a gcl 'git clone'
    abbr -a gs 'git status -sb'
    abbr -a ga 'git add'
    abbr -a gc --set-cursor 'git commit -m "%"'
    abbr -a gp 'git push'
    abbr -a gpl 'git pull'
    abbr -a gd 'git diff'
    abbr -a gr 'git restore'
    abbr -a gu 'git restore --staged'
    abbr -a gl 'git --no-pager log --oneline --decorate -10'

    # tasks
    abbr -a t task
    abbr -a td 'task done'
    abbr -a tm 'task modify'
    abbr -a tsm 'task add project:supermileage'
    abbr -a tper 'task add project:personal'

    # network
    abbr -a net 'iwctl station wlan0 get-networks'
    abbr -a scan 'iwctl station wlan0 scan'
    abbr -a con 'iwctl station wlan0 connect'
    abbr -a iwdr 'doas rc-service iwd restart'
    abbr -a ip 'ip -c'
    abbr -a s speedtest-go

    # gentoo
    abbr -a ea 'doas emerge -a'
    abbr -a ew 'doas emerge -W'
    abbr -a eu 'equery uses'
    abbr -a ep 'doas emlop p'
    abbr -a bl "doas sh -c 'tail -fn 50 /var/tmp/portage/*/*/temp/build.log'"
    abbr -a rc 'doas rc-service'

    # utils
    abbr -a c clear
    abbr -a cr 'codex resume'
    abbr -a z 'zathura --fork'
    abbr -a ap airpods

    # fzf
    source /usr/share/fzf/key-bindings.fish

    # zoxide
    zoxide init --cmd cd fish | source
end
