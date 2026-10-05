---
description: Recall project memory or save a new entry (ai-memory-system skill)
---
Read and follow the skill file NOW: `.agents/skills/ai-memory-system/SKILL.md`
(fallbacks: `.claude/skills/ai-memory-system/SKILL.md`, `.opencode/skills/ai-memory-system/SKILL.md`, `.gemini/skills/ai-memory-system/SKILL.md`, `~/.agents/skills/ai-memory-system/SKILL.md`, `~/.claude/skills/ai-memory-system/SKILL.md`).

User input: $ARGUMENTS

Rules:
- If user input is empty or asks to recall/history/why/what changed → do RECALL: read PROJECT `memory/index.md` AND GLOBAL `~/.agents/memory/index.md` (shared across ALL repos/sessions), load only relevant files, answer with rationale + impact + file links.
- If user input describes a change/decision/fix/refactor (or says save/remember/guardar) → do PERSIST: route it — 📁 PROJECT (`./memory/`, default) or 🌍 GLOBAL (`~/.agents/memory/`, reusable in other repos). Sync that layer's `index.md` (descending, no duplicates), then validate with the skill's `scripts/validate-memory.sh`.
- Every entry needs Meta (Date, Time 24h, Type, Scope, Tags kebab-case), sections Context/Action/Result/Impact (+ Follow-up if risks). No TBD/later/pending without context. Max 200 lines.
- If input is ambiguous, recall first, then ask whether to save a new memory.

Examples:
- `/memory` → show recent index + suggest relevant entries
- `/memory why JWT?` → recall auth decision
- `/memory save migrated auth to JWT, refactor, scope auth/` → persist new entry
