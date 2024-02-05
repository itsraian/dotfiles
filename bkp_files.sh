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

git checkout main
DATE=$(date +%m%d%Y)
echo $DATE
git add .
git commit -m "BKP $DATE"
git push
