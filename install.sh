#!/bin/bash

# mkdir -p ~/.vim/bundle
# mkdir -p ~/.vim/vimdots
# mkdir -p ~/.vim/backup

# if [ ! -e ~/.cache/dein ]; then
#   mkdir ~/.vim/dein.vim/
#   curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein.vim-installer.sh
#   sh ./dein.vim-installer.sh ~/.cache/dein
#   rm dein.vim-installer.sh
# fi

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
ln -sf ~/dotfiles/config ~/.config
ln -sf ~/dotfiles/alacritty.yml ~/.alacritty.yml
# mkdir -p ~/.config
# ln -sf ~/dotfiles/config/nvim ~/.config/nvim
# ln -sf ~/dotfiles/config/sxiv ~/.config/sxiv
# ln -sf ~/dotfiles/git-templates ~/.git-templates
# ln -sf ~/dotfiles/config/fish/config.fish  ~/.config/fish/config.fish
# ln -sf ~/dotfiles/config/fish/functions/fish_user_key_bindings.fish ~/.config/fish/functions/fish_user_key_bindings.fish
# ln -sf ~/dotfiles/config/starship.toml ~/.config/starship.toml

# echo ""
# echo "exec following command!!!"
# echo "###########################"
# echo "asdf を使って"
# echo "source ~/.bash_profile; sh pyenv-install.sh"
# echo "###########################"
