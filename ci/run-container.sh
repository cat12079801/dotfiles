#!/usr/bin/env bash
# ローカルの Linux コンテナで ci/verify.sh を実行する。
#
# リポジトリは読み取り専用でマウントし、コンテナ内で ~/dotfiles へ複製する。
# ro マウントは「適用がリポジトリへ書き戻さない」ことの担保でもある。
# 常用環境には一切触れない。

set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
IMAGE=${IMAGE:-debian:bookworm-slim}

echo "リポジトリ: $REPO_ROOT"
echo "イメージ:   $IMAGE"

docker run --rm -i \
  -e TERM=xterm-256color \
  -v "$REPO_ROOT:/src:ro" \
  "$IMAGE" bash -euo pipefail -c '
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq >/dev/null
    apt-get install -y -qq git curl ca-certificates fish ncurses-term >/dev/null

    # ro マウントから複製する。以降コンテナ内の ~/dotfiles だけを触る。
    cp -r /src "$HOME/dotfiles"

    export PATH="$HOME/.local/bin:$PATH"
    curl -fsSL https://mise.run | sh >/dev/null 2>&1
    mise --version

    bash "$HOME/dotfiles/ci/verify.sh"
  '
