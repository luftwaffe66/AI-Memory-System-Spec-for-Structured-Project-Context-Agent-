# AGENTS.md — Instructions for AI Agents

> This repo provides the `ai-memory-system` skill. Every agent working here MUST use it.

## 1. Load the skill first

Before any non-trivial task, load the skill:

```
skill({ name: "ai-memory-system" })
```

Full definition: `.opencode/skills/ai-memory-system/SKILL.md`
Normative spec: `memory.md`
Human overview: `README.md`
Shortcut in OpenCode TUI: `/memory` (see `.opencode/commands/memory.md`) — `/memory` recalls, `/memory save <desc>` persists.

## 2. Mandatory workflow: Recall → Act → Persist

### Recall (start of task)
1. Read `memory/index.md` if it exists (this repo uses `memory.md` as spec + `memory/` as data — don't confuse them).
2. Load only the memory files relevant to your task scope.
3. If `memory/` doesn't exist yet, continue — create it only if your task qualifies below.

### Act (during task)
Work normally. Collect `Context → Action → Result → Impact → Follow-up` notes as you go.

### Persist (end of task — REQUIRED)
Ask: did I touch architecture, refactor, major decision, relevant bug, security, DB, or automation/workflow?
- **No** (typo, formatting, trivial) → stop, no memory needed.
- **Yes** → you MUST:
  1. Create `memory/YYYY-MM-DD_HH-MM_<slug>.md` (template: `.opencode/skills/ai-memory-system/references/memory-template.md`, max 200 lines)
  2. Sync `memory/index.md` (descending, no duplicates, no dead links — example: `.opencode/skills/ai-memory-system/references/index-template.md`)
  3. Run `bash .opencode/skills/ai-memory-system/scripts/validate-memory.sh --root .`

Skipping Persist = task **incomplete**.

## 3. How to install this skill in ANOTHER project

Copy the whole folder (pick the path your runtime discovers):

```bash
# OpenCode (preferred)
mkdir -p .opencode/skills
cp -r <this-repo>/.opencode/skills/ai-memory-system .opencode/skills/

# Claude-compatible
mkdir -p .claude/skills
cp -r <this-repo>/.opencode/skills/ai-memory-system .claude/skills/

# Agents-compatible
mkdir -p .agents/skills
cp -r <this-repo>/.opencode/skills/ai-memory-system .agents/skills/

# Global (all your projects, OpenCode example)
mkdir -p ~/.config/opencode/skills
cp -r <this-repo>/.opencode/skills/ai-memory-system ~/.config/opencode/skills/
```

Verify discovery:
- `SKILL.md` must be named in ALL CAPS, frontmatter must contain `name: ai-memory-system` matching the folder name.
- Name regex: `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase, hyphens only).

## 4. How to add a NEW skill to THIS repo

1. Create `.opencode/skills/<skill-name>/SKILL.md` with required frontmatter (`name`, `description` 1–1024 chars, optional `license`, `compatibility`, `metadata`).
2. Keep `SKILL.md` lean — put long templates in `references/`, scripts in `scripts/`.
3. Ensure `<skill-name>` == folder name and matches the regex above.
4. Document it in `README.md` + this `AGENTS.md`.
5. Test loading via `skill({ name: "<skill-name>" })`.

## 5. Rules

- `memory/index.md` is source of truth — never leave it stale.
- One memory = one logical change. Filenames are immutable.
- No placeholders (`TBD`, `later`) without context. Be concrete and verifiable.
- Validate with the script before finishing.
