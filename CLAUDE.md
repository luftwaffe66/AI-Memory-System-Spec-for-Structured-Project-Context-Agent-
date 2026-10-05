# CLAUDE.md — Claude Code entrypoint

> Claude Code reads this file automatically. Canonical instructions live in `AGENTS.md`.

1. Read `AGENTS.md` (universal workflow: Recall → Act → Persist).
2. Load the skill: `.claude/skills/ai-memory-system/SKILL.md` (canonical mirror of `.agents/skills/ai-memory-system/SKILL.md`).
3. Slash commands: `/memory` (recall/save) and `/ai-memory-system` (skill, auto-invoked from its `description`).
4. After persisting a memory, run `bash .claude/skills/ai-memory-system/scripts/validate-memory.sh --root .`.
