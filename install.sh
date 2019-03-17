#!/bin/bash

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/vimdots
mkdir -p ~/.vim/backup

if [ ! -e ~/.pyenv/ ]; then
  git clone https://github.com/yyuu/pyenv.git ~/.pyenv
  git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
fi

if [ ! -e ~/.cache/dein ]; then
  mkdir ~/.vim/dein.vim/
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein.vim-installer.sh
  sh ./dein.vim-installer.sh ~/.cache/dein
  rm dein.vim-installer.sh
fi

if [ ! -e ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -e ~/.fzf/ ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --key-bindings --completion --no-update-rc --no-zsh --no-fish
fi

ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
mkdir -p ~/.config
ln -sf ~/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/config/sxiv ~/.config/sxiv
ln -sf ~/dotfiles/tigrc ~/.tigrc

echo ""
echo "exec following command!!!"
echo "###########################"
echo "source ~/.bash_profile; sh pyenv-install.sh"
echo "###########################"
