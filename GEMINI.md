# GEMINI.md — Gemini CLI entrypoint

> Gemini CLI reads this file automatically. Canonical instructions live in `AGENTS.md`.

1. Read `AGENTS.md` (universal workflow: Recall → Act → Persist).
2. Load the skill: `.gemini/skills/ai-memory-system/SKILL.md` (canonical mirror of `.agents/skills/ai-memory-system/SKILL.md`; `.agents/skills/` also works as alias).
3. Slash command: `/memory` (see `.gemini/commands/memory.toml`). Manage skills with `/skills list`.
4. After persisting a memory, run `bash .gemini/skills/ai-memory-system/scripts/validate-memory.sh --root .`.
