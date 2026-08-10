# zsh は対話シェルとしては使っていない。ただしエージェント（Claude Code 等）が
# ツール実行に zsh を使うため、本ファイルはそれらの実行環境として効く。
#
# Safe-chain。npm / npx / yarn 等をラップして検査を挟む。
# エージェントがパッケージを導入する経路を保護するのが主目的である。
# 導入は mise.toml の [tasks.bootstrap] が担う。
if [ -f ~/.safe-chain/scripts/init-posix.sh ]; then
  . ~/.safe-chain/scripts/init-posix.sh
fi
