#!/bin/bash

cd ~
mkdir -p .vim/bundle
mkdir -p .vim/vimdots
mkdir -p .vim/backup
cd ~/.vim/bundle
if [ ! -e ~/.vim/bundle/neobundle.vim/ ]; then
  git clone https://github.com/Shougo/neobundle.vim.git
fi
if [ ! -e ~/.vim/dein.vim/ ]; then
  mkdir ~/.vim/dein.vim/
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein.vim-installer.sh
  sh ./dein.vim-installer.sh ~/.vim/dein.vim/
  rm dein.vim-installer.sh
fi
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/config ~/.config
cd
source ~/.bash_profile
