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
├── ci/verify.sh                 適用の検査本体。ローカルと CI で共用する
├── ci/run-container.sh          ローカルで verify.sh をコンテナ実行する
├── .github/workflows/verify.yml Linux と macOS の 2 環境で検査する
├── .github/dependabot.yml       GitHub Actions の更新追従
│
├── gitconfig            → ~/.gitconfig
├── commit_template              gitconfig の commit.template から参照
├── zshrc                → ~/.zshrc  エージェントのツール実行が読む
├── tmux.conf            → ~/.tmux.conf
├── tmux/ip.sh                   tmux status-left から呼ばれる
├── ideavimrc            → ~/.ideavimrc
├── ssh/github.conf      → ~/.ssh/config.d/github.conf
│
└── config/
    ├── fish/            → ~/.config/fish   （symlink-each）
    │   ├── config.fish
    │   ├── fish_plugins
    │   └── functions/  fish_user_key_bindings.fish, ccusage.fish, gsf.fish
    ├── git/ignore       → ~/.config/git    グローバル gitignore
    ├── gwq/config.toml  → ~/.config/gwq    git worktree 管理 CLI
    ├── nvim/init.vim    → ~/.config/nvim   vim-plug 構成
    └── starship.toml    → ~/.config/starship.toml
```

`~/.ssh/config` 本体は管理下に置かない。業務・顧客のホスト名や踏み台の情報が
公開リポジトリへ載る経路を作らないため、および config を書き換えるツールが
リポジトリを汚すのを避けるためである。汎用の断片のみを `Include` で読ませる。
`~/.claude/settings.json` も同じ理由で管理外とする（組織の配布内容を含む）。

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

## 短縮記法の方針

`config.fish` では以下の使い分けをする。

- **alias**: コマンドそのものの差し替え（`vim`→`nvim`、`ls`→`lsd`、`grep --color`）。
  入力を別名へ展開する abbr は置き換えの意図と合わない
- **abbr**: 省略記法。入力時に実コマンドへ展開されるため履歴に実行内容が残り、
  `git` のサブコマンド補完もそのまま効く
- **関数**: パイプや条件分岐を含むもの（`gsf`）。`config/fish/functions/` に置く

追加・削除の判断は履歴の利用実績に基づく。fish 履歴は
`~/.local/share/fish/fish_history` にあり、`- cmd: ` の**7 文字**を除いた残りが
コマンド本体である（8 文字と誤ると先頭 1 文字が欠けて集計を誤る）。

## worktree の扱い

worktree は [gwq](https://github.com/d-kuro/gwq) で管理する。設定は
`config/gwq/config.toml`。`basedir` と `naming.template` が配置を決める。

gwq は独自のレジストリを持たず**ファイルシステムを走査する**ため、手動で作った
worktree も認識する。逆に言えば、`basedir` を実際の配置と一致させることが認識の条件である。

制約が 2 つある。

- **gwq はブランチ名のスラッシュを常に平坦化する。** `fix/foo` は `<repo>/fix-foo`
  になり入れ子にはできない。`sanitize_chars` を空にしても恒等変換を書いても変わらない
- **Claude Code のハーネスが作る worktree の名前は制御できない。**
  `WorktreeCreate` フックで置き換えられるが、`~/.claude/settings.json` の
  `allowManagedHooksOnly` が true であり、組織の管理設定でユーザ定義フックは
  ブロックされる。名前を揃える手段は無いので、`gwq cd` で名前を意識せず選ぶ

`gwq cd` のシェル統合は `[tasks.bootstrap]` が `~/.config/fish/conf.d/gwq.fish` を
生成することで成立する。**`completions/` に置いてはならない**。生成物には
`function gwq` ラッパーが含まれ、`completions/` は補完要求時にしか読まれないため
ラッパーが定義されず `gwq cd` が動かない。生成物の内容は生成時点の
`cd.launch_shell` に依存する。

## 検証

クリーンな環境へ適用できるかを検査する。検査本体は `ci/verify.sh` で、
ローカルのコンテナと CI の双方から同じものを実行する。

```sh
./ci/run-container.sh    # ローカル。リポジトリを ro でマウントする
```

CI は GitHub Actions で Linux コンテナと macOS runner の二段。本リポジトリは
public のため macOS runner も無料で使える。

検査を書き足すときの注意:

- **`fish -i`（対話モード）で検査する。** `fish -c` では `status is-interactive` で
  囲われたブロックが実行されず、そこに潜むエラーを取りこぼす。コンテナでは
  `TERM` の設定も要る
- **生成物の流入検査は「増えた行」だけを見る。** 適用によってグローバル gitignore が
  配置され、それまで未追跡だったものが無視対象に変わるため、減る分は正常である

現状の限界:

- Linux コンテナで検証できるのは symlink 配置・fish の起動・設定ファイルの構文まで。
  Homebrew の prefix、macOS keychain（`security`）、macOS defaults は検証できない
- macOS ジョブの `mise bootstrap packages status` は formula 名の妥当性を**検証できていない**。
  未導入と名前の誤りを区別せず、どちらも `missing` になる。実効性を持たせるには
  実際に導入するか `brew info` で個別に存在確認する必要がある
- `[tasks.bootstrap]` の safe-chain 導入は macOS 上で未検証である
  （既存環境では導入済みのため分岐に入らない）

## 手で更新するもの

dependabot は GitHub Actions のみを対象とする。以下は追従しないため手で上げる。

- **safe-chain のバージョンとハッシュ**（`mise.toml` の `[tasks.bootstrap]`）。
  セキュリティツールであり意図的に固定している。更新は版とハッシュを
  書き換えるコミットとして行う
- `[bootstrap.packages]` は全て `latest` のため追従は自動

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
