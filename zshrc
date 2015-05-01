# 基本
export EDITOR=vim
export LANG=ja_JP.UTF-8

# Escの後受付時間を短く
KEYTIMEOUT=1

# vi操作
bindkey -v

# プロンプトの色、補完
autoload -U colors compinit promptinit
compinit
promptinit
colors

# 各種設定
setopt list_packed
setopt prompt_subst
setopt noauto_menu

# エイリアス
alias grep="grep --color"
alias clearl="clear; ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias emacs="vim"
alias vsc="vim"
alias subl="vim"
alias atom="vim"

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVESIZE=100000
setopt EXTENDED_HISTORY
setopt RM_STAR_WAIT
setopt hist_reduce_blanks
setopt hist_no_store

# http://qiita.com/s-age/items/2046185547c73a86f09f
# lsコマンドの色
if [ "$(uname)" = 'Darwin' ]; then
  export LSCOLORS=cxfxcxdxbxegedabagacad
  alias ls='ls -G'
else
  # eval `dircolors ~/dotofiles/colorrc`
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
