#!/usr/bin/env bash
# Sync canonical skill (.agents) to vendor mirrors (.opencode/.claude/.gemini).
# Canonical source: .agents/skills/ai-memory-system/
# Usage: bash .agents/skills/ai-memory-system/scripts/sync-vendors.sh [--root DIR]
set -euo pipefail
ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done
SRC="$ROOT/.agents/skills/ai-memory-system"
[[ -d "$SRC" ]] || { echo "❌ canonical not found: $SRC" >&2; exit 1; }
for vendor in opencode claude gemini; do
  DST="$ROOT/.$vendor/skills/ai-memory-system"
  mkdir -p "$(dirname "$DST")"
  rm -rf "$DST"
  cp -r "$SRC" "$DST"
  echo "✅ synced → $DST"
done
echo "Done. Canonical: $SRC"
