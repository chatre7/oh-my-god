---
description: Distill lessons from receipts.md into SKILL.md, or toggle the crystallization nudge
---

## Usage

- `/crystallize` — run crystallization
- `/crystallize on` — enable nudge after VERIFY
- `/crystallize off` — disable nudge after VERIFY

---

## Toggle (on/off)

If the argument is `on` or `off`, update stat.md and stop:

```bash
bash -c "sed -i 's/^Nudge: .*/Nudge: $ARGS/' /d/cmtn-project/oh-my-god/stat.md"
```

Confirm: "Crystallization nudge set to [on/off]."

---

## Crystallize

1. Read `receipts.md` — focus only on entries since `Last crystallized` date in stat.md
2. Find patterns that appear 2+ times (repeated mistakes, repeated approaches, repeated decisions)
3. For each pattern, decide:
   - New rule for SKILL.md → add under a `## Compiled Lessons` section
   - Existing rule strengthened → note it (don't duplicate)
   - One-off event → skip (not a pattern)
4. Update `.agents/skills/oh-my-god/SKILL.md` — append or update `## Compiled Lessons` section
5. Update stat.md:
   - Set `Last crystallized` to today's date (YYYY-MM-DD)
6. Report: how many patterns found, what was added

### Format for compiled lessons

```markdown
## Compiled Lessons

> Auto-distilled from receipts.md — do not edit manually

- **[Topic]**: [Lesson]. *(seen N times)*
```
