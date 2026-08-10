# 基本セット
set PATH /usr/local/bin /bin /sbin /usr/bin /usr/sbin /usr/local/sbin $PATH
# cargo用
set PATH ~/.cargo/bin $PATH

set PATH ~/.orbstack/bin $PATH
set PATH ~/Library/Python/3.9/bin $PATH

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

# いずれも「起動時に初期化コードを読み込む」だけで、導入は行わない。
# 実体の導入は mise.toml の [bootstrap.packages] が担う。
command -q starship; and starship init fish | source

command -q mise; and mise activate fish | source

# コマンドそのものの差し替え。省略記法ではないため alias（関数）で定義する。
# abbr にすると入力が別名へ展開されてしまい、置き換えの意図と合わない。
alias vim="nvim"
alias grep="grep --color"
command -q lsd; and alias ls="lsd"

# 以下は省略記法なので abbr で定義する。入力時に実コマンドへ展開されるため、
# 履歴に実行内容が残り、git のサブコマンド補完もそのまま効く。
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a clearl 'clear; ls'

abbr -a ga 'git add'
abbr -a gaa 'git add .'
abbr -a gau 'git add -u'
abbr -a gc 'git checkout'
abbr -a gca 'git commit --amend'
abbr -a gcm 'git commit'
abbr -a gd 'git diff'
abbr -a gf 'git fetch'
abbr -a gl 'git log --date=iso --decorate'
abbr -a glp 'git log --date=iso --decorate --patch'
abbr -a glt 'git tr'
abbr -a gp 'git pull'
abbr -a gs 'git status -bs'
abbr -a gss 'git status'

# Safe-chain。npm / npx / yarn 等をラップして検査を挟む。
# 導入は mise.toml の [tasks.bootstrap] が担う。
# `safe-chain setup` を実行してはならない。本ファイルを書き換えるため、
# リポジトリへの symlink である本ファイルが汚れる。配線はここで管理する。
test -f ~/.safe-chain/scripts/init-fish.fish
  and source ~/.safe-chain/scripts/init-fish.fish

# for asana mcp
# security は macOS 固有のため存在を確認する。コマンド自体が無い場合の
# エラーは fish がコマンド解決時に出すもので 2>/dev/null では抑止できない。
if status is-interactive; and command -q security
  set -gx ASANA_CLIENT_ID     (security find-generic-password -a "$USER" -s asana-mcp-client-id     -w 2>/dev/null)
  set -gx ASANA_CLIENT_SECRET (security find-generic-password -a "$USER" -s asana-mcp-client-secret -w 2>/dev/null)
end
