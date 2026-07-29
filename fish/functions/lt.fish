function lt --wraps eza
    set -l level_args --level=2

    if set -q argv[1]; and string match --quiet --regex '^[0-9]+$' -- $argv[1]
        if test $argv[1] = 0
            set --erase level_args
        else
            set level_args --level=$argv[1]
        end

        set --erase argv[1]
    end

    command eza --icons -a --tree $level_args --git-ignore --group-directories-first -I '.git|node_modules|target|dist|build|__pycache__|.venv|coverage' $argv
end
