export PATH="./bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH"

source ./lazyenv.bash

# rbenv
_rbenv_init() {
  if [ -d $HOME/.rbenv ]; then
    export PATH="$PATH:$HOME/.rbenv/bin"
    eval "$(rbenv init -)"
  fi
}
eval "$(lazyenv.load _npm_init rbenv ruby )"

_npm_init() {
  if [[ -s ~/.nvm/nvm.sh ]];
    then source ~/.nvm/nvm.sh
  fi
}
eval "$(lazyenv.load _npm_init node npm)"

_pyenv_init() {
  if [[ -d ~/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PATH:$PYENV_ROOT/bin"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
}
eval "$(lazyenv.load _pyenv_init pyenv python pip)"


# $HOME/.zshenv.local が存在すれば読み込み
[ -f $HOME/.zshenv.local ] && source $HOME/.zshenv.local
