# 基本
export LESSCHARSET=utf-8
export EDITOR=vim
export LANG=en_US.UTF-8
export VIRTUAL_ENV_DISABLE_PROMPT=1
export FZF_DEFAULT_OPTS='--preview "head -100 {}"'
export IGNOREEOF=999
if type ag >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
else
  echo '`ag` is not installed!' >&2
fi

# Escの後受付時間を短く
KEYTIMEOUT=1

# vi操作
set -o vi

# プロンプトの色、補完
complete -cf sudo

# http://qiita.com/s-age/items/2046185547c73a86f09f
# lsコマンドの色
if [ "$(uname)" = 'Darwin' -o "$(uname)" = 'FreeBSD' ]; then
  export LSCOLORS=cxGxcxdxbxegedabagacad
  alias ls='ls -G'
else
  eval `dircolors ~/dotfiles/dircolors -b`
  alias ls='ls --color=auto'
fi

# エイリアス
alias vim="nvim"
alias tmux="tmux -2"
alias grep="grep --color"
alias clearl="clear; ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias histry-all="history -E 1"
if [ "$(uname)" = 'Darwin' ]; then
  alias clip="pbcopy" # Mac
elif [ "$(uname)" = 'Linux' ]; then
  alias clip="xsel -bi" # Ubuntu
fi
if type lsd >/dev/null 2>&1; then
  alias ls="lsd"
else
  echo '`lsd` is not installed!' >&2
fi

# ----------------------
# Git Aliases
# ----------------------
[ -f $HOME/dotfiles/git-completion.bash ] && source $HOME/dotfiles/git-completion.bash

git_alias() {
  __git_complete $1 "_git_$2"
  alias $1="git ${*:2:($#-1)}"
}

git_alias ga add
git_alias gaa add .
git_alias gau add -u
git_alias gb br
git_alias gbd branch -d
git_alias gcm commit
git_alias gca commit --amend
git_alias gc checkout
git_alias gcb checkout -b
git_alias gd diff
git_alias gl log --date=iso --decorate
git_alias glp log --date=iso --decorate --patch
git_alias glg log --date=iso --graph --decorate --oneline --all
git_alias glc log --pretty=\'%H %s\'
git_alias glt tr
git_alias gs status -bs
git_alias gss status
git_alias gf fetch
git_alias gp pull
git_alias gst stash
git_alias gstl stash list
git_alias gstp stash pop
git_alias gstd stash drop

# ctrl-w で'/'手前まで削除
stty werase undef
bind '"\C-w": unix-filename-rubout'

# history
function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
export HISTCONTROL=ignoredups
export SAVESIZE=10000000
shopt -u histappend
export HISTSIZE=1000000


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

# TODO: apply all envs. (now only show pyenv)
function show_virtual_env() {
  if [ -n "$VIRTUAL_ENV" ]; then
    if [ -n "$PYENV_VIRTUAL_ENV" ]; then
      pyenv=`echo $PYENV_VIRTUAL_ENV | awk -F'/' '{printf "py:%s/%s", $(NF), $(NF-2)}'`
    fi
    echo -ne `256_COLOR 239 0`'<'$pyenv'>'$RESTORE
  else
    echo -ne ''
  fi
}

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

PS1="`256_COLOR 29 0`\!#\t `256_COLOR 35 0`$UNDERLINE\u@\h$RESTORE`256_COLOR 29 0`:$RESTORE\$(show_virtual_env)`256_COLOR 29 0`\w$RESTORE \$(git_branch_color)\$(git_branch_name)$RESTORE\n$ "

###### PROMPT

# cdコマンド実行後、lsを実行する
autols(){
  if [[ -n $AUTOLS_DIR ]] && [[ $AUTOLS_DIR != $PWD ]] ; then
    [[ `/bin/ls -f | grep -v "\..*" | wc -l` -le 100 ]]\
      && ls || echo -e "\
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\n\
 🔥`256_COLOR 196`!!!too many files!!!🔥\n\
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥" >&2
  fi

  AUTOLS_DIR="${PWD}"
}

export PROMPT_COMMAND="autols"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# $HOME/.bashrc.local が存在すれば読み込み
[ -f $HOME/.bashrc.local ] && source $HOME/.bashrc.local
