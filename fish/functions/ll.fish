function ll --wraps eza
    eza --icons -labo --smart-group --time-style=relative --color-scale=size,age --group-directories-first --total-size --git --sort=extension $argv
end
