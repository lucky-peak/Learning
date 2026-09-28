#!/usr/bin/env bash
# 把工作区的知识树发布到复习站点。
#   knowledge/  ->  $SITE_DIR/content/learning/
# 排除 _map.md（学习者内部状态，不发布；保留在知识树里）。
# 使用 --delete，让站点内容与知识树保持一致。
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # .pi/scripts
WS="$(cd "$HERE/../.." && pwd)"                        # workspace root
CONFIG="$HERE/../learner/site.config"
# shellcheck disable=SC1090
source "$CONFIG"
: "${SITE_DIR:?SITE_DIR 未在 site.config 里设置}"

SRC="$WS/knowledge"
DEST="$SITE_DIR/content/learning"

[[ -d "$SRC" ]]  || { echo "找不到知识树：$SRC" >&2; exit 1; }
[[ -d "$DEST" ]] || { echo "找不到站点 Learning 目录：$DEST" >&2; exit 1; }

rsync -a --delete --exclude '_map.md' "$SRC/" "$DEST/"

echo "✅ 已发布：$SRC  ->  $DEST"
echo "下一步："
echo "  cd \"$SITE_DIR\" && git add -A && git commit -m \"publish learning\" && git push"
