function upgrade
    doas emerge --sync --jobs=3; or return
    doas emerge -avuDN --keep-going @world; or return
    doas smart-live-rebuild; or return
    doas emerge @preserved-rebuild; or return
    doas emerge -c; or return
    doas eclean-dist -d; or return
    doas eclean-kernel -n 1; or return
    fisher update
    uv tool upgrade --all; or return
    mkdir -p ~/.local/share/emoji-picker
    sed 's#</\?small>##g' ~/.local/share/uv/tools/rofimoji/lib/python*/site-packages/picker/data/emojis_*.csv > ~/.local/share/emoji-picker/emojis; or return
    flatpak update -y
    flatpak uninstall --unused
end
