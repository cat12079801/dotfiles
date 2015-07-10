export PATH="./bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH"

# 覚悟を決めよう
export LANG=en

# rbenv
if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# npm
if [[ -s ~/.nvm/nvm.sh ]];
  then source ~/.nvm/nvm.sh
fi

# $HOME/.zshenv.local が存在すれば読み込み
[ -f $HOME/.zshenv.local ] && source $HOME/.zshenv.local
