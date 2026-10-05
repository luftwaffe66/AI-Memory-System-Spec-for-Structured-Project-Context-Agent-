# AI Memory System Spec

A structured memory framework for AI-assisted software projects.

This repository defines a strict, enforceable system for persistent project memory using a `/memory` directory with indexed, timestamped Markdown files.

---

## Purpose

Modern AI agents lose context between sessions. This system solves that by introducing a deterministic, auditable memory layer that:

- Tracks architectural decisions
- Records refactors and system changes
- Maintains a structured project history
- Enables reproducibility and traceability

---

## Core Concept

The repository enforces a `/memory` folder that acts as the long-term memory of the project.

It is composed of:

- `index.md` → global memory index (source of truth)
- `*.md` files → individual memory entries

---

## Memory Rules

### 1. Structure
All memory files must follow strict formatting:

- Max 200 lines per file
- Timestamped filename format:

YYYY-MM-DD_HH-MM_<slug>.md

### 2. Index System
The `index.md` file:
- Lists all memory entries
- Must always be synchronized
- Is updated after every change

Format:
```md
# MEMORY INDEX

## YYYY-MM-DD

- HH:MM — short title → ./memory/file.md


---

3. Memory Format

Each memory file must follow:

# Title

## Meta
- Date:
- Time:
- Type: feature | fix | refactor | decision | bug | infra
- Scope:

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


---

When to Create Memory

A memory entry is required when:

Architecture changes

Refactors

Important bug fixes

Security modifications

Database schema updates

Workflow or automation changes


Do NOT create memory for trivial updates like formatting or typos.


---

Enforcement Rule

After every task, the system must:

1. Determine if memory is required


2. Create/update memory file


3. Sync index.md


4. Validate integrity of /memory



Failure to do so invalidates the task completion.


---

Goal

To provide AI systems with a persistent, structured, and auditable memory layer that improves reasoning continuity across development sessions.
