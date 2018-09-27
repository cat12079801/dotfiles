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
    echo -ne '<'$str'>'
  fi
}

function git_branch_color() {
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    echo -ne $GREEN
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    echo -ne $BROWN
  elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then
    echo -ne $LIGHT_RED
  else
    echo -ne $RED
  fi
}

# $1: fg color, $2: bg color
function 256_COLOR () { echo -ne "\[\033[38;5;$1m\033[48;5;$2m\]\]"; }

PS1="`256_COLOR 29 0`\!#\u@\h:\w$RESTORE `git_branch_color``git_branch_name`$RESTORE\n$ "
RESTORE="\[\033[0m\]"

# cdコマンド実行後、lsを実行する
function cd() {
  builtin cd $@ && ls;
}

# $HOME/.zshrc.local が存在すれば読み込み
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
