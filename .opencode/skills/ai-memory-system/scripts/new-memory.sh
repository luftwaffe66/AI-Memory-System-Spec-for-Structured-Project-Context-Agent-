#!/usr/bin/env bash
# Scaffold a new memory file from template + sync index.md.
# Usage:
#   bash scripts/new-memory.sh --slug auth-jwt --type refactor --scope auth/ --title "Auth Refactor to JWT" [--tags auth,jwt] [--template memory|decision|bug|refactor] [--root DIR]
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="."
SLUG=""; TYPE=""; SCOPE=""; TITLE=""; TAGS=""; TEMPLATE="memory"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug) SLUG="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    --scope) SCOPE="$2"; shift 2 ;;
    --title) TITLE="$2"; shift 2 ;;
    --tags) TAGS="$2"; shift 2 ;;
    --template) TEMPLATE="$2"; shift 2 ;;
    --root) ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

[[ -n "$SLUG" && -n "$TYPE" && -n "$SCOPE" && -n "$TITLE" ]] || {
  echo "Usage: new-memory.sh --slug <kebab> --type <feature|fix|refactor|decision|bug|infra> --scope <module> --title \"<Title>\" [--tags a,b] [--template memory|decision|bug|refactor] [--root DIR]" >&2
  exit 2
}

case "$TYPE" in
  feature|fix|refactor|decision|bug|infra) ;;
  *) echo "Invalid --type: $TYPE" >&2; exit 2 ;;
esac

DATE="$(date +%F)"; HM="$(date +%H-%M)"; HMC="$(date +%H:%M)"
FILE="$ROOT/memory/${DATE}_${HM}_${SLUG}.md"
TPL="$SKILL_DIR/references/${TEMPLATE}-template.md"
[[ -f "$TPL" ]] || TPL="$SKILL_DIR/references/memory-template.md"

mkdir -p "$ROOT/memory"
[[ -f "$ROOT/memory/index.md" ]] || printf '# MEMORY INDEX\n' > "$ROOT/memory/index.md"

# Fill template placeholders
sed -e "s|<Clear Title>|$TITLE|" \
    -e "s|<Decision Title>|$TITLE|" \
    -e "s|<Bug Title>|$TITLE|" \
    -e "s|<Refactor Title>|$TITLE|" \
    -e "s|YYYY-MM-DD|$DATE|g" \
    -e "s|HH:MM (24h)|$HMC|" \
    -e "s|HH:MM|$HMC|" \
    -e "s|feature \| fix \| refactor \| decision \| bug \| infra|$TYPE|" \
    -e "s|file/module/system affected|$SCOPE|" \
    -e "s|module/files affected|$SCOPE|" \
    -e "s|system/module affected|$SCOPE|" \
    -e "s|file/module affected|$SCOPE|" \
    -e "s|kebab-case, comma-separated.*|$TAGS|" \
    "$TPL" > "$FILE"

# Prepend entry under today's date header in index.md
ENTRY="- $HMC — $TITLE → ./memory/$(basename "$FILE")"
if grep -q "^## $DATE" "$ROOT/memory/index.md"; then
  awk -v entry="$ENTRY" -v date="## $DATE" '
    $0 == date { print; print entry; next } { print }
  ' "$ROOT/memory/index.md" > "$ROOT/memory/index.md.tmp" && mv "$ROOT/memory/index.md.tmp" "$ROOT/memory/index.md"
else
  # Insert new date section after "# MEMORY INDEX" (keeps descending if created now)
  awk -v entry="$ENTRY" -v date="## $DATE" '
    NR==1 { print; print ""; print date; print ""; print entry; next } { print }
  ' "$ROOT/memory/index.md" > "$ROOT/memory/index.md.tmp" && mv "$ROOT/memory/index.md.tmp" "$ROOT/memory/index.md"
fi

echo "✅ created: $FILE"
echo "✅ index synced"
echo "Next: edit $FILE, then bash $SKILL_DIR/scripts/validate-memory.sh --root $ROOT"
