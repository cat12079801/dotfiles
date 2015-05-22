cd ~
mkdir .vim
mkdir .vim/bundle
mkdir .vim/vimdots
cd ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim.git
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zshenv ~/.zshenv
