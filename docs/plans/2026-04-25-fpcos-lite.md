# FPCOS-Lite Cognitive Layer — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the 3 highest-value FPCOS pieces from `docs/specs/2026-04-25-fpcos-lite.md` to oh-my-god — Confidence/Unknowns in receipts, System Lens template in DEBUG, and L0 Reality Anchor in DESIGN.

**Architecture:** All changes land in `.agents/skills/oh-my-god/SKILL.md`. The spec named `.claude/commands/debug.md` for change 2, but debug.md is a 3-line delegator — the actual DEBUG phase body lives in SKILL.md PHASE D, so the template goes there.

**Tech Stack:** Markdown (skill instructions only). No code, no hooks, no new files.

**Dependency:** Do not start until `2026-04-13-solo-developer-optimization` lands receipt format changes in SKILL.md. This plan extends that format.

---

### Task 1: Add Confidence + Unknowns to Receipt Format

**Files:**
- Modify: `.agents/skills/oh-my-god/SKILL.md`

- [ ] **Step 1: Update Per-Task Receipt template (Phase 3 BUILD, around line 400)**

Find the section `### Per-Task Receipt` and append two lines to the example receipt block:

```markdown
## [YYYY-MM-DD HH:MM] | BUILD | [Task name]
- [x] Tests written and watched fail first (RED verified)
- [x] All tests pass — [command output: N/N]
- [x] No scope creep — touched only specified files
- [x] Committed — [commit hash or message]
- Confidence: NN% — [one-line reason]
- Unknowns: [what was NOT verified, or "None" if deliberate]
```

Then add a rules block immediately after:

```markdown
**Confidence/Unknowns rules:**
- Confidence is required on VERIFY receipts, optional on intermediate phase receipts.
- 100% confidence is only allowed when every listed Unknown is resolved.
- "Unknowns: None" must be deliberate, not a default.
```

- [ ] **Step 2: Update Final Receipt template (Phase 6 VERIFY area)**

Find `## FINAL RECEIPT` (or the equivalent in PHASE 6 VERIFY). Append the same two lines to its example:

```markdown
- Confidence: NN% — [one-line reason]
- Unknowns: [remaining risks or "None"]
```

- [ ] **Step 3: Verify**

```bash
grep -n "Confidence:" .agents/skills/oh-my-god/SKILL.md
grep -n "Unknowns:" .agents/skills/oh-my-god/SKILL.md
```

Expected: at least 2 matches each (Per-Task Receipt + Final Receipt).

---

### Task 2: Add System Lens Template to DEBUG Phase

**Files:**
- Modify: `.agents/skills/oh-my-god/SKILL.md`

- [ ] **Step 1: Insert System Lens template into PHASE D: DEBUG (around line 549)**

Find `## PHASE D: DEBUG (when Fix mode)`. Inside its `### Four Phases` block, before the first phase listing, insert:

```markdown
### System Lens — Required Output Before Any Fix Proposal

The DEBUG phase must produce this template, filled in, before proposing any fix:

```markdown
### System Lens
Symptom:
Reproduction:
Observed vs Expected:
Data Flow:
  1. Input →
  2. Processing →
  3. Output →
Variables / State:
  - <name>: source → transformation → failure point
Dependencies touched:
Root Cause Hypothesis:
Evidence supporting hypothesis:
Ruled out:
```

**Rules:**
- No fix proposal until every field has content (or an explicit "N/A — <reason>").
- "Ruled out" must list at least one alternative hypothesis that was actually checked.
- If reproduction is impossible, state why and lower receipt Confidence accordingly.
```

- [ ] **Step 2: Verify**

```bash
grep -n "System Lens" .agents/skills/oh-my-god/SKILL.md
grep -n "Root Cause Hypothesis" .agents/skills/oh-my-god/SKILL.md
```

Expected: matches inside PHASE D: DEBUG section.

---

### Task 3: Add L0 Reality Anchor to DESIGN Phase

**Files:**
- Modify: `.agents/skills/oh-my-god/SKILL.md`

- [ ] **Step 1: Insert Reality Anchor into PHASE 1: DESIGN (after line 92, before existing design options guidance)**

Find `## PHASE 1: DESIGN`. Inside its `### Process` block, as the first required output, insert:

```markdown
### Reality Anchor — Required First Output

Before proposing any design option, separate information into three buckets:

```markdown
### Reality
Knowns (with evidence):
  - <fact> — <file:line | command output | user message>
Inferred (assumptions, may be wrong):
  - <assumption> — <why we are inferring this>
Unknowns (unresolved):
  - <missing info> — <blocks design? yes/no>
```

**Rules:**
- Knowns without an evidence reference are invalid — move them to Inferred.
- Unknowns marked "blocks design: yes" must be resolved (ask user, read file, run command) before proposing options.
- Unknowns marked "blocks design: no" carry forward into the receipt's Unknowns line.
```

- [ ] **Step 2: Verify**

```bash
grep -n "Reality Anchor" .agents/skills/oh-my-god/SKILL.md
grep -n "blocks design" .agents/skills/oh-my-god/SKILL.md
```

Expected: matches inside PHASE 1: DESIGN section.

---

### Task 4: Dogfood — Update One Existing Receipt Example

**Files:**
- Modify: `.agents/skills/oh-my-god/SKILL.md`

- [ ] **Step 1: Update at least one existing receipt example**

Pick one full example receipt in SKILL.md (not the templates from Tasks 1–2 above) and add Confidence + Unknowns lines so readers see a realistic filled-in form, not just a blank template.

- [ ] **Step 2: Verify total added line count**

```bash
git diff --stat .agents/skills/oh-my-god/SKILL.md
```

Expected: under 80 lines added across all 4 tasks (per spec success criteria).

---

## Checkpoint: After all 4 tasks

- [ ] `SKILL.md` Per-Task Receipt template has Confidence and Unknowns lines
- [ ] `SKILL.md` Final Receipt template has Confidence and Unknowns lines
- [ ] `SKILL.md` PHASE D: DEBUG has System Lens template with rules
- [ ] `SKILL.md` PHASE 1: DESIGN has Reality Anchor template with rules
- [ ] At least one filled-in example receipt in SKILL.md uses the new fields
- [ ] Total diff under 80 added lines
- [ ] No other files touched (no new reference files, no hook changes, no debug.md changes)
- [ ] Iron Laws section unchanged
- [ ] Existing 2026-04-13 receipt format intact — only extended, not replaced

---

## Out of Scope (per spec)

- L1 Axiom Gate, L3 Compound Mind, L4 Shadow Gate
- New reference files (fpcos.md, gate-rules.md, receipt-schema.md)
- Receipt validation hooks
- Changes to `.claude/commands/debug.md`, `review.md`, `harden.md`
- Changes to Iron Law wording
- Changes to Express/Thorough/Meticulous mode behavior

If any of these become necessary mid-implementation, stop and write a follow-up spec.
