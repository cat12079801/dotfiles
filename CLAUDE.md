# dotfiles

macOS (Apple Silicon) / fish + tmux + nvim を中心とした個人用 dotfiles。
本ドキュメントは現状の構造・既知の問題・整理方針を記録したものである。

## 前提環境

- OS: macOS (darwin, arm64)
- ログインシェル: fish 4.6.0
- パッケージ管理: Homebrew (`/opt/homebrew`)
- ランタイム管理: mise（`asdf` および `pyenv` からは移行済み）
- リポジトリ配置: `~/dotfiles`

## 現在の構造

```
~/dotfiles/
├── install.sh                   デプロイスクリプト（ln -sf の羅列）
├── pyenv-install.sh             Python 環境構築（旧）
├── README.md                    1 行のみ
├── .gitignore
│
├── gitconfig            → ~/.gitconfig
├── commit_template              gitconfig の commit.template から参照
├── git-templates/hooks/ → ~/.git-templates（中身は .gitkeep のみ）
├── tmux.conf            → ~/.tmux.conf
├── tmux/ip.sh                   tmux status-left から呼ばれる
├── ideavimrc            → ~/.ideavimrc
├── alacritty.yml        → ~/.alacritty.yml
│
└── config/              → ~/.config 配下へ個別リンク
    ├── fish/config.fish, fish_plugins, functions/fish_user_key_bindings.fish
    ├── git/ignore               グローバル gitignore
    ├── nvim/init.vim            vim-plug 構成
    ├── starship.toml
    ├── alacritty/              （.gitkeep のみ）
    └── sxiv/exec/key-handler
```

デプロイ方式はリポジトリ全体ではなく **個別ファイル / ディレクトリの symlink**。

## 既知の問題

### P1. リポジトリと実環境の乖離（未コミット変更）

`~/dotfiles` 本体に未コミットの変更が滞留している。

- `gitconfig`: `editor = vim` / `url.insteadOf` / gh credential helper が追加済み（インデントがタブとスペースで混在）
- `config/fish/config.fish`: safe-chain init、Asana MCP の keychain 読み出し、`~/Library/Python/3.9/bin` の PATH 追加
- `bashrc`: **未追跡**。にもかかわらず `~/.bashrc` は既にこのファイルへリンクされている

### P2. install.sh が壊れている

- `vimrc` / `bash_profile` をリンクしているが、いずれもリポジトリに存在しない
  → `~/.vimrc` と `~/.bash_profile` は**リンク切れ**状態
- スクリプトの 2/3 がコメントアウトされた死骸である

### P3. `~/.config` へのリンク事故

`ln -sf ~/dotfiles/config ~/.config` が、`~/.config` を既存ディレクトリとして扱ったため、
**その配下に `config` という名前のリンクを作ってしまっている**。

```
~/.config/config -> ~/dotfiles/config     # 誰も参照していない死んだリンク
~/.config/fish   -> ~/dotfiles/config/fish
~/.config/git    -> ~/dotfiles/config/git
```

実際の配線は後から手作業で貼り直された個別リンクであり、install.sh の記述とは一致しない。

### P4. fish の生成物がリポジトリに流入している

`config/fish` をディレクトリごと symlink しているため、fisher や fish 自身が生成する
`completions/` `conf.d/` `fish_variables` がリポジトリ内に書き込まれる。
これを `config/fish/.gitignore` のホワイトリスト（`*` + `!config.fish` `!fish_plugins`）で
抑え込んでおり、結果として**自作の関数まで管理外に漏れている**。

- 管理外に漏れている自作物: `functions/ccusage.fish`, `conf.d/fish_frozen_*.fish`
- 除外して正しいもの: `functions/__fzf_*.fish`, `functions/fisher.fish`（fisher 生成物）

### P5. 使っていないツールの設定が残存

| 対象 | 状態 |
|---|---|
| `alacritty.yml`, `config/alacritty/` | alacritty 未インストール。yml 形式は 0.13 以降廃止済みで、`~/.alacritty.yml` も旧ロケーション |
| `config/sxiv/` | sxiv 未インストール（Linux 用画像ビューア） |
| `pyenv-install.sh` | pyenv 未インストール。neovim2/3 virtualenv 前提で完全に陳腐化 |
| `git-templates/` | 中身が空（`.gitkeep` のみ） |
| `.gitignore` の dein 関連除外 | dein → vim-plug に移行済みで、参照先ファイルはいずれも不在 |

### P6. config.fish 内の不整合

- `set PATH ~/.asdf/shims $PATH` — asdf 未インストール（mise へ移行済み）
- `if [ "(type lsd >/dev/null 2>&1)" ]` — **コマンド置換が `$(...)` になっておらず常に真**になる壊れた条件式
- alias が 32 個ある一方 abbr は 0 個。git 系の省略記法まで alias（＝function 生成）で書かれており、
  履歴に実コマンドが残らず、`git` のサブコマンド補完も効かない

## 整理方針

### 方針 A: デプロイを `mise bootstrap` へ移行する

