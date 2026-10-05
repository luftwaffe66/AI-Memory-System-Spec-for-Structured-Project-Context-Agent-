# 🧠 مواصفة نظام ذاكرة الذكاء الاصطناعي

> إطار عمل منظم وملزم للذاكرة لمشاريع البرمجيات المدعومة بالذكاء الاصطناعي.

[![Spec](https://img.shields.io/badge/spec-memory_system-blue?style=for-the-badge&logo=markdown)](./memory.md)
[![Format](https://img.shields.io/badge/format-markdown_%2B_index-8A2BE2?style=for-the-badge)](./memory.md)
[![Enforcement](https://img.shields.io/badge/enforcement-strict-critical?style=for-the-badge)](#-قاعدة-التنفيذ)
[![License](https://img.shields.io/badge/license-use_freely-green?style=for-the-badge)](#-الهدف)

**توقف عن فقدان السياق بين جلسات الذكاء الاصطناعي.** يحدد هذا المستودع طبقة ذاكرة طويلة الأمد حتمية وقابلة للتدقيق، مبنية على مجلد `/memory/` مع ملفات Markdown مفهرسة وتحمل طوابع زمنية.

📖 المواصفة المعيارية الكاملة → [`memory.md`](./memory.md)
⚡ مهارة قابلة لإعادة الاستخدام للوكلاء → [`.opencode/skills/ai-memory-system/SKILL.md`](./.opencode/skills/ai-memory-system/SKILL.md)

<!-- README-I18N:START -->
[English](./README.md) | [Español](./README.es.md) | [Português](./README.pt.md) | [Français](./README.fr.md) | [Deutsch](./README.de.md) | [简体中文](./README.zh.md) | [日本語](./README.ja.md) | [한국어](./README.ko.md) | [Русский](./README.ru.md) | **العربية**
<!-- README-I18N:END -->

---

## 📑 جدول المحتويات

- [✨ لماذا هذا موجود](#-لماذا-هذا-موجود)
- [💡 المفهوم الأساسي](#-المفهوم-الأساسي)
- [📏 قواعد الذاكرة](#-قواعد-الذاكرة)
- [🧾 تنسيق ملف الذاكرة](#-تنسيق-ملف-الذاكرة)
- [📌 متى تُنشئ ذاكرة](#-متى-تنشئ-ذاكرة)
- [🛡️ قاعدة التنفيذ](#️-قاعدة-التنفيذ)
- [🚀 البدء السريع](#-البدء-السريع)
- [🤖 التثبيت كمهارة](#-التثبيت-كمهارة)
- [💾 مثال](#-مثال)
- [🎯 الهدف](#-الهدف)

---

## ✨ لماذا هذا موجود

وكلاء الذكاء الاصطناعي الحديثون يفقدون السياق بين الجلسات. يحل هذا النظام المشكلة عبر **طبقة ذاكرة حتمية وقابلة للتدقيق**:

| القدرة | الوصف |
|------------|-------------|
| 🏛️ **القرارات** | يتتبع القرارات المعمارية مع مبرراتها |
| 🔧 **إعادة الهيكلة** | يسجل إعادة الهيكلة وتغييرات النظام |
| 📜 **السجل** | يحافظ على سجل مشروع منظم يحمل طوابع زمنية |
| 🔁 **قابلية إعادة الإنتاج** | يتيح قابلية إعادة الإنتاج والتتبع |

> لا مزيد من *«لماذا فعلنا ذلك بهذه الطريقة؟»* — كل تغيير مهم موثق ومفهرس وقابل للبحث.

---

## 💡 المفهوم الأساسي

يفرض المستودع مجلد `/memory/` يعمل **كذاكرة طويلة الأمد للمشروع**.

```
📦 your-repo/
 ┣ 📂 memory/
 ┃ ┣ 📄 index.md                    ← global index (source of truth)
 ┃ ┣ 📄 2026-10-04_22-31_auth-refactor.md
 ┃ ┗ 📄 2026-10-05_09-15_db-schema-v2.md
 ┣ 📄 memory.md                     ← this spec (mandatory rules)
 ┗ 📄 README.md
```

يتكون من:

- **`index.md`** → فهرس الذاكرة العالمي، **المصدر الوحيد للحقيقة**
- **ملفات `*.md`** → إدخالات ذاكرة فردية وذرية

---

## 📏 قواعد الذاكرة

### 1. 🗂️ الهيكل

يجب أن تتبع جميع ملفات الذاكرة تنسيقًا صارمًا:

- ✅ حد أقصى **200 سطر** لكل ملف — عند التجاوز، قسّم إلى ملفات متعددة
- ✅ تنسيق اسم الملف مع الطابع الزمني:

  ```
  YYYY-MM-DD_HH-MM_<slug>.md
  ```

  > مثال: `2026-10-04_22-31_auth-refactor.md`

### 2. 🧭 نظام الفهرس

ملف `index.md`:

- 📋 يسرد **جميع** إدخالات الذاكرة (بدون تكرار، بدون روابط ميتة)
- 🔄 يجب أن يكون **متزامنًا دائمًا** — يُحدَّث بعد كل تغيير
- ⬇️ مرتب **تنازليًا** (الأحدث أولًا)

**التنسيق:**

```md
# MEMORY INDEX

## 2026-10-04

- 22:31 — Auth refactor → ./memory/2026-10-04_22-31_auth-refactor.md
```

---

## 🧾 تنسيق ملف الذاكرة

> يجب أن يتبع كل ملف ذاكرة هذا القالب بدقة:

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

**قواعد الكتابة:**

- 🚫 ممنوع: النص الفارغ، والعناصر المؤقتة، و`TBD` و`later` و`pending` بدون سياق
- ✅ يجب أن يكون كل شيء **ملموسًا وقابلًا للتحقق ومفيدًا** للتصحيح / التدقيق مستقبلًا

---

## 📌 متى تُنشئ ذاكرة

إدخال الذاكرة **مطلوب** عندما:

| ✅ أنشئ لـ | 🚫 لا تُنشئ لـ |
|------------------|----------------------|
| 🏛️ تغييرات البنية | ✏️ الأخطاء المطبعية |
| 🔧 إعادة الهيكلة | 🎨 التنسيق / الأنماط |
| 🐛 إصلاحات مهمة للأخطاء | 📝 سجلات غير مهمة |
| 🔒 تعديلات الأمان | |
| 🗄️ تحديثات مخطط قاعدة البيانات | |
| ⚙️ تغييرات سير العمل أو الأتمتة | |
| 💡 قرارات تقنية مهمة | |

---

## 🛡️ قاعدة التنفيذ

> ⚠️ **بعد كل مهمة، يجب على النظام:**

```mermaid
flowchart LR
    A[✅ Finish Task] --> B{Memory required?}
    B -- Yes --> C[📝 Create / Update memory file]
    B -- No --> E[Done]
    C --> D[🔄 Sync index.md]
    D --> F[🔍 Validate integrity of /memory]
    F --> E[Done]
```

1. **تحديد** ما إذا كانت الذاكرة مطلوبة
2. **إنشاء / تحديث** ملف الذاكرة
3. **مزامنة** `index.md`
4. **التحقق** من سلامة `/memory`

❌ **عدم القيام بذلك يُبطل إتمام المهمة.**

---

## 🚀 البدء السريع

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

**قائمة تحقق لكل مهمة ذكاء اصطناعي:**

- [ ] هل تغيرت البنية أو قاعدة البيانات أو الأمان أو سير العمل؟ → أنشئ ذاكرة
- [ ] هل يتبع الاسم `YYYY-MM-DD_HH-MM_<slug>.md`؟
- [ ] هل الملف ≤ 200 سطر؟
- [ ] هل `index.md` محدَّث ومرتب تنازليًا؟

---

## 🤖 التثبيت كمهارة

هذا المستودع أيضًا **مهارة جاهزة لـ OpenCode / Claude / Agents** (`ai-memory-system`).

```
.opencode/skills/ai-memory-system/
├── SKILL.md                      ← skill definition (frontmatter + workflow)
├── references/
│   ├── memory-template.md        ← copy-paste memory file template
│   └── index-template.md         ← copy-paste index.md example
└── scripts/
    └── validate-memory.sh        ← integrity checker
```

**استخدمها في مشروعك:**

```bash
# Option A — copy into your project (OpenCode)
mkdir -p .opencode/skills
cp -r /path/to/this-repo/.opencode/skills/ai-memory-system .opencode/skills/

# Option B — global install (all projects)
mkdir -p ~/.config/opencode/skills
cp -r /path/to/this-repo/.opencode/skills/ai-memory-system ~/.config/opencode/skills/

# Claude-compatible paths also work:
# .claude/skills/ , ~/.claude/skills/ , .agents/skills/ , ~/.agents/skills/
```

**تحقق بعد التثبيت:**

```bash
bash .opencode/skills/ai-memory-system/scripts/validate-memory.sh --root .
# ✅ memory/ and index.md exist
# ✅ memory system is valid
```

بعد التثبيت، يكتشفها الوكيل تلقائيًا عبر أداة `skill`:

```
skill({ name: "ai-memory-system" })
```

> تغلف المهارة المواصفة الكاملة [`memory.md`](./memory.md) في سير عمل تذكَّر → نفِّذ → احفظ مع القوالب والتحقق.

---

## 💾 مثال

**الملف:** `memory/2026-10-04_22-31_auth-refactor.md`

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

وفي `index.md`:

```md
## 2026-10-04

- 22:31 — Auth refactor to JWT → ./memory/2026-10-04_22-31_auth-refactor.md
```

---

## 🎯 الهدف

> تزويد أنظمة الذكاء الاصطناعي **بطبقة ذاكرة دائمة ومنظمة وقابلة للتدقيق** تحسن استمرارية الاستدلال عبر جلسات التطوير.

**المبادئ:** 📐 حتمية · 🔍 قابلة للتدقيق · 🤖 قابلة للتنفيذ بواسطة الوكلاء · 🕰️ سفر عبر الزمن

---

<p align="center">
  <sub>مصمم لوكلاء الذكاء الاصطناعي الذين يحتاجون إلى <b>التذكر</b>. 🧠✨</sub><br>
  <a href="./memory.md">📖 اقرأ المواصفة الكاملة</a>
</p>

---

<!-- SEO: keywords for GitHub search and Google indexing -->
<!-- ai-agents, ai-memory, llm-memory, llm, context-management, agent-skills, opencode, claude-skills, prompt-engineering, software-architecture, knowledge-management, developer-tools, documentation, traceability, reproducibility -->

<details>
<summary>🏷️ Keywords</summary>

`ai-agents` · `ai-memory` · `llm` · `llm-memory` · `context-management` · `agent-skills` · `opencode` · `claude-skills` · `prompt-engineering` · `software-architecture` · `knowledge-management` · `developer-tools` · `documentation` · `traceability` · `reproducibility`

</details>
