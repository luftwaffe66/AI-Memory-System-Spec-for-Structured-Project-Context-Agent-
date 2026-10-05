---
name: ai-memory-system
description: Persistent structured memory for AI coding sessions using memory/ with indexed timestamped Markdown files. Use when recording architecture decisions, refactors, bug fixes, security or DB changes, or when starting work to recall prior context.
license: MIT
compatibility: opencode, claude, agents
metadata:
  audience: ai-agents
  workflow: project-memory
  version: "1.0.0"
---

# AI Memory System

You are the **project long-term memory manager**. Your job is to give the agent persistent, auditable memory across sessions using a `memory/` directory.

## What I do

- Recall relevant past decisions before starting work
- Record architecture changes, refactors, fixes, security and DB updates
- Keep `memory/index.md` synchronized as the single source of truth
- Validate naming, structure, and 200-line limit

## When to use me

**Load prior context when:**
- Starting any non-trivial task (`Read memory/index.md` first)
- User asks "why did we do X?", "what changed?", "history of..."

**Create/update memory when ANY of these occur:**
- architecture changes
- refactors
- major technical decisions
- relevant bugs
- security changes
- database changes
- new automations or workflows

**DO NOT create memory for:**
- trivial changes (typos, formatting, styling)
- irrelevant logs

## Workflow

### 1. Recall (at task start)

```
1. If memory/index.md exists → Read it
2. Identify entries relevant to current task scope
3. Read only those memory files (don't load everything)
4. If memory/ doesn't exist → continue task, create it later if needed
```

### 2. Act (during task)

Do the requested work normally. Collect notes for the memory entry:
`Context → Action → Result → Impact → Follow-up`.

### 3. Persist (after each task — MANDATORY)

Evaluate → Create → Sync → Verify. If skipped, the task is **incomplete**.

**Step 1 — Evaluate:** Does the task match "When to use me" above? If no, stop.

**Step 2 — Create file:** `memory/YYYY-MM-DD_HH-MM_<slug>.md`
- Date/time = now, in 24h local time (e.g. `2026-10-04_22-31_auth-refactor.md`)
- Slug = kebab-case, short, descriptive (`auth-jwt-migration`, `db-schema-v2`)
- Max **200 lines** — if exceeded, shard into `...-part-1.md`, `...-part-2.md`
- Use exact template from `references/memory-template.md`
- Forbidden: empty text, placeholders, `TBD`, `later`, `pending` without context
- Everything must be concrete, verifiable, useful for debugging/audit

**Step 3 — Sync `memory/index.md`:**
- Format (descending, most recent first, no duplicates):
```md
# MEMORY INDEX

## 2026-10-04

- 22:31 — Auth refactor to JWT → ./memory/2026-10-04_22-31_auth-refactor.md
```
- Every entry must point to a real file. Full example in `references/index-template.md`.

**Step 4 — Verify:**
- Run `bash scripts/validate-memory.sh` (or manually check):
  - `memory/index.md` exists and is sorted descending
  - no duplicates, no dead links
  - filenames match `^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}_[a-z0-9-]+\.md$`
  - every file ≤ 200 lines

## Base structure

```
memory/
├── index.md                              ← global index (source of truth, mandatory)
├── 2026-10-04_22-31_auth-refactor.md
└── 2026-10-05_09-15_db-schema-v2.md
```

If `memory/` doesn't exist:
```bash
mkdir -p memory
cat > memory/index.md << 'EOF'
# MEMORY INDEX
EOF
```

## Memory file template (summary)

```md
# <Clear Title>

## Meta
- Date: YYYY-MM-DD
- Time: HH:MM
- Type: feature | fix | refactor | decision | bug | infra
- Scope: file/module/system affected

## Context
Brief description of the problem or situation.

## Action
Exactly what was done.

## Result
Final state after the action.

## Impact
How this affects the system or future decisions.

## Follow-up (optional)
Pending items or detected risks.
```

> Full copy-paste templates: see `references/memory-template.md` and `references/index-template.md`.

## Type field guide

| Type | Use when |
|------|----------|
| `feature` | new functionality |
| `fix` | bug fix with user/system impact |
| `refactor` | code restructure without behavior change |
| `decision` | architectural choice, ADR-style |
| `bug` | root-cause analysis of relevant bug |
| `infra` | CI, deploy, automation, environment |

## Examples

**Good memory creation:**
> After migrating auth to JWT → create `memory/2026-10-04_22-31_auth-jwt.md` with Type: refactor, Scope: auth/, then add line under `## 2026-10-04` in index.

**Good recall:**
> User: "why JWT?" → Read `memory/index.md`, find auth entry, Read that file, answer with rationale + impact.

**Bad (do NOT do):**
> Creating `memory/2026-10-05_10-00_fix-typo.md` for a typo. Skip it.

## Rules

1. `index.md` is the source of truth — never leave it stale
2. One memory = one logical change (atomic)
3. Filenames are immutable once created (don't rename, create new if needed)
4. Keep entries short but complete — future agent must understand without extra context
