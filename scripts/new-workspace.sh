#!/usr/bin/env bash
# 从本 harness 复制出一个新的学习工作区。
#
#   scripts/new-workspace.sh <目标目录> [--force]
#
# 例：
#   scripts/new-workspace.sh ~/learn/kubernetes
#   scripts/new-workspace.sh ~/learn/english-writing
#
# 会复制 pi 配置（.pi/）、AGENTS.md、README、scripts，并建好 viz/。
# 不复制 references/（本地资料）、.pi/npm 与 .pi/git（pi 会在首次运行时重装）。
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DEST=""
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help) echo "usage: new-workspace.sh <目标目录> [--force]"; exit 0 ;;
    *) DEST="$arg" ;;
  esac
done

if [[ -z "$DEST" ]]; then
  echo "usage: new-workspace.sh <目标目录> [--force]" >&2
  exit 2
fi

# 展开 ~ 和相对路径
DEST="${DEST/#\~/$HOME}"
if [[ "$DEST" != /* ]]; then
  DEST="$(pwd)/$DEST"
fi

if [[ -e "$DEST" && "$FORCE" -ne 1 ]]; then
  if [[ -n "$(ls -A "$DEST" 2>/dev/null)" ]]; then
    echo "目标目录已存在且非空：$DEST" >&2
    echo "加 --force 可覆盖合并。" >&2
    exit 1
  fi
fi

mkdir -p "$DEST"

if command -v rsync >/dev/null 2>&1; then
  rsync -a \
    --exclude '.git' \
    --exclude 'references' \
    --exclude '.pi/npm' \
    --exclude '.pi/git' \
    --exclude 'viz/*' \
    "$HARNESS_DIR/" "$DEST/"
else
  # 没有 rsync 时的兜底：整体复制再删掉不该带的
  cp -R "$HARNESS_DIR/." "$DEST/"
  rm -rf "$DEST/.git" "$DEST/references" "$DEST/.pi/npm" "$DEST/.pi/git"
  rm -rf "$DEST/viz"/* 2>/dev/null || true
fi

mkdir -p "$DEST/viz"
touch "$DEST/viz/.gitkeep"

cat <<EOF
✅ 已创建学习工作区：$DEST

下一步：
  1. 编辑 $DEST/.pi/learner/site.config 设置 SITE_DIR（学习站点仓库路径），
     不发布站点的话可以留空。
  2. cd "$DEST" && pi
  3. 进去后直接说「教我 <主题>」。

首次启动会问是否信任本项目（因为装了项目级 pi 包），选信任；
pi 会自动安装 pi-web-access 和 pi-subagents。
EOF
