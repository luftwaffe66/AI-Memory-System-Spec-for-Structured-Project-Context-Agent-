#!/usr/bin/env bash
# Search memories by keyword/tag across PROJECT memory and GLOBAL memory.
# Usage: bash scripts/search-memory.sh <keyword...> [--root DIR] [--global-dir DIR]
# Default global dir: ~/.agents/memory
set -euo pipefail

ROOT="."
GLOBAL_DIR="$HOME/.agents/memory"
QUERY=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --global-dir) GLOBAL_DIR="$2"; shift 2 ;;
    *) QUERY+=("$1"); shift ;;
  esac
done

[[ ${#QUERY[@]} -gt 0 ]] || { echo "Usage: search-memory.sh <keyword...> [--root DIR] [--global-dir DIR]" >&2; exit 2; }

search_one() {
  local label="$1" dir="$2"
  [[ -d "$dir" ]] || { echo "($label: no memory at $dir)"; return 0; }
  echo "=== $label ($dir) ==="
  local found=0
  while IFS= read -r f; do
    [[ "$(basename "$f")" == "index.md" ]] && continue
    for q in "${QUERY[@]}"; do
      if grep -qiF "$q" "$f"; then
        echo "📄 $f"
        grep -m 1 -E '^# ' "$f" || true
        found=1
        break
      fi
    done
  done < <(find "$dir" -maxdepth 1 -name '*.md' | sort)
  if (( found == 0 )); then echo "(no matches)"; fi
  return 0
}

search_one "PROJECT" "$ROOT/memory"
echo ""
search_one "GLOBAL" "$GLOBAL_DIR"
