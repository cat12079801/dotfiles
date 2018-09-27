# 基本
export EDITOR=vim
export LANG=ja_JP.UTF-8

# Escの後受付時間を短く
KEYTIMEOUT=1

# vi操作
set -o vi

# プロンプトの色、補完
complete -cf sudo

# エイリアス
alias grep="grep --color"
alias clearl="clear; ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias histry-all="history -E 1"

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVESIZE=100000

# http://qiita.com/s-age/items/2046185547c73a86f09f
# lsコマンドの色
if [ "$(uname)" = 'Darwin' -o "$(uname)" = 'FreeBSD' ]; then
  export LSCOLORS=cxGxcxdxbxegedabagacad
  alias ls='ls -G'
else
  eval `dircolors ~/dotfiles/dircolors -b`
  alias ls='ls --color=auto'
fi

function git_branch_name() {
  str=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  if [ -n "$str" ]; then
    echo '<'$str'>'
  fi
}

function git_branch_color() {
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    echo $GREEN
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    echo $BROWN
  elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then
    echo $LIGHT_RED
  else
    echo $RED
  fi
}

PS1="$PURPLE\!$RESTORE-$CYAN\u$RESTORE@$GREEN\h:$YELLOW\w$RESTORE `git_branch_color``git_branch_name`$RESTORE\n$ "

GREEN="\[\033[0;32m\]"
CYAN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
BROWN="\[\033[0;33m\]"
LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_CYAN="\[\033[1;36m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
RESTORE="\[\033[0m\]"

# cdコマンド実行後、lsを実行する
function cd() {
  builtin cd $@ && ls;
}

# $HOME/.zshrc.local が存在すれば読み込み
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
