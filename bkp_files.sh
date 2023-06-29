#!/bin/bash

cp ~/.tmux.conf .
cp ~/.vimrc .
cp ~/.vim/coc-settings.json .

DATE=$(date +%m%d%Y)
git add .
git commit -m "BKP $(DATE)"
