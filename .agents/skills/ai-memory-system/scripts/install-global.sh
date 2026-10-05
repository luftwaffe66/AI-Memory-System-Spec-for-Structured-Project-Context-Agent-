#!/usr/bin/env bash
# Install ai-memory-system GLOBALLY for all agents (skill + /memory command).
# Covers: Codex (.agents), Claude Code (.claude), Gemini CLI (.gemini),
#         OpenCode (.config/opencode), Cursor (.cursor).
# Makes /memory available in EVERY project, not just this repo.
# Canonical source: <repo>/.agents/skills/ai-memory-system/
# Usage: bash install-global.sh [--source DIR] [--force]
set -euo pipefail

SOURCE="$(cd "$(dirname "$0")/../../../.." && pwd)"
FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --force) FORCE=1; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

SKILL_SRC="$SOURCE/.agents/skills/ai-memory-system"
OPENCODE_CMD="$SOURCE/.opencode/commands/memory.md"
CLAUDE_CMD="$SOURCE/.claude/commands/memory.md"
GEMINI_CMD="$SOURCE/.gemini/commands/memory.toml"

[[ -d "$SKILL_SRC" ]] || { echo "❌ skill not found: $SKILL_SRC" >&2; exit 1; }

install_skill() {
  local dst="$1"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && $FORCE -eq 0 ]]; then
    echo "⚠️  exists, use --force: $dst"
  else
    rm -rf "$dst"
    cp -r "$SKILL_SRC" "$dst"
    echo "✅ skill → $dst"
  fi
}

install_file() {
  local src="$1" dst="$2"
  [[ -f "$src" ]] || { echo "⚠️  missing source, skip: $src"; return 0; }
  mkdir -p "$(dirname "$dst")"
  cp -f "$src" "$dst"
  echo "✅ command → $dst"
}

# Skills (all agents)
install_skill "$HOME/.agents/skills/ai-memory-system"        # Codex · Gemini alias · OpenCode · universal
install_skill "$HOME/.claude/skills/ai-memory-system"        # Claude Code
install_skill "$HOME/.gemini/skills/ai-memory-system"        # Gemini CLI explicit
install_skill "$HOME/.config/opencode/skills/ai-memory-system" # OpenCode explicit
install_skill "$HOME/.cursor/skills/ai-memory-system"        # Cursor

# Slash commands
install_file "$OPENCODE_CMD" "$HOME/.config/opencode/commands/memory.md"  # OpenCode: /memory
install_file "$CLAUDE_CMD" "$HOME/.claude/commands/memory.md"              # Claude Code: /memory
install_file "$GEMINI_CMD" "$HOME/.gemini/commands/memory.toml"             # Gemini CLI: /memory

# Shared cross-project memory (GLOBAL layer, all repos/sessions)
mkdir -p "$HOME/.agents/memory"
if [[ ! -f "$HOME/.agents/memory/index.md" ]]; then
  printf '# GLOBAL MEMORY INDEX\n' > "$HOME/.agents/memory/index.md"
  echo "✅ global memory → $HOME/.agents/memory/index.md"
fi

echo ""
echo "Done. Restart your agent, then type /memory anywhere."
echo "Verify: ls ~/.agents/skills/ai-memory-system ~/.claude/skills/ai-memory-system ~/.gemini/skills/ai-memory-system ~/.config/opencode/skills/ai-memory-system"
