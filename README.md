# my configs

macOS (Apple Silicon) / fish + tmux + nvim の個人用 dotfiles。

## セットアップ

前提: [Homebrew](https://brew.sh) と [mise](https://mise.jdx.dev) が導入済みであること。
`mise bootstrap` には mise 2026.6.6 以降が要る。

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
4. `[tasks.bootstrap]` — safe-chain の導入、fish プラグインの同期、gwq のシェル統合の生成

適用せずに内容だけ確認する場合は `mise bootstrap --dry-run`。
配置状況の確認は `mise bootstrap dotfiles status`。

### 手で行う必要があるもの

- tmux のプラグイン導入 — tmux 内で `C-b I`
- SSH の多重化を有効にする — `~/.ssh/config` の先頭付近（OrbStack の Include の後、
  最初の `Host` ブロックより前）に次の 1 行を足す。`~/.ssh/config` 本体は
  業務・顧客のホスト名を含み得るため管理下に置いていない

  ```
  Include ~/.ssh/config.d/*.conf
  ```

## 検証

クリーンな環境へ適用できるかを検査する。ローカルでは Linux コンテナ内で実行され、
常用環境には触れない。

```sh
./ci/run-container.sh
```

同じ検査を GitHub Actions でも Linux と macOS の 2 環境で実行している。
検査内容は `ci/verify.sh` を参照。

## 構成の詳細

設計判断と既知の制約は [CLAUDE.md](CLAUDE.md) に記載している。
