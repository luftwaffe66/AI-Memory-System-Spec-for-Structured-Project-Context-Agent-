#!/usr/bin/env bash
# Validate AI Memory System integrity: index sync, naming, structure, line limit.
# Usage: bash scripts/validate-memory.sh [--root DIR] [--strict]  (default DIR=., strict on)
set -euo pipefail

ROOT="."
STRICT=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --no-strict) STRICT=0; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

MEM="$ROOT/memory"
IDX="$MEM/index.md"
FAIL=0
WARN=0

err() { echo "❌ $*" >&2; FAIL=1; }
warn() { echo "⚠️  $*" >&2; WARN=1; }
ok()  { echo "✅ $*"; }

[[ -d "$MEM" ]] || { err "missing directory: $MEM"; exit 1; }
[[ -f "$IDX" ]] || { err "missing index: $IDX"; exit 1; }
ok "memory/ and index.md exist"

# 1. Dead links: every ./memory/*.md referenced in index must exist
while IFS= read -r ref; do
  target="$ROOT/${ref#./}"
  [[ -f "$target" ]] || err "dead link in index.md: $ref"
done < <(grep -oE '\./memory/[A-Za-z0-9._-]+\.md' "$IDX" || true)

# 2. Orphans: every memory/*.md (except index) must be referenced
while IFS= read -r f; do
  base="$(basename "$f")"
  grep -qF "$base" "$IDX" || err "orphan file not in index: $f"
done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)

# 3. Naming: YYYY-MM-DD_HH-MM_<slug>.md + valid date/time + kebab slug
while IFS= read -r f; do
  base="$(basename "$f")"
  if ! [[ "$base" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}_[a-z0-9-]+\.md$ ]]; then
    err "bad filename (expected YYYY-MM-DD_HH-MM_<slug>.md): $base"
    continue
  fi
  d="${base:0:10}"; t="${base:11:5}"
  date -d "$d" +%F >/dev/null 2>&1 || err "invalid date in filename: $base"
  hh="${t%-*}"; mm="${t#*-}"
  (( 10#$hh <= 23 && 10#$mm <= 59 )) || err "invalid time in filename: $base"
  # filename date must match Meta Date/Time inside file
  meta_date=$(grep -m1 -oE '^- Date: [0-9]{4}-[0-9]{2}-[0-9]{2}' "$f" | awk '{print $3}' || true)
  meta_time=$(grep -m1 -oE '^- Time: [0-9]{2}:[0-9]{2}' "$f" | awk '{print $3}' || true)
  [[ "$meta_date" == "$d" ]] || warn "Meta Date ($meta_date) != filename date ($d): $base"
  [[ "$meta_time" == "${t/-/:}" ]] || warn "Meta Time ($meta_time) != filename time (${t/-/:}): $base"
done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)

# 4. Line limit: 200 max
while IFS= read -r f; do
  lines=$(wc -l < "$f")
  (( lines > 200 )) && err "exceeds 200 lines ($lines): $f — shard it"
done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)

# 5. Duplicates in index
dupes=$(grep -oE '\./memory/[A-Za-z0-9._-]+\.md' "$IDX" | sort | uniq -d || true)
[[ -n "$dupes" ]] && err "duplicate entries in index.md: $dupes"

# 6. Descending date order (## YYYY-MM-DD headers)
dates=$(grep -oE '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' "$IDX" | awk '{print $2}' || true)
sorted=$(echo "$dates" | sort -r || true)
[[ "$dates" == "$sorted" ]] || err "index.md dates not in descending order"

# 7. Strict: required Meta fields + required sections + no placeholders
if (( STRICT == 1 )); then
  while IFS= read -r f; do
    for field in '^- Date: ' '^- Time: ' '^- Type: ' '^- Scope: ' '^- Tags: '; do
      grep -qE "$field" "$f" || err "missing Meta field ($field) in: $f"
    done
    # valid Type value
    tval=$(grep -m1 -oE '^- Type: [a-z]+' "$f" | awk '{print $3}' || true)
    case "$tval" in
      feature|fix|refactor|decision|bug|infra) ;;
      *) err "invalid Type '$tval' in: $f (expected feature|fix|refactor|decision|bug|infra)" ;;
    esac
    # required sections
    for sec in '^## Context' '^## Action' '^## Result' '^## Impact'; do
      grep -qE "$sec" "$f" || err "missing section ($sec) in: $f"
    done
    # forbidden placeholders (whole-line TBD/later/pending/TODO)
    if grep -qiE '^[> ]*(TBD|TODO|later|pending)\.?$' "$f"; then
      err "placeholder text found in: $f (fill concrete content)"
    fi
    # empty sections (header followed by another header or EOF)
    if awk '/^## /{if(prev){print "EMPTY:"prev} prev=$0; next} NF{prev=""} END{if(prev){print "EMPTY:"prev}}' "$f" | grep -q EMPTY; then
      warn "possibly empty section in: $f"
    fi
  done < <(find "$MEM" -maxdepth 1 -name '*.md' ! -name 'index.md' | sort)
fi

if (( FAIL == 0 )); then
  ok "memory system is valid"
  (( WARN == 1 )) && echo "⚠️  passed with warnings" >&2
else
  echo "⚠️  validation failed" >&2
  exit 1
fi
