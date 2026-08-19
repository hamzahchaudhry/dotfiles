function lsize --wraps eza
    eza --icons -labo --smart-group --time-style=relative --color-scale=size,age --group-directories-first --total-size --git --sort=size --reverse $argv
end
