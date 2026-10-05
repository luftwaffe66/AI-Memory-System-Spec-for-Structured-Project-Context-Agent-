---
description: Recall project memory or save a new entry (ai-memory-system skill)
---
Load and follow the skill `ai-memory-system` NOW (skill({ name: "ai-memory-system" })).

User input: $ARGUMENTS

Rules:
- If user input is empty or asks to recall/history/why/what changed → do RECALL: read PROJECT `memory/index.md` AND GLOBAL `~/.agents/memory/index.md` (shared across ALL repos/sessions), load only relevant files, answer with rationale + impact + file links. Helper: `bash $SKILL_DIR/scripts/search-memory.sh <keyword> --root .`.
- If user input describes a change/decision/fix/refactor (or says save/remember/guardar) → do PERSIST: route it — 📁 PROJECT (`./memory/`, default, repo-specific) or 🌍 GLOBAL (`~/.agents/memory/`, reusable in other repos; scaffold with `--global`). Sync that layer's `index.md` (descending, no duplicates), then validate (`validate-memory.sh --root .` or `--memdir ~/.agents/memory`).
- Locate the skill dir first (canonical order): `./.agents/skills/ai-memory-system`, `./.opencode/skills/ai-memory-system`, `./.claude/skills/ai-memory-system`, `./.gemini/skills/ai-memory-system`, `~/.agents/skills/ai-memory-system`, `~/.config/opencode/skills/ai-memory-system`, `~/.claude/skills/ai-memory-system`, `~/.gemini/skills/ai-memory-system`. Call it $SKILL_DIR.
- Preferred creation: `bash $SKILL_DIR/scripts/new-memory.sh --slug <kebab> --type <feature|fix|refactor|decision|bug|infra> --scope <module> --title "<Title>" --tags <a,b> --template <memory|decision|bug|refactor> --root .`.
- Preferred validation: `bash $SKILL_DIR/scripts/validate-memory.sh --root .`.
- Templates live in `$SKILL_DIR/references/` (memory, decision, bug, refactor, index).
- Every entry needs Meta (Date, Time 24h, Type, Scope, Tags kebab-case), sections Context/Action/Result/Impact (+ Follow-up if risks). No TBD/later/pending without context. Max 200 lines.
- If input is ambiguous, recall first, then ask whether to save a new memory.

Examples:
- `/memory` → show recent index + suggest relevant entries
- `/memory why JWT?` → recall auth decision
- `/memory save migrated auth to JWT, refactor, scope auth/, tags auth,jwt` → persist new entry
