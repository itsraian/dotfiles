#!/bin/bash

cp ~/.tmux.conf .
cp ~/.vimrc .
cp ~/.vim/coc-settings.json .

DATE=$(date +%m%d%Y)
echo $DATE
git add .
git commit -m "BKP $DATE"
