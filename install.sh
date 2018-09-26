#!/bin/bash

cd ~
mkdir -p .vim/bundle
mkdir -p .vim/vimdots
mkdir -p .vim/backup
cd ~/.vim/bundle

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

ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/config ~/.config
cd

# latest python 2.7.x
PYTHON2=`pyenv install --list | grep -E "^ +2.7." | grep -v "dev" | awk 'END{gsub(" ", ""); print}'`
# latest python 3.x (stable)
PYTHON3=`pyenv install --list | grep -E "^ +3."   | grep -v "dev" | awk 'END{gsub(" ", ""); print}'`

pyenv install $PYTHON2
pyenv install $PYTHON3
pyenv virtualenv $PYTHON2 neovim2
pyenv virtualenv $PYTHON3 neovim3

echo ""
echo "exec following command!!!"
echo "###########################"
echo "pyenv activate neovim2; pip install neovim; pyenv activate neovim3; pip install neovim; source deactivate"
echo "###########################"
