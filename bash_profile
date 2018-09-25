export PATH="./bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH"

# rbenv
if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# npm
if [[ -s ~/.nvm/nvm.sh ]];
  then source ~/.nvm/nvm.sh
fi

# pyenv
if [[ -d ~/.pyenv ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PATH:$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# $HOME/.bash_profile.local が存在すれば読み込み
[ -f $HOME/.bash_profile.local ] && source $HOME/.bash_profile.local

if [ -f /etc/bashrc ] ; then
  . /etc/bashrc
fi
if [ -f ~/.bashrc ] ; then
  . ~/.bashrc
fi
