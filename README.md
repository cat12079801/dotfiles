# my configs

## セットアップ

前提: [Homebrew](https://brew.sh) と [mise](https://mise.jdx.dev) が導入済みであること。

```sh
git clone git@github.com:cat12079801/dotfiles.git ~/dotfiles
cd ~/dotfiles
mise trust
mise bootstrap
```

`mise bootstrap` が以下を順に収束させる。冪等であり、再実行しても差分のみが適用される。

1. `[bootstrap.packages]` — 依存する Homebrew パッケージの導入
2. `[bootstrap.repos]` — tpm（tmux プラグインマネージャ）の clone
3. `[dotfiles]` — 設定ファイルの symlink 配置
4. `[tasks.bootstrap]` — fisher と fish プラグインの同期

適用せずに内容だけ確認する場合は `mise bootstrap --dry-run`。
配置状況の確認は `mise bootstrap dotfiles status`。

なお tmux のプラグインは初回のみ tmux 内で `C-b I` を押して導入する。
