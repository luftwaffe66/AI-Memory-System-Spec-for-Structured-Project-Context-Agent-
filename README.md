# 🧠 AI Memory System Spec

> A structured, enforceable memory framework for AI-assisted software projects.

[![Spec](https://img.shields.io/badge/spec-memory_system-blue?style=for-the-badge&logo=markdown)](./memory.md)
[![Format](https://img.shields.io/badge/format-markdown_%2B_index-8A2BE2?style=for-the-badge)](./memory.md)
[![Enforcement](https://img.shields.io/badge/enforcement-strict-critical?style=for-the-badge)](#-enforcement-rule)
[![License](https://img.shields.io/badge/license-use_freely-green?style=for-the-badge)](#-goal)

<p align="center">
  <img src="https://i.ibb.co/99zNQ9BM/file-000000001cdc81f8aa9850634e3760de.png" alt="AI Memory System Preview" width="100%" />
</p>

**Stop losing context between AI sessions.** This repo defines a deterministic, auditable long-term memory layer based on a `/memory/` directory with indexed, timestamped Markdown files — plus a shared **global memory** (`~/.agents/memory/`) that follows you across every project, repo, and session.

📖 Full normative spec → [`memory.md`](./memory.md)
⚡ Reusable agent skill (`ai-memory-system`) → [`.agents/skills/ai-memory-system/SKILL.md`](./.agents/skills/ai-memory-system/SKILL.md) — works with **Codex, Claude Code, OpenCode, Gemini CLI, Cursor**.

<!-- README-I18N:START -->
**English** | [Español](./README.es.md) | [Português](./README.pt.md) | [Français](./README.fr.md) | [Deutsch](./README.de.md) | [简体中文](./README.zh.md) | [日本語](./README.ja.md) | [한국어](./README.ko.md) | [Русский](./README.ru.md) | [العربية](./README.ar.md)
<!-- README-I18N:END -->

---

## 📑 Table of Contents

- [✨ Why this exists](#-why-this-exists)
- [💡 Core Concept](#-core-concept)
- [🌍 Project vs Global Memory](#-project-vs-global-memory)
- [📏 Memory Rules](#-memory-rules)
- [🧾 Memory File Format](#-memory-file-format)
- [📌 When to Create Memory](#-when-to-create-memory)
- [🛡️ Enforcement Rule](#️-enforcement-rule)
- [🚀 Quick Start](#-quick-start)
- [🤖 Install as Skill](#-install-as-skill)
- [💾 Example](#-example)
- [🎯 Goal](#-goal)

---

## ✨ Why this exists

Modern AI agents lose context between sessions. This system solves that with a **deterministic, auditable memory layer** that:

| Capability | Description |
|------------|-------------|
| 🏛️ **Decisions** | Tracks architectural decisions with rationale |
| 🔧 **Refactors** | Records refactors and system changes |
| 📜 **History** | Maintains a structured, timestamped project history |
| 🔁 **Reproducibility** | Enables reproducibility and traceability |
| 🌍 **Shared memory** | Global store (`~/.agents/memory/`) reuses learnings across ALL projects and repos |

> No more *"why did we do it this way?"* — every important change is documented, indexed, and searchable.

---

## 💡 Core Concept

The repository enforces a `/memory/` folder that acts as the **long-term memory of the project**.

```
📦 your-repo/
 ┣ 📂 memory/
 ┃ ┣ 📄 index.md                    ← global index (source of truth)
 ┃ ┣ 📄 2026-10-04_22-31_auth-refactor.md
 ┃ ┗ 📄 2026-10-05_09-15_db-schema-v2.md
 ┣ 📄 memory.md                     ← this spec (mandatory rules)
 ┗ 📄 README.md
```

It is composed of:

- **`index.md`** → global memory index, the **single source of truth**
- **`*.md` files** → individual, atomic memory entries

---

## 🌍 Project vs Global Memory

Two layers. The agent always reads **both**:

| Layer | Location | Contains |
|-------|----------|----------|
| 📁 PROJECT | `./memory/` in each repo | Repo-specific: this repo's architecture, refactors, bugs |
| 🌍 GLOBAL | `~/.agents/memory/` | Shared across ALL repos/sessions: reusable decisions, patterns, preferences |

**Routing rule:** repo-specific → PROJECT (default). Reusable elsewhere → GLOBAL (`new-memory.sh --global`). When in doubt → PROJECT.

Search both at once:

```bash
bash $SKILL_DIR/scripts/search-memory.sh <keyword> --root .
```

---

## 📏 Memory Rules

### 1. 🗂️ Structure

All memory files must follow strict formatting:

- ✅ Max **200 lines** per file — if exceeded, split (shard) into multiple files
- ✅ Timestamped filename format:

  ```
  YYYY-MM-DD_HH-MM_<slug>.md
  ```

  > Example: `2026-10-04_22-31_auth-refactor.md`

### 2. 🧭 Index System

The `index.md` file:

- 📋 Lists **all** memory entries (no duplicates, no dead links)
- 🔄 Must **always be synchronized** — updated after every change
- ⬇️ Ordered **descending** (most recent first)

**Format:**

```md
# MEMORY INDEX

## 2026-10-04

- 22:31 — Auth refactor → ./memory/2026-10-04_22-31_auth-refactor.md
```

---

## 🧾 Memory File Format

> Each memory file must follow this exact template:

```md
# Title

## Meta
- Date: YYYY-MM-DD
- Time: HH:MM
- Type: feature | fix | refactor | decision | bug | infra
- Scope: file / module / system affected

## Context
Problem or situation description.

## Action
What was done.

## Result
Final outcome.

## Impact
Effect on system or future decisions.

## Follow-up (optional)
Risks or pending tasks.
```

**Writing rules:**

- 🚫 Forbidden: empty text, placeholders, `TBD`, `later`, `pending` without context
- ✅ Everything must be **concrete, verifiable, and useful** for future debugging / audit

> Ready-made templates (memory, decision, bug, refactor, index) live in the skill's `references/` folder.

---

## 📌 When to Create Memory

A memory entry is **required** when:

| ✅ DO create for | 🚫 DO NOT create for |
|------------------|----------------------|
| 🏛️ Architecture changes | ✏️ Typos |
| 🔧 Refactors | 🎨 Formatting / styling |
| 🐛 Important bug fixes | 📝 Irrelevant logs |
| 🔒 Security modifications | |
| 🗄️ Database schema updates | |
| ⚙️ Workflow or automation changes | |
| 💡 Major technical decisions | |

---

## 🛡️ Enforcement Rule

> ⚠️ **After every task, the system must:**

```mermaid
flowchart LR
    A[✅ Finish Task] --> B{Memory required?}
    B -- Yes --> C[📝 Create / Update memory file]
    B -- No --> E[Done]
    C --> D[🔄 Sync index.md]
    D --> F[🔍 Validate integrity of /memory]
    F --> E[Done]
```

1. **Determine** if memory is required
2. **Create / update** memory file
3. **Sync** `index.md`
4. **Validate** integrity of `/memory`

❌ **Failure to do so invalidates the task completion.**

---

## 🚀 Quick Start

```bash
# 1. Create memory directory
mkdir -p memory

# 2. Create the index (source of truth)
cat > memory/index.md << 'EOF'
# MEMORY INDEX

## 2026-10-05

- 09:15 — Initial setup → ./memory/2026-10-05_09-15_initial-setup.md
EOF

# 3. Create your first memory entry
# File: memory/2026-10-05_09-15_initial-setup.md
# (use the template from 🧾 Memory File Format)
```

**Checklist for every AI task:**

- [ ] Did architecture, DB, security, or workflow change? → create memory
- [ ] Filename follows `YYYY-MM-DD_HH-MM_<slug>.md`?
- [ ] File ≤ 200 lines?
- [ ] `index.md` updated and sorted descending?
- [ ] Reusable in other repos? → save globally with `new-memory.sh --global` (goes to `~/.agents/memory/`)

---

## 🤖 Install as Skill

This repo is a ready-to-use **multi-agent skill** (`ai-memory-system`) for **Codex, Claude Code, OpenCode, Gemini CLI, Cursor** (Agent Skills standard: `SKILL.md`).

**Layout** (`.agents/` is canonical — never edit a mirror directly):

```
.agents/skills/ai-memory-system/     ← canonical (Codex, Gemini alias, OpenCode)
.claude/skills/ai-memory-system/     ← mirror (Claude Code)
.gemini/skills/ai-memory-system/     ← mirror (Gemini CLI)
.opencode/skills/ai-memory-system/   ← mirror (OpenCode)
├── SKILL.md                         ← skill definition (Recall → Act → Persist)
├── references/                      ← memory, decision, bug, refactor, index templates
└── scripts/                         ← new-memory, validate-memory, search-memory, install-global, sync-vendors
```

**Global install (recommended — skill + `/memory` in EVERY project):**

```bash
bash .agents/skills/ai-memory-system/scripts/install-global.sh --force
# Restart your agent, then type /memory anywhere
```

It installs the skill to `~/.agents/skills/`, `~/.claude/skills/`, `~/.gemini/skills/`, `~/.config/opencode/skills/`, `~/.cursor/skills/`, the `/memory` command for OpenCode / Claude / Gemini, and creates the shared `~/.agents/memory/` store.

**Per-project (this repo only):** copy `.agents/skills/ai-memory-system` into your agent's skill dir — see `AGENTS.md` §3 for every path.

**Slash command:**

- `/memory` → recall (project + global)
- `/memory save <description>` → persist (routes PROJECT vs GLOBAL)

**Validate after install:**

```bash
bash $SKILL_DIR/scripts/validate-memory.sh --root .                  # project memory
bash $SKILL_DIR/scripts/validate-memory.sh --memdir ~/.agents/memory # global memory
# ✅ memory system is valid
```

> The skill wraps the full [`memory.md`](./memory.md) spec into a Recall → Act → Persist workflow with templates and validation. Agent instructions: [`AGENTS.md`](./AGENTS.md).

---

## 💾 Example

**File:** `memory/2026-10-04_22-31_auth-refactor.md`

```md
# Auth Refactor to JWT

## Meta
- Date: 2026-10-04
- Time: 22:31
- Type: refactor
- Scope: auth/ module

## Context
Session-based auth caused scaling issues with multiple instances.

## Action
Migrated to stateless JWT with refresh-token rotation.

## Result
Auth is now stateless; login latency -30%.

## Impact
Requires `JWT_SECRET` in env. All future services must validate JWT.

## Follow-up
Rotate secrets every 90 days. Add logout blocklist.
```

And in `index.md`:

```md
## 2026-10-04

- 22:31 — Auth refactor to JWT → ./memory/2026-10-04_22-31_auth-refactor.md
```

---

## 🎯 Goal

> To provide AI systems with a **persistent, structured, and auditable memory layer** that improves reasoning continuity across development sessions.

**Principles:** 📐 Deterministic · 🔍 Auditable · 🤖 Agent-enforceable · 🕰️ Time-travelable

---

<p align="center">
  <sub>Built for AI agents that need to <b>remember</b>. 🧠✨</sub><br>
  <a href="./memory.md">📖 Read the full spec</a>
</p>

---

<!-- SEO: keywords for GitHub search and Google indexing -->
<!-- ai-agents, ai-memory, llm-memory, llm, context-management, agent-skills, opencode, claude-skills, prompt-engineering, software-architecture, knowledge-management, developer-tools, documentation, traceability, reproducibility -->

<details>
<summary>🏷️ Keywords</summary>

`ai-agents` · `ai-memory` · `llm` · `llm-memory` · `context-management` · `agent-skills` · `opencode` · `claude-skills` · `prompt-engineering` · `software-architecture` · `knowledge-management` · `developer-tools` · `documentation` · `traceability` · `reproducibility`

</details>
