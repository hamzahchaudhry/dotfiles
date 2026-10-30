function upgrade
    doas sh -c '
      set -e
      emerge --sync --jobs=4
      emerge -avuDN --keep-going @world
      smart-live-rebuild
      emerge @preserved-rebuild
      emerge -c
      eclean-dist -d
      # backups can share a kernel version; kernel-install remove deletes their shared module indexes
      eclean-kernel --no-kernel-install -n 1
    '
    fisher update
    uv tool upgrade --all
    mkdir -p ~/.local/share/emoji-picker
    sed 's#</\?small>##g' ~/.local/share/uv/tools/rofimoji/lib/python*/site-packages/picker/data/emojis_*.csv > ~/.local/share/emoji-picker/emojis
    flatpak update -y
    flatpak uninstall --unused
end
