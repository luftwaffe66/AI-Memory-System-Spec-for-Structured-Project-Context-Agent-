#!/usr/bin/env bash
# Validate AI Memory System integrity: index sync, naming, line limit, dead links.
# Usage: bash scripts/validate-memory.sh [--root DIR]  (default DIR=.)
set -euo pipefail

ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

MEM="$ROOT/memory"
IDX="$MEM/index.md"
FAIL=0

err() { echo "❌ $*" >&2; FAIL=1; }
ok()  { echo "✅ $*"; }

[[ -d "$MEM" ]] || { err "missing directory: $MEM"; exit 1; }
[[ -f "$IDX" ]] || { err "missing index: $IDX"; exit 1; }
ok "memory/ and index.md exist"

# 1. Check dead links: every ./memory/*.md referenced in index must exist
while IFS= read -r ref; do
  # ref like ./memory/2026-10-04_22-31_x.md
  target="$ROOT/${ref#./}"
  [[ -f "$target" ]] || err "dead link in index.md: $ref"
done < <(grep -oE '\./memory/[A-Za-z0-9._-]+\.md' "$IDX" || true)

# 2. Check orphan files: every memory/*.md (except index) must be referenced
while IFS= read -r f; do
  base="$(basename "$f")"
  grep -qF "$base" "$IDX" || err "orphan file not in index: $f"
done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)

# 3. Check naming convention
while IFS= read -r f; do
  base="$(basename "$f")"
  if ! [[ "$base" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}_[a-z0-9-]+\.md$ ]]; then
    err "bad filename (expected YYYY-MM-DD_HH-MM_<slug>.md): $base"
  fi
done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)

# 4. Check 200-line limit
while IFS= read -r f; do
  lines=$(wc -l < "$f")
  (( lines > 200 )) && err "exceeds 200 lines ($lines): $f — shard it"
done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)

# 5. Check duplicates in index
dupes=$(grep -oE '\./memory/[A-Za-z0-9._-]+\.md' "$IDX" | sort | uniq -d || true)
[[ -n "$dupes" ]] && err "duplicate entries in index.md: $dupes"

# 6. Check descending date order (## YYYY-MM-DD headers)
dates=$(grep -oE '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' "$IDX" | awk '{print $2}' || true)
sorted=$(echo "$dates" | sort -r || true)
[[ "$dates" == "$sorted" ]] || err "index.md dates not in descending order"

if (( FAIL == 0 )); then
  ok "memory system is valid"
else
  echo "⚠️  validation failed" >&2
  exit 1
fi
