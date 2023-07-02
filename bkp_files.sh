#!/bin/bash

cd /Users/raian/.raian/dotfiles

cp ~/.tmux.conf .
cp ~/.vimrc .
cp ~/.zshrc .
cp ~/.aliases.sh .
cp ~/.vim/coc-settings.json .
cp -r ~/tmux_scripts .

DATE=$(date +%m%d%Y)
echo $DATE
git add .
git commit -m "BKP $DATE"
git push
