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
    '; or return
    fisher update; or return
    uv tool upgrade --all; or return
    mkdir -p ~/.local/share/emoji-picker; or return
    sed 's#</\?small>##g' ~/.local/share/uv/tools/rofimoji/lib/python*/site-packages/picker/data/emojis_*.csv >~/.local/share/emoji-picker/emojis; or return
    flatpak update -y; or return
    flatpak uninstall --unused
end
