#!/bin/bash

cd ~
mkdir -p .vim/bundle
mkdir -p .vim/vimdots
mkdir -p .vim/backup
cd ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim.git
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
cd
source ~/.bash_profile
