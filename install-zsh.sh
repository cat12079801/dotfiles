#!/bin/zsh

cd ~
mkdir -p .vim/bundle
mkdir -p .vim/vimdots
mkdir -p .vim/backup
cd ~/.vim/bundle

if [ ! -e ~/.pyenv/ ]; then
  git clone https://github.com/yyuu/pyenv.git ~/.pyenv
  git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
fi

mkdir -p ~/.cache/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git \
      ~/.vim/dein/repos/github.com/Shougo/dein.vim

if [ ! -e ~/.cache/dein ]; then
  mkdir -p ~/.vim/dein.vim/
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein.vim-installer.sh
  sh ./dein.vim-installer.sh ~/.cache/dein
  rm dein.vim-installer.sh
fi

ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zshenv ~/.zshenv
ln -sf ~/dotfiles/zprofile ~/.zprofile
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
mkdir -p ~/.config/
ln -sf ~/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/config/sxiv ~/.config/sxiv
cd
source ~/.zprofile
source ~/.zshenv
source ~/.zshrc
