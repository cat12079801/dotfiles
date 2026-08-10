# dotfiles

macOS (Apple Silicon) / fish + tmux + nvim を中心とした個人用 dotfiles。

## このドキュメントの記載方針

**現在の状態と、今後の判断に資する情報のみを記す。**

- 過去の経緯・移行履歴（「◯◯ から移行済み」「以前は △△ を使っていた」等）は書かない
- 例外は、その経緯を知らないと現時点の判断を誤る場合に限る。
  その場合も「過去にこうだった」ではなく「今こうなっているので、こう扱う」の形で書く
- 解消済みの問題は記述ごと削除する。履歴は git log に残るため二重に持たない

## 前提環境

- OS: macOS (darwin, arm64)
- ログインシェル: fish
- パッケージ管理: Homebrew (`/opt/homebrew`)
- ランタイム管理・デプロイ: mise（`mise bootstrap` に **2026.6.6 以降**が必要）
- リポジトリ配置: `~/dotfiles`

## 構成

```
~/dotfiles/
├── mise.toml                    デプロイ定義。これが唯一の配置の正である
├── README.md                    セットアップ手順
│
├── gitconfig            → ~/.gitconfig
├── commit_template              gitconfig の commit.template から参照
├── zshrc                → ~/.zshrc  エージェントのツール実行が読む
├── tmux.conf            → ~/.tmux.conf
├── tmux/ip.sh                   tmux status-left から呼ばれる
├── ideavimrc            → ~/.ideavimrc
│
└── config/
    ├── fish/            → ~/.config/fish   （symlink-each）
    │   ├── config.fish
    │   ├── fish_plugins
    │   └── functions/  fish_user_key_bindings.fish, ccusage.fish
    ├── git/ignore       → ~/.config/git    グローバル gitignore
    ├── nvim/init.vim    → ~/.config/nvim   vim-plug 構成
    └── starship.toml    → ~/.config/starship.toml
```

## デプロイ

配置はすべて `mise.toml` の宣言で決まる。手で `ln -s` してはならない。

```sh
cd ~/dotfiles
mise bootstrap              # 全ステップを収束させる（冪等）
mise bootstrap --dry-run    # 適用せず内容だけ確認
mise bootstrap dotfiles status
```

`mise bootstrap` は `[bootstrap.packages]` → `[bootstrap.repos]` → `[dotfiles]` →
`[tasks.bootstrap]` の順に収束させる。リポジトリローカルの `mise.toml` がそのまま
設定として読まれるため、`~/.config/mise/config.toml` への配線は不要である。
clone 直後は `mise trust` が要る。

### `~/.config/fish` を symlink-each にしている理由

fisher・fish 本体・各種 CLI（OrbStack 等）が `completions/` `conf.d/` `fish_variables`
を fish の設定ディレクトリへ書き込む。ここをディレクトリごと symlink にすると、
それらの書き込みがリンクを貫通してリポジトリを汚染する。

`symlink-each` は実ディレクトリを作ったうえで管理下のファイルのみを個別リンクするため、
生成物は `~/.config/fish` 側に留まる。**この判断を覆してディレクトリリンクに戻してはならない。**

なお `symlink-each` がリンクするのは git の追跡状況ではなく **ソースディレクトリに
物理的に存在するファイル**である。リポジトリに生成物を置くと、それも配布対象になる。

### safe-chain の扱い

`safe-chain setup` を実行してはならない。config.fish 内の読み込み行を検出して
**末尾へ移動する形で書き換える**ため、リポジトリへの symlink である config.fish が
汚れる。シェルへの配線は config.fish 側で管理しており、setup は不要である。

`[tasks.bootstrap]` は公式インストーラを使うが、インストーラ自身が末尾で setup を
走らせるため、使い捨ての `HOME` を与えて書き込みを隔離している。

## 既知の問題

### P1. config.fish 内の不整合

- `set PATH ~/.asdf/shims $PATH` — asdf 未インストールのため、存在しないディレクトリを PATH に積んでいる
- `if [ "(type lsd >/dev/null 2>&1)" ]` — **コマンド置換が `$(...)` になっておらず常に真**になる壊れた条件式
- alias が 32 個ある一方 abbr は 0 個。git 系の省略記法まで alias（＝function 生成）で書かれており、
  履歴に実コマンドが残らず、`git` のサブコマンド補完も効かない

