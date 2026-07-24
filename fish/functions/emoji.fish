function emoji
    set -l choice (awk -F '# ' '/; fully-qualified/ {
        sub(/ E[0-9.]+ /, " ", $2)
        print $2
    }' /usr/share/unicode/emoji/emoji-test.txt |
    tofi --font 'JetBrainsMono Nerd Font, Noto Color Emoji' --prompt-text 'emoji: ')
    test -n "$choice"; and printf %s (string split -m1 ' ' -- "$choice")[1] | wl-copy
end
