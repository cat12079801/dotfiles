sudo apt-get install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev

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
echo "source ~/.bash_profile; pyenv activate neovim2; pip install neovim; pyenv activate neovim3; pip install neovim; source deactivate"
echo "###########################"

# NOTE
# https://qiita.com/lighttiger2505/items/4c6807b7508afe7d4a07