## 今後の方針

### 方針 A: alias を abbr へ移行する

- **abbr へ**: git 系 26 個（`ga` `gcm` `gd` `gl` `gs` 等）。展開されるため履歴に実コマンドが残り、補完も効く
- **alias のまま**: `ls`→`lsd`、`vim`→`nvim`、`grep --color`。省略記法ではなくコマンド自体の置換であるため
- **関数化**: `gsf`（`git branch | fzf | xargs git switch`）
- 併せて P1 の壊れた `lsd` 判定を修正する。`command -q lsd` が正しい書き方である

### 方針 B: gwq の導入

[d-kuro/gwq](https://github.com/d-kuro/gwq) は git worktree 管理 CLI。
`~/CLAUDE.md` の worktree 規則 `~/workspace/worktrees/<repo-name>/<branch-name>` を
`worktree.basedir` + `naming.template` にそのまま写せる。

- `brew:d-kuro/tap/gwq` を `[bootstrap.packages]` に追加
- 設定 `~/.config/gwq/config.toml` を `[dotfiles]` エントリに追加
- 補完は `gwq completion fish` の**生成物**であるため、リポジトリではなく
  `~/.config/fish/completions/` に置く。`[dotfiles]` で管理してはならない
- 導入後は `gsf` 相当のワークフローが不要になる可能性がある

### 方針 C: コンテナおよび CI での適用検証

クリーンな環境に本 dotfiles を適用できるかを継続的に確認する。以下は検証済みである。

- Linux コンテナ（`debian:bookworm-slim` + mise 公式インストーラ）で
  `mise bootstrap dotfiles apply` が動作し、`status` が全件 applied になること
- リポジトリを読み取り専用でマウントしても適用が完了すること（＝リポジトリへ書き戻さない）
- ツールが何も入っていない環境でも fish 起動時の stderr が空であること

構成の方向性:

- **ローカル**: リポジトリを `ro` でマウントしたコンテナに適用し、fish 起動時の
  stderr が空であること・`mise bootstrap dotfiles status` が全件 applied であることを検査する
- **CI**: GitHub Actions。本リポジトリは public のため macOS runner も無料で使える。
  Linux コンテナジョブで高速に回し、macOS runner で実環境に近い検証を行う二段構成が妥当
- 2 回連続実行して 2 回目が no-op になること（冪等性）も検査項目に含める

検査は必ず **`fish -i`（対話モード）** で行う。`fish -c` では
`status is-interactive` で囲われたブロックが実行されず、
そこに潜むエラーを取りこぼす。コンテナでは `TERM` の設定も要る。

制約:

- Linux コンテナで検証できるのは symlink 配置・fish の起動・設定ファイルの構文まで。
  Homebrew の prefix、macOS keychain（`security` コマンド）、macOS defaults は検証できない
- `[tasks.bootstrap]` の safe-chain 導入は Linux コンテナで検証済みだが、
  macOS 上での新規導入は未検証である（既存環境では導入済みのため分岐に入らない）

## このリポジトリの Git 運用

個人のツール置き場であり、共同作業者はいない。したがって以下を適用する。

- **デフォルトブランチは `main`**
- **`main` へ直接コミット・push してよい。** ブランチを切る必要も PR を作る必要もない
- 競合の回避や履歴の整形に配慮する必要はない

これは本リポジトリ限定の運用であり、`~/CLAUDE.md` のブランチ命名規則および PR 作成規則は
本リポジトリには適用しない。

## 作業上の注意

- 実環境は `~/dotfiles` にあり、worktree 側の編集は symlink 先に反映されない。
  リンクの配置や `mise bootstrap` の実行は `~/dotfiles` 側で行うこと
- 配置を変えるときは `mise.toml` を編集し `mise bootstrap dotfiles apply` を実行する。
  手動の `ln -s` は `mise.toml` との乖離を生むため禁止する
- リポジトリに生成物が紛れ込んでいないか `git status` で確認する。
  `symlink-each` はソースに物理的に存在するファイルをすべて配布対象にするため、
  生成物を置いたまま適用すると他環境へ伝播する
