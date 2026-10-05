# AGENTS.md — Instructions for AI Agents (universal)

> This repo provides the `ai-memory-system` skill. Every agent working here MUST use it.
> Works with: **Codex, Claude Code, OpenCode, Gemini CLI, Cursor** (Agent Skills standard: `SKILL.md`).

## 1. Load the skill first

Before any non-trivial task, read the skill file (canonical first, then fallbacks):

1. `.agents/skills/ai-memory-system/SKILL.md` ← canonical source
2. `.opencode/skills/ai-memory-system/SKILL.md`
3. `.claude/skills/ai-memory-system/SKILL.md`
4. `.gemini/skills/ai-memory-system/SKILL.md`

Normative spec: `memory.md` · Human overview: `README.md`

How each agent invokes it:

| Agent | Skill dir (project) | Skill dir (global) | Slash command |
|-------|---------------------|--------------------|---------------|
| Codex | `.agents/skills/` | `~/.agents/skills/` | auto from description |
| Claude Code | `.claude/skills/` | `~/.claude/skills/` | `/ai-memory-system` (auto) or `/memory` (see `.claude/commands/memory.md`) |
| OpenCode | `.opencode/skills/` (+`.agents/`,`.claude/`) | `~/.config/opencode/skills/` | `/memory` (see `.opencode/commands/memory.md`) or `skill({ name: "ai-memory-system" })` |
| Gemini CLI | `.gemini/skills/` (alias `.agents/skills/`) | `~/.gemini/skills/` (alias `~/.agents/skills/`) | `/memory` (see `.gemini/commands/memory.toml`), skills via `/skills list` |
| Cursor | `.cursor/skills/` | `~/.cursor/skills/` | auto from description |

> Shortcut in OpenCode TUI: `/memory` recalls, `/memory save <desc>` persists.
> Same `/memory` exists for Claude Code and Gemini CLI (their own command files above).

## 2. Mandatory workflow: Recall → Act → Persist

Resolve `$SKILL_DIR` = first existing dir from the list in §1.
Templates: `$SKILL_DIR/references/` · Scripts: `$SKILL_DIR/scripts/`

### Recall (start of task)
1. Read PROJECT `memory/index.md` if it exists (this repo uses `memory.md` as spec + `memory/` as data — don't confuse them).
2. Read GLOBAL `~/.agents/memory/index.md` — shared across ALL repos/sessions. This is how you access previous projects and past learnings from any directory.
3. Load only the memory files relevant to your task scope (both layers). Search helper: `bash $SKILL_DIR/scripts/search-memory.sh <keyword> --root .`
4. If neither exists yet, continue — create entries only if your task qualifies below.

### Act (during task)
Work normally. Collect `Context → Action → Result → Impact → Follow-up` notes as you go.

### Persist (end of task — REQUIRED)
Ask: did I touch architecture, refactor, major decision, relevant bug, security, DB, or automation/workflow?
- **No** (typo, formatting, trivial) → stop, no memory needed.
- **Yes** → route it, then save:
  - 📁 **PROJECT** (`memory/`, default): repo-specific changes of THIS repo.
  - 🌍 **GLOBAL** (`~/.agents/memory/`): reusable knowledge useful in OTHER repos — patterns, conventions, user preferences, cross-project decisions. Scaffold: `bash $SKILL_DIR/scripts/new-memory.sh ... --global`.
  - When in doubt → PROJECT. Promote to GLOBAL only if another repo would benefit.
  1. Create `memory/YYYY-MM-DD_HH-MM_<slug>.md` in the chosen layer (template from `$SKILL_DIR/references/`, max 200 lines)
  2. Sync that layer's `index.md` (descending, no duplicates, no dead links)
  3. Run `bash $SKILL_DIR/scripts/validate-memory.sh --root .` (project) or `--memdir ~/.agents/memory` (global)

Skipping Persist = task **incomplete**.

## 3. How to install this skill in ANOTHER project

> ⚠️ Project-local dirs only work inside their repo. For `/memory` in EVERY project, install GLOBALLY.

```bash
# Recommended: global install (all skills + commands, all agents, all projects)
bash <this-repo>/.agents/skills/ai-memory-system/scripts/install-global.sh --force
# Restart your agent, then type /memory anywhere
```

Manual alternative (per-project only — will NOT appear in other projects):

```bash
# Universal (Codex, Gemini alias, OpenCode) — recommended per-project
mkdir -p .agents/skills
cp -r <this-repo>/.agents/skills/ai-memory-system .agents/skills/

# Claude Code
mkdir -p .claude/skills .claude/commands
cp -r <this-repo>/.agents/skills/ai-memory-system .claude/skills/
cp <this-repo>/.claude/commands/memory.md .claude/commands/

# OpenCode
mkdir -p .opencode/skills .opencode/commands
cp -r <this-repo>/.agents/skills/ai-memory-system .opencode/skills/
cp <this-repo>/.opencode/commands/memory.md .opencode/commands/

# Gemini CLI
mkdir -p .gemini/skills .gemini/commands
cp -r <this-repo>/.agents/skills/ai-memory-system .gemini/skills/
cp <this-repo>/.gemini/commands/memory.toml .gemini/commands/
```

Verify discovery:
- `SKILL.md` must be named in ALL CAPS, frontmatter must contain `name: ai-memory-system` matching the folder name.
- Name regex: `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase, hyphens only).

## 4. How to add a NEW skill to THIS repo

1. Create canonical `.agents/skills/<skill-name>/SKILL.md` with required frontmatter (`name`, `description` 1–1024 chars, optional `license`, `compatibility`, `metadata`).
2. Keep `SKILL.md` lean — put long templates in `references/`, scripts in `scripts/`.
3. Ensure `<skill-name>` == folder name and matches the regex above.
4. Sync to vendor mirrors: `bash .agents/skills/ai-memory-system/scripts/sync-vendors.sh --root .`
5. Document it in `README.md` + this `AGENTS.md`.
6. Test loading in your agent (OpenCode: `skill({ name: "<skill-name>" })` · Claude/Gemini: check skills list).

## 5. Rules

- `memory/index.md` is source of truth — never leave it stale.
- One memory = one logical change. Filenames are immutable.
- No placeholders (`TBD`, `later`) without context. Be concrete and verifiable.
- `.agents/` is canonical — never edit a mirror directly, edit `.agents` then sync.
- Validate with the script before finishing.
