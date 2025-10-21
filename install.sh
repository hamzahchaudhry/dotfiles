#!/bin/bash

[ "$1" ] && cp -r "$1" ~/.config/ || cp -r alacritty zsh tmux ~/.config/
