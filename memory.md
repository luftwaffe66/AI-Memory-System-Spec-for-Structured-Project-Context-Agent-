# MEMORY SYSTEM SPEC (MANDATORY)

## 1. Base structure
- Create a `/memory` folder at the repository root.
- Inside `/memory` there must be:
  - `index.md` (main index file)
  - Individual memory files (`*.md`)

---

## 2. index.md (source of truth)
- Mandatory and must always exist.
- Acts as the global memory index.
- Must be UPDATED AUTOMATICALLY after every:
  - new memory
  - modification
  - relevant refactor

### Index format:
```md
# MEMORY INDEX

## [YYYY-MM-DD]

- HH:MM — <short title> → ./memory/<file>.md
```

- Order: descending (most recent first)
- No duplicates
- Each entry must point to a real file

---

## 3. Memory files
- Location: `/memory/*.md`
- Limit: **maximum 200 lines per file**
- If exceeded:
  - split into multiple files (sharding)
  - update `index.md` for each part

### Required naming:
```md
YYYY-MM-DD_HH-MM_<slug>.md
```

Example:
```md
2026-10-04_22-31_auth-refactor.md
```

---

## 4. Internal structure of each memory file
Each file must follow this format:

```md
# <Clear Title>

## Meta
- Date: YYYY-MM-DD
- Time: HH:MM
- Type: (feature | fix | refactor | decision | bug | infra)
- Scope: (file/module/system affected)

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

---

## 5. Writing rules
- Forbidden:
  - empty text
  - placeholders
  - “TBD”, “later”, “pending” without context
- Everything must be concrete, verifiable, and useful for future debugging/audit.

---

## 6. When to create a memory
Create or update a memory ALWAYS when any of the following occur:

- architecture changes
- refactors
- major technical decisions
- relevant bugs
- security changes
- database changes
- new automations or workflows

DO NOT create a memory for:
- trivial changes (typos, styling)
- irrelevant logs

---

## 7. Consistency and control
The agent must:
- verify that `index.md` is synchronized
- avoid duplicates
- keep naming consistent
- validate the line limit

---

## 8. Critical rule (enforcement)
After EACH task:
1. Evaluate whether a memory is required
2. Create/update the corresponding file
3. Update `index.md`
4. Verify integrity of the `/memory` system

If these steps are not completed → the task is considered incomplete.
