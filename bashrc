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


# 以下はプロンプト (･ε･)ﾌﾟｯﾌﾟｸﾌﾟｰ
PROMPT="%F{cyan}[%h#%* ${USER}@${HOST%%.*} %1~]%(!.#.$) %f"

function rprompt-git-current-branch {
  local name st color

  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi
  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  if [[ -z $name ]]; then
    return
  fi
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=${fg[green]}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=${fg[yellow]}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=${fg_bold[red]}
  else
    color=${fg[red]}
  fi

  # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
  # これをしないと右プロンプトの位置がずれる
  echo "%{$color%}$name%{$reset_color%} "
}

function puppukupu {
  if [ $? -eq 0 ]; then
    RPROMPT='[`rprompt-git-current-branch`%~]'
  else
    RPROMPT="%{${fg[magenta]}%}(･ε･)ﾌﾟｯﾌﾟｸﾌﾟｰ%{${reset_color}%}"
  fi
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
precmd_functions=($precmd_functions puppukupu)

# cdコマンド実行後、lsを実行する
function cd() {
  builtin cd $@ && ls;
}

# $HOME/.zshrc.local が存在すれば読み込み
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
