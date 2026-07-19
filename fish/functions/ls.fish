function ls --wraps eza
    eza --icons --group-directories-first --sort=extension $argv
end
