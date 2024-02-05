#!/bin/bash

cd /Users/raian/.raian/dotfiles

cp ~/.tmux.conf .
cp ~/.vimrc .
cp ~/.zshrc .
cp ~/.aliases.sh .
cp ~/.alacritty.toml
cp ~/.vim/coc-settings.json .
cp ~/.config/helix/config.toml .
cp ~/.config/helix/languages.toml .

DATE=$(date +%m%d%Y)
git checkout $DATE
git add .
git commit -m "BKP $DATE"
git push
git checkou main
