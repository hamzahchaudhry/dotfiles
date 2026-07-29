function upgrade
    doas emerge --sync --jobs=2; or return
    doas emerge -uDN --keep-going @world; or return
    doas emerge @preserved-rebuild; or return
    doas emerge -c; or return
    doas eclean-dist -d; or return
    doas eclean-kernel -n 1; or return
    fisher update
end
