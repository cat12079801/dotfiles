export LANG=ja_JP.UTF-8
KEYTIMEOUT=1
# setopt correct
autoload -U compinit promptinit colors
colors
compinit
promptinit
setopt list_packed
bindkey -v

export LS_COLORS='di=35:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
alias ls="ls -G"



# 以下はプロンプト (・ε・)ﾌﾟｯﾌﾟｸﾌﾟｰ
PROMPT="%F{cyan}[%h#%*${USER}@${HOST%%.*}]%(!.#.$) %f"

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
setopt prompt_subst

precmd_functions=($precmd_functions puppukupu)


# $HOME/.zshrc.local が存在すれば読み込み
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
