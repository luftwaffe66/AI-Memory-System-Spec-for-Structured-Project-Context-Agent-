---
description: Recall project memory or save a new entry (ai-memory-system skill)
---
Load and follow the skill `ai-memory-system` NOW (skill({ name: "ai-memory-system" })).

User input: $ARGUMENTS

Rules:
- If user input is empty or asks to recall/history/why/what changed → do RECALL: read `memory/index.md`, load only relevant `memory/*.md` files, answer with rationale + impact + file links.
- If user input describes a change/decision/fix/refactor (or says save/remember/guardar) → do PERSIST: create `memory/YYYY-MM-DD_HH-MM_<slug>.md` from the right template (`memory|decision|bug|refactor`), sync `memory/index.md` (descending, no duplicates), then run `bash .opencode/skills/ai-memory-system/scripts/validate-memory.sh --root .`.
- Preferred creation method: `bash .opencode/skills/ai-memory-system/scripts/new-memory.sh --slug <kebab> --type <feature|fix|refactor|decision|bug|infra> --scope <module> --title "<Title>" --tags <a,b> --template <memory|decision|bug|refactor>`.
- Every entry needs Meta (Date, Time 24h, Type, Scope, Tags kebab-case), sections Context/Action/Result/Impact (+ Follow-up if risks). No TBD/later/pending without context. Max 200 lines.
- If input is ambiguous, recall first, then ask whether to save a new memory.

Examples:
- `/memory` → show recent index + suggest relevant entries
- `/memory why JWT?` → recall auth decision
- `/memory save migrated auth to JWT, refactor, scope auth/, tags auth,jwt` → persist new entry
