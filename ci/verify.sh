#!/usr/bin/env bash
# dotfiles の適用を検証する。
#
# 使い捨ての環境で実行することを前提とする。~/.gitconfig 等を実際に
# 置き換えるため、常用環境で直接実行してはならない。
# ローカルでの実行は ci/run-container.sh を使う。
#
# 前提: ~/dotfiles にリポジトリがあり、mise と fish が導入済みであること。

set -uo pipefail

fail=0
ok()   { printf '  \033[32mOK\033[0m   %s\n' "$1"; }
ng()   { printf '  \033[31mNG\033[0m   %s\n' "$1"; fail=1; }
head_() { printf '\n=== %s ===\n' "$1"; }

cd ~/dotfiles || { echo "~/dotfiles が無い"; exit 1; }
mise trust >/dev/null 2>&1

# 適用前の状態を控える。検査したいのは「適用がリポジトリを書き換えないこと」
# であり、実行前から存在する未追跡ファイルは対象外である。
before=$(git -C ~/dotfiles status --porcelain 2>/dev/null)

head_ "1. dotfiles の適用"
if mise bootstrap dotfiles apply --yes; then
  ok "適用が成功した"
else
  ng "適用が失敗した"
fi

head_ "2. 全エントリが applied であること"
status=$(mise bootstrap dotfiles status 2>&1)
echo "$status"
if [ -z "$status" ]; then
  ng "status が空である"
elif echo "$status" | grep -qv "applied"; then
  ng "applied でないエントリがある"
else
  ok "全エントリが applied である"
fi

head_ "3. 冪等性（2 回目が no-op であること）"
second=$(mise bootstrap dotfiles apply --yes 2>&1)
echo "$second"
if echo "$second" | grep -q "all files are applied"; then
  ok "2 回目は no-op である"
else
  ng "2 回目に変更が発生した"
fi

head_ "4. fish の起動時に stderr が出ないこと"
# 対話モードで検査する。fish -c では status is-interactive で囲われた
# ブロックが実行されず、そこに潜むエラーを取りこぼす。
err=$(TERM=${TERM:-xterm-256color} fish -ic exit 2>&1 >/dev/null)
if [ -z "$err" ]; then
  ok "stderr は空である"
else
  ng "stderr に出力がある:"
  printf '%s\n' "$err" | sed 's/^/       /'
fi

head_ "5. fish の主要な定義が読み込まれること"
missing=$(fish -ic '
  set -l ng
  for f in gsf ccusage fish_user_key_bindings
    functions -q $f; or set -a ng "function:$f"
  end
  for a in gs gau glp ..
    contains $a (abbr --list); or set -a ng "abbr:$a"
  end
  string join \n $ng
' 2>/dev/null)
if [ -z "$missing" ]; then
  ok "関数と abbr が揃っている"
else
  ng "読み込まれていない定義がある:"
  printf '%s\n' "$missing" | sed 's/^/       /'
fi

head_ "6. 適用がリポジトリへ生成物を流入させないこと"
after=$(git -C ~/dotfiles status --porcelain 2>/dev/null)
# 増えた行のみを失敗とする。減る分は問題ない。適用によって ~/.config/git
# （グローバル gitignore）が配置され、それまで未追跡だったものが無視対象に
# 変わるためである。検査したいのは生成物の新規流入である。
added=$(comm -13 <(printf '%s\n' "$before" | sort) <(printf '%s\n' "$after" | sort))
if [ -z "$added" ]; then
  ok "新たに現れたファイルはない"
else
  ng "適用によってリポジトリにファイルが現れた:"
  printf '%s\n' "$added" | sed 's/^/       /'
fi

head_ "結果"
if [ "$fail" -eq 0 ]; then
  echo "すべて成功"
else
  echo "失敗あり"
fi
exit "$fail"
