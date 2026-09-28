#!/usr/bin/env bash
# render.sh <mermaid|svg> <input> <output.png>
# Renders a diagram source to a PNG so a maker subagent can LOOK at it.
#   mermaid -> mermaid.ink (URL-safe base64, no Chrome needed)
#   svg     -> rsvg-convert (Homebrew librsvg)
set -euo pipefail

kind="${1:-}"; in="${2:-}"; out="${3:-}"
if [[ -z "$kind" || -z "$in" || -z "$out" ]]; then
  echo "usage: render.sh <mermaid|svg> <input> <output.png>" >&2
  exit 2
fi

case "$kind" in
  mermaid)
    b64="$(base64 < "$in" | tr -d '\n' | tr '+/' '-_')"
    curl -fsS --max-time 60 "https://mermaid.ink/img/${b64}?type=png" -o "$out"
    ;;
  svg)
    rsvg-convert "$in" -o "$out" --background-color=white
    ;;
  *)
    echo "unknown kind: $kind (expected mermaid|svg)" >&2
    exit 2
    ;;
esac

file "$out"
