function upgrade
    doas emaint -a sync; or return $status
    doas emerge -uDN --with-bdeps=y --backtrack=30 @world $argv; or return $status
    doas emerge -c; or return $status
    doas emerge @preserved-rebuild; or return $status
    doas revdep-rebuild; or return $status
    doas eclean-dist -d; or return $status
    doas eclean-kernel -n 1; or return $status
    doas mandb; or return $status
    fisher update; or return $status
end
