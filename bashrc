# 基本
export LESSCHARSET=utf-8
export EDITOR=vim
export LANG=en_US.UTF-8

# Escの後受付時間を短く
KEYTIMEOUT=1

# vi操作
set -o vi

# プロンプトの色、補完
complete -cf sudo

# エイリアス
alias vim="nvim"
alias tmux="tmux -2"
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


###### PROMPT

RESTORE="\033[0m"

BOLD="\033[1m"
DIM="\033[2m"
UNDERLINE="\033[4m"
BLINK="\033[5m"
REVERSE="\033[7m"
HIDDEN="\033[8m"

NOBOLD="\033[21m"
NODIM="\033[22m"
NOUNDERLINE="\033[24m"
NOBLINK="\033[25m"
NOREVERSE="\033[27m"
NOHIDDEN="\033[28m"

function git_branch_name() {
  str=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  if [ -n "$str" ]; then
    echo -ne '<'$str'>'
  else
    echo -ne ''
  fi
}

function git_branch_color() {
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    echo -ne `256_COLOR 2 0`
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    echo -ne `256_COLOR 3 0`
  elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then
    echo -ne `256_COLOR 9 0`$BOLD
  else
    echo -ne `256_COLOR 1 0`
  fi
}

# $1: fg color, $2: bg color
function 256_COLOR() { echo -ne "\033[38;5;$1m\033[48;5;$2m"; }

PS1="`256_COLOR 29 0`\!#\t `256_COLOR 35 0`$UNDERLINE\u@\h$RESTORE`256_COLOR 29 0`:\w$RESTORE \$(git_branch_color)\$(git_branch_name)$RESTORE\n$ "

###### PROMPT

# cdコマンド実行後、lsを実行する
function cd() {
  builtin cd $@ && ls;
}

# $HOME/.bashrc.local が存在すれば読み込み
[ -f $HOME/.bashrc.local ] && source $HOME/.bashrc.local
