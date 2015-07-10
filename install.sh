cd ~
mkdir -p .vim/{bundle,vimdots,backup}
cd ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim.git
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zshenv ~/.zshenv
ln -sf ~/dotfiles/zprofile ~/.zprofile
cd
source ~/.zprofile
source ~/.zshenv
source ~/.zshrc
