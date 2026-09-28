#!/usr/bin/env bash
# 本地预览学习站点。
# 该 Hugo 站点（FixIt 主题）固定在 CI 用的 Hugo 0.123.8 上构建：
# 更高版本的 Hugo 移除了主题用到的 getJSON，会直接报错。
# 本脚本会在本地缓存里准备好 0.123.8，然后跑 `hugo server`。
set -euo pipefail

CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/learner/site.config"
# shellcheck disable=SC1090
source "$CONFIG"
: "${SITE_DIR:?SITE_DIR 未在 site.config 里设置}"

HUGO_VERSION="0.123.8"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/hugo/$HUGO_VERSION"
BIN="$CACHE/hugo"

if [[ ! -x "$BIN" ]]; then
  mkdir -p "$CACHE"
  echo "下载 Hugo v$HUGO_VERSION (extended, darwin-universal)..."
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_darwin-universal.tar.gz" -o "$tmp/hugo.tgz"
  tar xzf "$tmp/hugo.tgz" -C "$CACHE" hugo
  rm -rf "$tmp"
fi

cd "$SITE_DIR"
exec "$BIN" server "$@"
