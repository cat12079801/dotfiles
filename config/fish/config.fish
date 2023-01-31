# 基本セット
set PATH /usr/local/bin /bin /sbin /usr/bin /usr/sbin /usr/local/sbin $PATH
# asdf用
set PATH ~/.asdf/shims $PATH
# cargo用
set PATH ~/.cargo/bin $PATH
# linuxbrew用。TODO: これは個別に切り分けたい
set PATH /home/linuxbrew/.linuxbrew/bin/ $PATH

set fish_color_normal normal
set fish_color_command a1b56c
set fish_color_quote f7ca88
set fish_color_redirection d8d8d8
set fish_color_end ba8baf
set fish_color_error a1b56c --underline
set fish_color_param d8d8d8
set fish_color_comment f7ca88
set fish_color_match 7cafc2
set fish_color_selection white --bold --background=brblack
set fish_color_search_match bryellow --background=brblack
set fish_color_history_current --bold
set fish_color_operator 7cafc2
set fish_color_escape 86c1b9
set fish_color_cwd green
set fish_color_cwd_root red
set fish_color_valid_path --underline
set fish_color_autosuggestion 585858
set fish_color_user brgreen
set fish_color_host normal
set fish_color_cancel -r
set fish_pager_color_completion normal
set fish_pager_color_description B3A06D yellow
set fish_pager_color_prefix white --bold --underline
set fish_pager_color_progress brwhite --background=cyan

starship init fish | source

# for Fish & Homebrew
source /usr/local/opt/asdf/libexec/asdf.fish

alias p8="ping 8.8.8.8"
alias vim="nvim"
# alias tmux="tmux -2"
# alias tmuxa="tmux new-session -A -s"
alias grep="grep --color"
alias clearl="clear; ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
if [ "(type lsd >/dev/null 2>&1)" ];
  # lsdがインストールされていればエイリアスに登録
  alias ls="lsd"
else
  echo '`lsd` is not installed!' >&2
end

alias ga="git add"
alias gaa="git add ."
alias gau="git add -u"
alias gb="git br"
alias gbd="git branch -d"
alias gcm="git commit"
alias gca="git commit --amend"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gd="git diff"
alias gdb="git diff -b"
alias gl="git log --date=iso --decorate"
alias glp="git log --date=iso --decorate --patch"
alias glg="git log --date=iso --graph --decorate --oneline --all"
alias glc="git log --pretty=\'%H %s\'"
alias glt="git tr"
alias gs="git status -bs"
alias gss="git status"
alias gf="git fetch"
alias gp="git pull"
alias gst="git stash"
alias gstl="git stash list"
alias gstp="git stash pop"
alias gstd="git stash drop"
alias gsf="git branch | fzf | xargs git switch"
