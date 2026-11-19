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
      eclean-kernel --no-kernel-install -n 2
    '; or return
    fisher update; or return
    uv tool upgrade --all; or return
    mkdir -p "$XDG_DATA_HOME/emoji-picker"; or return
    sed 's#</\?small>##g' "$XDG_DATA_HOME/uv/tools/rofimoji/lib"/python*/site-packages/picker/data/emojis_*.csv >"$XDG_DATA_HOME/emoji-picker"/emojis; or return
    flatpak update -y; or return
    flatpak uninstall --unused
end