install.sh を廃し、`mise bootstrap` の宣言的定義に置き換える。P2 / P3 / P4 を構造的に解消できる。

- symlink 展開 → `[dotfiles]`
- tpm の git clone → `[bootstrap.repos]`
- Homebrew パッケージ → `[bootstrap.packages]`

**最大の利点は `symlink-each` モード**である。ディレクトリ構造を再現したうえで管理下のファイルだけを
個別リンクするため、fish の生成物がリポジトリに流入しなくなり、P4 の .gitignore ハックを廃止できる。

想定する定義:

```toml
# ~/dotfiles/mise.toml
[settings]
dotfiles.root = "~/dotfiles"
dotfiles.default_mode = "symlink"

[dotfiles]
"~/.gitconfig"            = "gitconfig"
"~/.tmux.conf"            = "tmux.conf"
"~/.ideavimrc"            = "ideavimrc"
"~/.git-templates"        = "git-templates"
"~/.config/git"           = "config/git"
"~/.config/nvim"          = "config/nvim"
"~/.config/starship.toml" = "config/starship.toml"
"~/.config/fish"          = { source = "config/fish", mode = "symlink-each" }
```

前提と未検証事項:

- `mise bootstrap` は **v2026.6.6 で導入**。ローカルは 2026.4.18 のため**アップグレードが必須**
- トップレベル `mise dotfiles` は deprecated。`mise bootstrap dotfiles` を使う
- 鶏卵問題: `[dotfiles]` は mise が読む config に書く必要がある。
  `cd ~/dotfiles && mise bootstrap` でリポジトリ内 `mise.toml` をローカル config として拾えるかは **未検証**。
  拾えない場合は `~/.config/mise/config.toml` への手動 symlink 1 本のみが初回作業として残る
- `[bootstrap.repos]` / `[bootstrap.packages]` の正確なキー名は公式ドキュメントに TOML 例がなく **未検証**。
  実装時に `--dry-run` で確認すること

### 方針 B: 死んだ設定を削除する

P5 の対象（alacritty, sxiv, pyenv-install.sh, 空の git-templates, dein 関連の除外行）を削除する。
`~/.fzf` の clone も不要（brew 版 fzf と fisher の `jethrokuan/fzf` で足りている）。
tpm の clone のみ `[bootstrap.repos]` へ引き継ぐ。

### 方針 C: 未コミット差分を取り込む

P1 の差分をコミットする。`bashrc` は追跡対象に含めるか、`~/.bashrc` のリンクごと廃止するかを決める。

### 方針 D: alias を abbr へ移行する（fish 4.6.0）

- **abbr へ**: git 系 26 個（`ga` `gcm` `gd` `gl` `gs` 等）。展開されるため履歴に実コマンドが残り、補完も効く
- **alias のまま**: `ls`→`lsd`、`vim`→`nvim`、`grep --color`。省略記法ではなくコマンド自体の置換であるため
- **関数化**: `gsf`（`git branch | fzf | xargs git switch`）
- 併せて P6 の壊れた `lsd` 判定を修正する

### 方針 E: gwq の導入（展望）

[d-kuro/gwq](https://github.com/d-kuro/gwq) は git worktree 管理 CLI。
`~/CLAUDE.md` の worktree 規則 `~/workspace/worktrees/<repo-name>/<branch-name>` を
`worktree.basedir` + `naming.template` にそのまま写せる。

- 設定は `~/.config/gwq/config.toml` → `[dotfiles]` エントリに追加して管理下に置く
- fish 補完は `gwq completion fish > ~/.config/fish/completions/gwq.fish` で**生成物**が出るため、
  **方針 A（symlink-each 化）を先に済ませないと再びリポジトリを汚す**
- 導入後は `gsf` 相当のワークフローが不要になる可能性がある

## 実施順序

1. **方針 A の前提整備** — `brew upgrade mise` → `mise bootstrap --dry-run` で挙動と未検証事項を確認
2. **方針 C** — 未コミット差分の取り込み
3. **方針 B** — 死んだ設定の削除
4. **方針 A** — `mise.toml` へ移行、install.sh を廃止
5. **方針 D / E** — abbr 移行、gwq 導入

方針 E は方針 A の完了に依存する。

## このリポジトリの Git 運用

個人のツール置き場であり、共同作業者はいない。したがって以下を適用する。

- **デフォルトブランチは `main`**
- **`main` へ直接コミット・push してよい。** ブランチを切る必要も PR を作る必要もない
- 競合の回避や履歴の整形に配慮する必要はない

これは本リポジトリ限定の運用であり、`~/CLAUDE.md` のブランチ命名規則および PR 作成規則は
本リポジトリには適用しない。

## 作業上の注意

- 実環境は `~/dotfiles` にあり、worktree 側の編集は symlink 先に反映されない。
  リンクの張り替えや `mise bootstrap` の実行は `~/dotfiles` 側の状態を前提に検証すること
- symlink を張り替える変更は、実行前に必ず `--dry-run` または `ls -la` で現在の宛先を確認する
  （P3 は宛先未確認のまま `ln -sf` を実行したことが原因である）
